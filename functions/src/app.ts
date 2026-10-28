import type { Hono } from "hono";
import { createApiApp } from "./api";
import type { V1Options } from "./api/v1";
import type { Bindings } from "./env";
import { createWebApp } from "./web";

type App = Hono<{ Bindings: Bindings }>;

/**
 * One Worker serves two hosts (AGENTS.md section 6): the API host gets the
 * JSON API, every other host gets the web app (app-link files and pages).
 * Kept separate from the entry point so tests can run it without Sentry.
 */
export function createApp(options: V1Options = {}): {
  api: App;
  web: App;
  fetch: (request: Request, env: Bindings, ctx?: ExecutionContext) => Response | Promise<Response>;
} {
  const api = createApiApp(options);
  const web = createWebApp();
  return {
    api,
    web,
    fetch: (request, env, ctx) => {
      const host = new URL(request.url).hostname.toLowerCase();
      const target = host === env.API_HOST ? api : web;
      return target.fetch(request, env, ctx);
    },
  };
}
