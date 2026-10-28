import { captureException } from "@sentry/cloudflare";
import { Hono } from "hono";
import type { Bindings } from "../env";
import { healthHandler } from "../lib/health";
import { securityHeaders } from "../lib/security-headers";
import { problem } from "./problem";
import { createV1 } from "./v1";

/**
 * The versioned API (api.plants.pampait.pl/v1), the only backend the app talks
 * to (AGENTS.md section 6, ADR-0012). Routes come from openapi.yaml and every
 * request is validated against it (ADR-0015). Auth and version enforcement
 * arrive in M2 increment 2.3.
 */
export function createApiApp(): Hono<{ Bindings: Bindings }> {
  const app = new Hono<{ Bindings: Bindings }>();

  app.use("*", securityHeaders);
  app.get("/health", healthHandler);
  app.route("/v1", createV1());

  app.notFound((c) => problem(c, 404, "not_found", "Not found"));
  app.onError((err, c) => {
    captureException(err);
    console.error("unhandled_error", err.name);
    return problem(c, 500, "internal_error", "Internal error");
  });

  return app;
}
