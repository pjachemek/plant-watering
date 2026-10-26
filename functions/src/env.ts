/**
 * Bindings available to every Worker request: the vars generated into
 * worker-configuration.d.ts plus secrets set with `wrangler secret put`.
 * Secrets are optional so local dev and tests run without them.
 */
export type Bindings = Env & {
  SENTRY_DSN?: string;
  SENTRY_RELEASE?: string;
};
