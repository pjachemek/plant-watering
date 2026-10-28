# ADR-0014: Core schema, RLS and the sync cursor

- Status: Accepted
- Date: 2026-10-28
- Related: M2 increment 2.1; AGENTS.md sections 5, 6 and 8; NFR Security (data isolation), Scalability, Offline

## Context

M2 starts with the database. The brief fixes the tables (section 8), RLS through `is_member()` (section 6), soft deletes, append-only watering events, and a delta pull "`updated_at > last_sync`" (section 5). Clients never reach the tables; the Worker queries them as the signed-in user (ADR-0012).

## Decision

**Sync cursor: transaction IDs, not timestamps.** Every synced row has `change_xid xid8`, set by a trigger to `pg_current_xact_id()` on every insert and update.

- A pull returns rows with `change_xid >= cursor`.
- The new cursor is `pg_snapshot_xmin(pg_current_snapshot())`, taken at the start of the pull: the oldest transaction still running. Every transaction below it has either committed or aborted.

Timestamps can't give that guarantee. A transaction that started earlier but commits later carries an older `updated_at` than the cursor, and its change would never be pulled. With `xid8`, the worst case is a row sent twice, which sync applies idempotently. `updated_at` is still kept for display and debugging.

**Integrity in the database, not only in the Worker:**

- **Composite foreign keys** `(plant_id, household_id)` from `tags` and `watering_events` to `plants (id, household_id)`. A child row can't point at another household's plant, even through a Worker bug. Purging a plant unlinks its tag (`on delete set null (plant_id)`) instead of deleting it.
- **`household_id` never changes** (trigger).
- **Watering events are append-only** (trigger). The only allowed changes are setting `deleted_at` (undo), which can't be reverted, and clearing `user_id` when an account is deleted, so the household keeps its history (FR-9).
- **Custom plants** (no `preset_id`) must carry intervals, amount and method.
- **One active tag per plant** (partial unique index), and tag tokens must match the app's format (22 base62 characters).
- **Invite codes are stored as SHA-256 hex only**, and expire within 7 days.

**Access:**

- RLS is enabled on every table, and `revoke all` from `anon` and `authenticated` comes first; then explicit grants per table. No table has a delete grant: deletes are soft.
- `is_member(household_id)` is `security definer` with an empty `search_path`. All household policies use it.
- **Households and memberships are never inserted directly.** A new household has no members for a policy to check against, so creating a household and redeeming an invite will be private server functions (increment 2.5).
- Watering events can only be logged as yourself (`user_id = auth.uid()`). Any member can undo, because members have equal rights.
- `devices` and `notification_prefs` are per user (`user_id = auth.uid()`).
- `digest_sends` and `client_versions` have no client grants; only server code reads them.

**Additions to the section 8 tables:**

- `change_xid` on synced tables (above).
- `client_versions (platform, min_version, recommended_version)`, used by `GET /v1/config` and `426 Upgrade Required` (section 6, FR-10). Seeded with `0.1.0`.
- `notification_prefs` is keyed by `user_id` and has no `household_id` or `deleted_at`, because it belongs to a person, not a household.

**Indexes:** every foreign key, every sync cursor `(household_id, change_xid)`, and `watering_events (plant_id, household_id, watered_at desc)` (NFR Scalability).

## Tests

`supabase/tests/01_schema_and_rls.test.sql` (pgTAP) runs as the signed-in user, the way the Worker will. It checks:

- Each table hides the other household's rows, and every kind of write into it fails.
- Rows can't move or be linked across households.
- Anonymous callers are denied.
- The append-only and undo rules, the integrity checks, the cursor stamping, purge unlinking tags, and account deletion keeping history.
- Leaving a household removes access.
- Two structural checks: RLS is enabled on every public table, and every foreign key has an index.

## Consequences

- `AGENTS.md` section 5 now names the cursor; section 8 lists the additions.
- Pulls must read the cursor in the same transaction as the rows (increment 2.6).
- `xid8` values are 64-bit and never wrap, so cursors stay valid for the life of the database. A restore from backup may move transaction IDs, so after a restore every client does a full re-sync. That's noted for the M7 backup and restore test.
