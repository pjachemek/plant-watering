import type { Context } from "hono";
import type { ContentfulStatusCode } from "hono/utils/http-status";

/**
 * RFC 9457 problem details. Every API error uses this shape, so the app can
 * handle errors uniformly. `type` is a stable machine-readable code; never put
 * user data in `detail` or in `extra`.
 */
export function problem(
  c: Context,
  status: ContentfulStatusCode,
  type: string,
  title: string,
  extra: Record<string, unknown> = {},
): Response {
  return c.body(JSON.stringify({ ...extra, type, title, status }), status, {
    "Content-Type": "application/problem+json",
    "Cache-Control": "no-store",
  });
}
