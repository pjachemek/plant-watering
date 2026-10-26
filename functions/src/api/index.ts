import { captureException } from "@sentry/cloudflare";
import { Hono } from "hono";
import type { Bindings } from "../env";
import { healthHandler } from "../lib/health";
import { securityHeaders } from "../lib/security-headers";
import { problem } from "./problem";

/**
 * The versioned API (api.plants.pampait.pl/v1), the only backend the app talks
 * to (AGENTS.md section 6, ADR-0012). Endpoints, the OpenAPI contract, auth and
 * version enforcement arrive in M2; until then every /v1 path is a 404.
 */
export function createApiApp(): Hono<{ Bindings: Bindings }> {
  const app = new Hono<{ Bindings: Bindings }>();

  app.use("*", securityHeaders);
  app.get("/health", healthHandler);

  app.notFound((c) => problem(c, 404, "not_found", "Not found"));
  app.onError((err, c) => {
    captureException(err);
    console.error("unhandled_error", err.name);
    return problem(c, 500, "internal_error", "Internal error");
  });

  return app;
}
