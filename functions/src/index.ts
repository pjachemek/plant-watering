import * as Sentry from "@sentry/cloudflare";
import { createApp } from "./app";
import type { Bindings } from "./env";
import { scrubEvent } from "./lib/sentry";

const app = createApp();

export default Sentry.withSentry(
  (env: Bindings) => ({
    // An empty DSN disables Sentry, which is the default for local dev and tests.
    dsn: env.SENTRY_DSN ?? "",
    environment: env.APP_ENV,
    ...(env.SENTRY_RELEASE ? { release: env.SENTRY_RELEASE } : {}),
    dataCollection: {
      userInfo: false,
      cookies: false,
      httpHeaders: { request: { allow: ["user-agent", "content-type"] }, response: false },
      httpBodies: [],
      urlQueryParams: false,
      stackFrameVariables: false,
    },
    tracesSampleRate: 0,
    beforeSend: scrubEvent,
  }),
  { fetch: app.fetch } satisfies ExportedHandler<Bindings>,
);
