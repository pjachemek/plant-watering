# ADR-0024: Local database and outbox

- Status: Accepted
- Date: 2026-10-29
- Related: M2 increment 2.9b; AGENTS.md sections 4, 5 and 8; ADR-0014, ADR-0019; NFR Offline, Performance

## Context

The app is offline-first: the local database is the source of truth for the UI, and user actions write to it and append to an outbox in the same transaction (AGENTS.md section 5). Drift is the chosen local database (section 4).

## Decision

**Drift on SQLite, in a background isolate** (`drift_flutter`), in one file in the app's private storage. App backup is off, so the file never leaves the phone.

**Tables mirror the contract, not the server:**
- `households`, `members`, `plants`, `tags` and `watering_events` hold the API's fields (`functions/openapi.yaml`).
- The server's bookkeeping (`change_xid`, the ledger) stays on the server.
- There are no foreign keys locally: pulled rows may arrive in any order, and the server already enforces integrity.
- Indexes cover how the UI reads: plants by household, waterings by plant and time, tags by token and plant.

**Times are stored as ISO 8601 text in UTC** (`store_date_time_values_as_text`): exact to the microsecond, sortable, and the same form the API uses.

**The outbox:**
- Each row is one `PushChange`: change id, entity, op, row id, the listed `fields` and the `patch` as JSON.
- It's ordered by an auto-increment `seq`, so changes reach the server in the order they were made.
- `batchKey` keeps the `Idempotency-Key` of the push that last carried a change, so a retry of the same batch reuses it (ADR-0019).
- `attempts` drives backoff (2.9c).

**`LocalChanges.record`** applies a change to the local tables **and** queues it, in one transaction:
- The UI updates at once, offline included. If the app is killed in between, both are kept or neither is (NFR Offline: no data loss).
- The rules match the server's (ADR-0019), so what the phone shows is what the server will end up with:

| Change | Applied as |
| --- | --- |
| Plant, tag or household upsert | Only the listed fields change; a listed field that's absent is cleared |
| Delete | A soft delete |
| Plant delete | Also unlinks its tag |
| Linking a tag | Moves the plant off its old tag |
| Watering | Created whole, as the user, once per id; delete is the undo |
| Household | Settings only; never deleted through sync |

**Ids are UUID v7** (`core/ids/uuid_v7.dart`), the same format as the Worker's, without another package.

**Migrations:**
- `schemaVersion` starts at 1. Every released schema is exported to `drift_schemas/` (`dart run drift_dev make-migrations`).
- From version 2 on, Drift generates tests that check each migration step against the real old schema.

**`clearAll()`** removes everything, for signing out or leaving a household. Wiring it into sign-out comes with the warning about unsent changes (2.10). Until then, signing out keeps the previous account's local data on the phone.

**Testing:**
- The database tests run against an in-memory SQLite (`NativeDatabase.memory()`).
- On Windows with Smart App Control, Windows blocks the test host's unsigned SQLite DLL. Those tests run in the Linux Docker image (README), as in CI. The Android app bundles its own SQLite and isn't affected.

## Dependencies

| Package | Use | Licence | Publisher | Maintenance (2026-10-29) |
| --- | --- | --- | --- | --- |
| `drift` ^2.35.3 | Typed queries, migrations, reactive streams | MIT | simonbinder.eu | Released 2026-10-23; the most-used Flutter SQL library |
| `drift_flutter` ^0.3.1 | Opens the database on a background isolate | MIT | simonbinder.eu | Same author and release train as `drift` |
| `drift_dev` ^2.35.2 (dev only) | Code generation and schema export | MIT | simonbinder.eu | Same release train |

`sqlite3` 3.x (transitive) bundles SQLite through build hooks, so `sqlite3_flutter_libs` is no longer needed (it's only an end-of-life shim). `path_provider` (flutter.dev) comes with `drift_flutter`.

## Consequences

- Increment 2.9c builds the sync engine on these tables: drain the outbox, pull by cursor, and keep pending local edits on top of pulled rows.
- Feature repositories (M4) read through Drift streams and write only through `LocalChanges`.
