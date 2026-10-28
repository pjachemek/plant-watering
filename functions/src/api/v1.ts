import { Hono, type Context, type MiddlewareHandler } from "hono";
import type { JWTVerifyGetKey } from "jose";
import { z } from "zod";
import type { Bindings } from "../env";
import { bearerToken, supabaseKeys, verifyAccessToken, type AuthUser } from "./auth";
import { operations, type OperationId } from "./generated/operations.gen";
import * as schemas from "./generated/zod.gen";
import { problem } from "./problem";
import {
  compareVersions,
  envVersionPolicy,
  type Platform,
  type VersionPolicySource,
} from "./versions";

type Location = "header" | "path" | "query" | "body" | "response";

/** Request parts after validation against the contract. */
export interface ValidatedInput {
  headers?: unknown;
  path?: unknown;
  query?: unknown;
  body?: unknown;
}

export interface V1Env {
  Bindings: Bindings;
  Variables: {
    operationId: OperationId;
    input: ValidatedInput;
    platform: Platform;
    /** Set on operations that require sign-in. */
    user: AuthUser;
  };
}

export type OperationHandler = (c: Context<V1Env>) => Response | Promise<Response>;

/** Pluggable dependencies, so tests can use local keys. */
export interface V1Options {
  handlers?: Partial<Record<OperationId, OperationHandler>>;
  signingKeys?: (env: Bindings) => JWTVerifyGetKey;
  versionPolicy?: VersionPolicySource;
}

const PART_SUFFIX = {
  header: "Headers",
  path: "Path",
  query: "Query",
  body: "Body",
  response: "Response",
} as const;

/**
 * The generated Zod schema for one part of an operation, by the generator's
 * naming convention: `z` + OperationId + Headers | Path | Query | Body | Response.
 */
export function schemaFor(operationId: OperationId, location: Location): z.ZodType | undefined {
  const name = `z${operationId.charAt(0).toUpperCase()}${operationId.slice(1)}${PART_SUFFIX[location]}`;
  const value: unknown = (schemas as Record<string, unknown>)[name];
  return value instanceof z.ZodType ? value : undefined;
}

interface Issue {
  location: Location;
  pointer: string;
  code: string;
}

function issuesOf(location: Location, error: z.ZodError): Issue[] {
  return error.issues.map((i) => ({
    location,
    pointer: i.path.map(String).join("."),
    code: i.code,
  }));
}

function invalidRequest(c: Context, issues: Issue[]): Response {
  return problem(c, 400, "invalid_request", "The request doesn't match the API contract", {
    errors: issues,
  });
}

/** Header names as the spec spells them, read case-insensitively. */
function readHeaders(c: Context<V1Env>, schema: z.ZodType): Record<string, string | undefined> {
  const names = schema instanceof z.ZodObject ? Object.keys(schema.shape) : [];
  return Object.fromEntries(names.map((name) => [name, c.req.header(name)]));
}

/**
 * Step 1: the contract headers, including X-App-Version, X-Platform and
 * X-API-Version on every operation. Violations say where, never what.
 */
function validateHeaders(operationId: OperationId): MiddlewareHandler<V1Env> {
  const schema = schemaFor(operationId, "header");
  return async (c, next) => {
    c.set("operationId", operationId);
    c.set("input", {});
    if (schema) {
      const result = schema.safeParse(readHeaders(c, schema));
      if (!result.success) return invalidRequest(c, issuesOf("header", result.error));
      c.set("input", { headers: result.data });
    }
    c.set("platform", c.req.header("X-Platform") === "ios" ? "ios" : "android");
    await next();
  };
}

/**
 * Step 2: below the minimum app version, 426 (FR-10). Runs before sign-in so
 * an outdated app sees the update screen even with an expired session.
 */
function versionGate(source: VersionPolicySource): MiddlewareHandler<V1Env> {
  return async (c, next) => {
    const appVersion = c.req.header("X-App-Version") ?? "0.0.0";
    const policy = await source(c.get("platform"), c.env);
    if (compareVersions(appVersion, policy.min_version) < 0) {
      return problem(c, 426, "upgrade_required", "This app version is no longer supported");
    }
    await next();
  };
}

