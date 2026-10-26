import { captureException } from "@sentry/cloudflare";
import { Hono } from "hono";
import type { Bindings } from "./env";
import { healthHandler } from "./lib/health";
import { securityHeaders } from "./lib/security-headers";
import { tagPage } from "./routes/tag-page";
import { wellKnown } from "./routes/well-known";

/**
 * The app domain (plants.pampait.pl): app-link files and web pages for people
 * without the app. No data API here; that lives on the API host.
 */
export function createWebApp(): Hono<{ Bindings: Bindings }> {
  const app = new Hono<{ Bindings: Bindings }>();

  app.use("*", securityHeaders);
  app.get("/health", healthHandler);
  app.route("/.well-known", wellKnown);
  app.route("/p", tagPage);

  app.notFound((c) => c.text("Not found", 404));
  app.onError((err, c) => {
    // Hono handles the error itself, so report it explicitly; respond generically.
    captureException(err);
    console.error("unhandled_error", err.name);
    return c.text("Internal error", 500);
  });

  return app;
}
