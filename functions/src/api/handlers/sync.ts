import { asUser, rows, withDb } from "../../db/client";
import type { SyncPullData, SyncPushData } from "../generated/types.gen";
import { problem } from "../problem";
import { respond, type OperationHandler } from "../v1";
import { signalChanged } from "./live";

/**
 * POST /v1/sync/push (AGENTS.md section 5). One database call applies the
 * changes in order as the user, so RLS decides what they touch; each change
 * gets its own result, and retries are safe (ADR-0019).
 */
export const syncPush: OperationHandler = async (c) => {
  const input = c.get("input");
  const body = input.body as SyncPushData["body"];
  const { "Idempotency-Key": idempotencyKey } = input.headers as SyncPushData["headers"];

  const [row] = await withDb(c.env, (db) =>
    asUser(db, c.get("user"), (tx) =>
      rows<{ results: { status: string }[] | null }>(
        tx,
        "select sync.push($1, $2, $3::jsonb) as results",
        [body.household_id, idempotencyKey, JSON.stringify(body.changes)],
      ),
    ),
  );
  if (!row?.results) return problem(c, 404, "not_found", "Not found");
  // Other open apps pull within a second (FR-2, ADR-0020).
  if (row.results.some((r) => r.status === "applied")) signalChanged(c, body.household_id);
  return respond(c, { results: row.results });
};

/**
 * GET /v1/sync/pull (AGENTS.md section 5). Rows written since the cursor,
 * with the next cursor, from one snapshot (ADR-0014).
 */
export const syncPull: OperationHandler = async (c) => {
  const { household_id, cursor } = c.get("input").query as SyncPullData["query"];

  const [row] = await withDb(c.env, (db) =>
    asUser(db, c.get("user"), (tx) =>
      rows<{ pull: unknown }>(tx, "select sync.pull($1, $2::xid8) as pull", [
        household_id,
        cursor ?? "0",
      ]),
    ),
  );
  if (!row?.pull) return problem(c, 404, "not_found", "Not found");
  return respond(c, row.pull);
};