/** Step 3: a valid Supabase access token (AGENTS.md section 6). */
function authenticate(keysFor: (env: Bindings) => JWTVerifyGetKey): MiddlewareHandler<V1Env> {
  return async (c, next) => {
    const result = await verifyAccessToken(
      bearerToken(c.req.header("Authorization")),
      keysFor(c.env),
      c.env.SUPABASE_URL,
    );
    if (!result.ok) {
      if (result.reason === "unavailable") {
        c.header("Retry-After", "5");
        return problem(c, 503, "auth_unavailable", "Sign-in can't be checked right now");
      }
      c.header("WWW-Authenticate", 'Bearer realm="plants"');
      return problem(c, 401, "unauthorized", "Sign-in required");
    }
    c.set("user", result.user);
    await next();
  };
}

/** Step 4: per user when signed in, per IP otherwise (AGENTS.md section 6). */
function rateLimit(perUser: boolean): MiddlewareHandler<V1Env> {
  return async (c, next) => {
    const limiter = perUser ? c.env.USER_RATE_LIMITER : c.env.IP_RATE_LIMITER;
    const key = perUser
      ? `u:${c.get("user").id}`
      : `ip:${c.req.header("CF-Connecting-IP") ?? "unknown"}`;
    const { success } = await limiter.limit({ key });
    if (!success) {
      c.header("Retry-After", "60");
      return problem(c, 429, "rate_limited", "Too many requests");
    }
    await next();
  };
}

/** Step 5: path, query and JSON body. */
function validateRequest(operationId: OperationId): MiddlewareHandler<V1Env> {
  const pathSchema = schemaFor(operationId, "path");
  const querySchema = schemaFor(operationId, "query");
  const bodySchema = schemaFor(operationId, "body");

  return async (c, next) => {
    const input = c.get("input");
    const issues: Issue[] = [];
    const check = (
      location: "path" | "query" | "body",
      schema: z.ZodType | undefined,
      raw: unknown,
    ) => {
      if (!schema) return;
      const result = schema.safeParse(raw);
      if (result.success) input[location] = result.data;
      else issues.push(...issuesOf(location, result.error));
    };

    check("path", pathSchema, c.req.param());
    check("query", querySchema, c.req.query());
    if (bodySchema) {
      let body: unknown;
      try {
        body = await c.req.json();
      } catch {
        return problem(c, 400, "invalid_json", "The request body is not valid JSON");
      }
      check("body", bodySchema, body);
    }
    if (issues.length > 0) return invalidRequest(c, issues);
    c.set("input", input);
    await next();
  };
}

/**
 * Sends a handler's result after validating it against the operation's
 * response schema. Data that breaks the contract is never sent (section 6).
 */
export function respond(
  c: Context<V1Env>,
  data: unknown,
  status: 200 | 201 = 200,
  headers: Record<string, string> = {},
): Response {
  const schema = schemaFor(c.get("operationId"), "response");
  if (schema && !schema.safeParse(data).success) {
    console.error("invalid_response", c.get("operationId"));
    return problem(c, 500, "invalid_response", "Internal error");
  }
  return c.json(data, status, headers);
}

const notImplemented: OperationHandler = (c) =>
  problem(c, 501, "not_implemented", "Not implemented yet");

/** GET /v1/config: the version policy for the calling platform (FR-10). */
function configHandler(source: VersionPolicySource): OperationHandler {
  return async (c) => {
    const platform = c.get("platform");
    const policy = await source(platform, c.env);
    return respond(c, { platform, ...policy, api_version: "1", features: {} }, 200, {
      "Cache-Control": "public, max-age=300",
      Vary: "X-Platform",
    });
  };
}

/**
 * Builds the /v1 router from the operations in openapi.yaml (ADR-0015).
 * Operations without a handler answer 501 until their increment lands.
 */
export function createV1(options: V1Options = {}): Hono<V1Env> {
  const versionPolicy = options.versionPolicy ?? envVersionPolicy;
  const signingKeys = options.signingKeys ?? ((env: Bindings) => supabaseKeys(env.SUPABASE_URL));
  const handlers: Partial<Record<OperationId, OperationHandler>> = {
    getConfig: configHandler(versionPolicy),
    ...options.handlers,
  };

  const v1 = new Hono<V1Env>();
  for (const op of operations) {
    const chain: MiddlewareHandler<V1Env>[] = [
      validateHeaders(op.operationId),
      versionGate(versionPolicy),
    ];
    if (op.auth) chain.push(authenticate(signingKeys));
    chain.push(rateLimit(op.auth), validateRequest(op.operationId));
    // Arrays select the variadic overload of on(), which accepts a spread chain.
    v1.on(
      [op.method.toUpperCase()],
      [op.honoPath],
      ...chain,
      handlers[op.operationId] ?? notImplemented,
    );
  }
  return v1;
}
