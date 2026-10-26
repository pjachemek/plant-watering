import type { Context } from "hono";
import type { Bindings } from "../env";

/** Uptime check, served on both hosts. */
export const healthHandler = (c: Context<{ Bindings: Bindings }>) =>
  c.json({ status: "ok", env: c.env.APP_ENV }, 200, { "Cache-Control": "no-store" });
