import { Hono, type Context, type MiddlewareHandler } from "hono";
import { z } from "zod";
import type { Bindings } from "../env";
import { operations, type OperationId } from "./generated/operations.gen";
import * as schemas from "./generated/zod.gen";
import { problem } from "./problem";

type Location = "header" | "path" | "query" | "body";

/** Request parts after validation against the contract. */
export interface ValidatedInput {
  headers?: unknown;
  path?: unknown;
  query?: unknown;
  body?: unknown;
}

export interface V1Env {
  Bindings: Bindings;
  Variables: { input: ValidatedInput };
}
export type OperationHandler = (c: Context<V1Env>) => Response | Promise<Response>;

const PART_SUFFIX = { header: "Headers", path: "Path", query: "Query", body: "Body" } as const;

/**
 * The generated Zod schema for one part of an operation, by the generator's
 * naming convention: `z` + OperationId + Headers | Path | Query | Body.
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

/** Header names as the spec spells them, read case-insensitively. */
function readHeaders(c: Context<V1Env>, schema: z.ZodType): Record<string, string | undefined> {
  const names = schema instanceof z.ZodObject ? Object.keys(schema.shape) : [];
  return Object.fromEntries(names.map((name) => [name, c.req.header(name)]));
}

/**
 * Validates headers, path, query and body against the generated schemas.
 * A violation is a 400 problem listing where the request is wrong, never
 * the submitted values (NFR Privacy).
 */
function validate(operationId: OperationId): MiddlewareHandler<V1Env> {
  const headerSchema = schemaFor(operationId, "header");
  const pathSchema = schemaFor(operationId, "path");
  const querySchema = schemaFor(operationId, "query");
  const bodySchema = schemaFor(operationId, "body");

  return async (c, next) => {
    const input: ValidatedInput = {};
    const issues: Issue[] = [];
    const check = (location: Location, schema: z.ZodType | undefined, raw: unknown) => {
      if (!schema) return;
      const result = schema.safeParse(raw);
      if (result.success) {
        input[location === "header" ? "headers" : location] = result.data;
      } else {
        issues.push(...issuesOf(location, result.error));
      }
    };

    if (headerSchema) check("header", headerSchema, readHeaders(c, headerSchema));
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

    if (issues.length > 0) {
      return problem(c, 400, "invalid_request", "The request doesn't match the API contract", {
        errors: issues,
      });
    }
    c.set("input", input);
    await next();
  };
}

const notImplemented: OperationHandler = (c) =>
  problem(c, 501, "not_implemented", "Not implemented yet");

/**
 * Builds the /v1 router from the operations in openapi.yaml. Every operation
 * is registered and validated; operations without a handler answer 501
 * until their increment lands (M2 plan).
 */
export function createV1(
  handlers: Partial<Record<OperationId, OperationHandler>> = {},
): Hono<V1Env> {
  const v1 = new Hono<V1Env>();
  for (const op of operations) {
    v1.on(
      op.method.toUpperCase(),
      op.honoPath,
      validate(op.operationId),
      handlers[op.operationId] ?? notImplemented,
    );
  }
  return v1;
}
