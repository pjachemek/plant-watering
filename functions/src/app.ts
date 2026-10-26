import { captureException } from "@sentry/cloudflare";
import { Hono } from "hono";
import { secureHeaders } from "hono/secure-headers";
import type { Bindings } from "./env";
import { tagPage } from "./routes/tag-page";
import { wellKnown } from "./routes/well-known";

/**
 * Builds the Hono app. Kept separate from the Worker entry point so tests can
 * exercise routes without Sentry wrapping.
 */
export function createApp(): Hono<{ Bindings: Bindings }> {
  const app = new Hono<{ Bindings: Bindings }>();

  app.use(
    "*",
    secureHeaders({
      strictTransportSecurity: "max-age=63072000; includeSubDomains; preload",
      referrerPolicy: "no-referrer",
      contentSecurityPolicy: {
        defaultSrc: ["'none'"],
        styleSrc: ["'self'", "'unsafe-inline'"],
        imgSrc: ["'self'", "data:", "https:"],
        baseUri: ["'none'"],
        formAction: ["'none'"],
        frameAncestors: ["'none'"],
      },
    }),
  );

  app.get("/health", (c) =>
    c.json({ status: "ok", env: c.env.APP_ENV }, 200, {
      "Cache-Control": "no-store",
    }),
  );

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
