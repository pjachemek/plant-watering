import type { Context } from "hono";
import { asUser, rows, withDb } from "../../db/client";
import { LIVE_EXPIRES_HEADER, LIVE_USER_HEADER } from "../../live/household-live";
import type { OpenLiveUpdatesData } from "../generated/types.gen";
import { problem } from "../problem";
import type { OperationHandler, V1Env } from "../v1";

/** Fallback when a token carries no expiry: Supabase's default lifetime. */
const DEFAULT_TOKEN_SECONDS = 3600;

function householdLive(c: Context<V1Env>, householdId: string) {
  const namespace = c.env.HOUSEHOLD_LIVE;
  return namespace.get(namespace.idFromName(householdId));
}

/**
 * GET /v1/live (ADR-0013, ADR-0020): upgrades to a WebSocket on the
 * household's Durable Object. Members only; anyone else gets 404, as for
 * every household they can't see.
 */
export const openLiveUpdates: OperationHandler = async (c) => {
  const { household_id } = c.get("input").query as OpenLiveUpdatesData["query"];
  const user = c.get("user");

  const [row] = await withDb(c.env, (db) =>
    asUser(db, user, (tx) =>
      rows<{ member: boolean }>(tx, "select public.is_member($1) as member", [household_id]),
    ),
  );
  if (!row?.member) return problem(c, 404, "not_found", "Not found");

  const expires = user.claims.exp ?? Math.floor(Date.now() / 1000) + DEFAULT_TOKEN_SECONDS;
  // A fresh internal request: only what the Durable Object needs, and the
  // identity headers can't come from the client.
  const res = await householdLive(c, household_id).fetch("https://live.internal/", {
    headers: {
      Upgrade: "websocket",
      [LIVE_USER_HEADER]: user.id,
      [LIVE_EXPIRES_HEADER]: String(expires),
    },
  });
  if (res.status === 429) {
    return problem(c, 429, "too_many_connections", "Too many open connections");
  }
  if (!res.webSocket) return problem(c, 500, "internal_error", "Internal error");
  return new Response(null, { status: 101, webSocket: res.webSocket });
};

/**
 * Runs [work] on the household's Durable Object after the response, without
 * delaying or failing it: a lost signal only delays a pull until the next
 * app resume (ADR-0013).
 */
function inBackground(c: Context<V1Env>, work: Promise<unknown>): void {
  const settled = work.catch((error: unknown) => {
    console.error("live_signal_failed", error instanceof Error ? error.name : "unknown");
  });
  try {
    c.executionCtx.waitUntil(settled);
  } catch {
    // No execution context (tests calling the app directly): it still runs.
  }
}

/** Tells the household's open apps that something changed. */
export function signalChanged(c: Context<V1Env>, householdId: string): void {
  inBackground(c, householdLive(c, householdId).changed());
}

/** Closes a former member's sockets and tells the rest the members changed. */
export function signalLeft(c: Context<V1Env>, householdId: string, userId: string): void {
  const live = householdLive(c, householdId);
  inBackground(
    c,
    live.disconnect(userId).then(() => live.changed()),
  );
}
