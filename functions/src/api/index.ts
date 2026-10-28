import { captureException } from "@sentry/cloudflare";
import { Hono } from "hono";
import type { Bindings } from "../env";
import { healthHandler } from "../lib/health";
import { securityHeaders } from "../lib/security-headers";
import { problem } from "./problem";
import { DatabaseUnavailable } from "../db/client";
import { createDbVersionPolicy } from "../db/version-policy";
import { createHousehold, leaveHousehold, listHouseholds } from "./handlers/households";
import { acceptInvite, createInvite } from "./handlers/invites";
import { createV1, type V1Options } from "./v1";

/** No database binding, or the database can't be reached: worth a retry. */
function isDatabaseUnavailable(err: Error): boolean {
  if (err instanceof DatabaseUnavailable) return true;
  const code = (err as { code?: unknown }).code;
  return typeof code === "string" && /^(CONNECT|CONNECTION_|ECONNREFUSED)/.test(code);
}

/**
 * The versioned API (api.plants.pampait.pl/v1), the only backend the app talks
 * to (AGENTS.md section 6, ADR-0012). Routes come from openapi.yaml and every
 * request is validated against it (ADR-0015). Auth and version enforcement
 * arrive in M2 increment 2.3.
 */
export function createApiApp(options: V1Options = {}): Hono<{ Bindings: Bindings }> {
  const app = new Hono<{ Bindings: Bindings }>();

  app.use("*", securityHeaders);
  app.get("/health", healthHandler);
  app.route(
    "/v1",
    createV1({
      ...options,
      versionPolicy: options.versionPolicy ?? createDbVersionPolicy(),
      handlers: {
        listHouseholds,
        createHousehold,
        leaveHousehold,
        createInvite,
        acceptInvite,
        ...options.handlers,
      },
    }),
  );

  app.notFound((c) => problem(c, 404, "not_found", "Not found"));
  app.onError((err, c) => {
    if (isDatabaseUnavailable(err)) {
      console.error("database_unavailable", err.name);
      c.header("Retry-After", "5");
      return problem(c, 503, "database_unavailable", "The service is temporarily unavailable");
    }
    captureException(err);
    console.error("unhandled_error", err.name);
    return problem(c, 500, "internal_error", "Internal error");
  });

  return app;
}
