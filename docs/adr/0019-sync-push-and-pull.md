# ADR-0019: Sync push and pull as single database calls

- Status: Accepted
- Date: 2026-10-28
- Related: M2 increment 2.6; AGENTS.md sections 5, 6 and 8; ADR-0012, ADR-0014, ADR-0017; FR-2, FR-6; NFR Offline, Sync, Security (data isolation)

## Context

The app's outbox sends changes to `POST /v1/sync/push` and fetches changes from `GET /v1/sync/pull` (AGENTS.md section 5). The contract was fixed in increment 2.2 (ADR-0015). The open questions were:

- where the logic runs;
- how retries stay safe;
- how the conflict rules apply in practice.

A push can carry up to 500 changes. Doing each change as separate queries from the Worker would cost several round trips per change over Hyperdrive. At tens of milliseconds each, that is too slow for "visible to others within 5 s" (NFR Sync).

## Decision

**One database call each:** `sync.push(household, idempotency_key, changes)` and `sync.pull(household, cursor)` (migration `20261028180000_sync.sql`).

- **They run as the caller.** The functions are `security invoker`, and the Worker calls them as the signed-in user (`asUser`, role `authenticated`). Every RLS policy applies, so the functions can do nothing a user's own queries couldn't.
- **Separate from `private`.** That's why they live in their own schema, `sync`, which `authenticated` can use. `private` stays reserved for the elevated functions that only `plantnfc_api` may call (ADR-0018). `anon` and `plantnfc_api` can't call `sync`, and tests check both.
- **Pull is one SQL statement.** The rows and the next cursor therefore come from the same snapshot (ADR-0014). It returns explicit columns, with timestamps in RFC 3339 UTC (`Z`), so nothing outside the contract can leak.

**Safe retries: a change ledger.** `public.sync_changes` records each change id with:

- the household;
- the request's `Idempotency-Key`;
- the result and any problem.

| Change id seen before? | Answer |
| --- | --- |
| No | Applied now; its result is recorded |
| Yes, same `Idempotency-Key` (a retried request) | The original result |
| Yes, new key, and it was applied | `duplicate` |
| Yes, new key, and it was rejected | The original rejection, unchanged |

Rejections are final, so retrying a change never gives a different answer.

The ledger has RLS (members of the household only). Watering events are also idempotent by their own id. Ledger rows will be purged after 90 days by the same scheduled job that purges soft deletes (M5). A change replayed after that would be applied again: harmless for waterings, and at worst a stale field value for plant edits.

**Each change is applied on its own.** Every change runs in a savepoint, so a rejected change rolls back alone and the rest still apply, in request order.

| Rejection | Status | Examples |
| --- | --- | --- |
| `invalid_change` | 422 | Wrong or missing patch; a field sync can't set; a data rule broken (a custom plant without intervals); a token change; household delete; a photo outside the plant's folder |
| `not_found` | 404 | The row, or the plant it refers to, isn't in this household or was deleted |
| `conflict` | 409 | The id or tag token is already in use elsewhere (without saying where) |

Any other error (a lost connection, a bug) fails the whole push with 5xx. The client then retries instead of dropping its changes.

**Conflict rules in practice** (AGENTS.md section 5):

- **Plants and households:**
  - Only the fields listed in `fields` change, so edits to different fields from different phones all survive (last write wins per field, in arrival order).
  - A listed field that's absent from the patch is cleared.
  - Households can only change their settings through sync. They are created and left through their own endpoints (ADR-0018).
- **Deletes are soft and final.**
  - An edit that arrives after a delete is rejected (`not_found`); the delete wins.
  - Deleting a plant unlinks its tag, so the sticker can be linked again (FR-6).
- **Tags:**
  - A tag's token never changes; a rewritten sticker is a new tag.
  - Linking a tag to a plant unlinks the plant's previous tag, so the newest link wins and replacing a lost sticker is one change.
  - `written_by` is the caller whenever `written_at` is set.
- **Watering events:**
  - They are append-only, and `delete` is the undo.
  - The author (`user_id`) is always the caller, never taken from the request.
  - A `watered_at` in the future (a phone with its clock ahead) is clamped to the server's time, so next-due dates stay sane.

**Pull returns the whole delta at once, without pages.** A household's data is small: about 500 watering events a year for 10 plants, around 100 KB as JSON. If that ever grows too large, pages can be added to the contract without breaking it.

## Consequences

- Push and pull each cost one round trip over Hyperdrive, plus the transaction setup.
- Sync rules live in PL/pgSQL. pgTAP tests check access (`supabase/tests/04_sync.test.sql`). Worker tests check the behaviour across separate transactions, as two devices would (`functions/test/sync.test.ts`): cursors, retries, offline edits on two phones, undo, tags and every kind of rejection.
- `AGENTS.md` section 8 lists `sync_changes`.
- After an accepted push, the live-updates signal to other devices arrives in increment 2.7.
