# ADR-0025: The app's sync engine

- Status: Accepted
- Date: 2026-10-29
- Related: M2 increment 2.9c; AGENTS.md sections 5, 9 and 10; ADR-0014, ADR-0019, ADR-0023, ADR-0024; FR-2; NFR Offline, Sync, Battery

## Context

Changes made on the phone sit in the outbox (ADR-0024), and the API offers push and pull (ADR-0019). The engine must:

- send the outbox safely;
- bring other members' changes in;
- keep the person's unsent edits on screen;
- recover from rejected changes;
- do all of this without polling (NFR Battery).

## Decision

**`SyncEngine`: one pass, no timers.**

1. **Households:** `GET /v1/households` refreshes the list. A household the person no longer belongs to is removed from the phone, with all its data.
2. **Push**, per household, in outbox order, at most 500 changes per request:
   - **A batch keeps its `Idempotency-Key` until the API answers.** The rows are stamped with the key before sending, so a retry after a lost answer is the *same* request, and the API answers from its ledger. Nothing is applied twice, even across an app restart. Changes queued in the meantime go in the next batch.
   - **An answer removes every change in the batch from the outbox,** whether applied, duplicate or rejected: the API has decided each one for good.
   - **A rejection marks the household for a full pull.**
   - **A failure** keeps the batch and counts an attempt.
3. **Pull** by cursor, in one transaction:
   - The server's rows are written first.
   - **Pending local changes are re-applied on top,** in order, for any pulled row that still has queued changes. An edit made during a sync stays on screen until the API has it.
   - **A full pull** (first sync, after a rejection, or with no cursor) also removes local rows the server doesn't have and that aren't queued, such as a rejected creation. Every row the server has comes back, deleted ones included, so anything else was never accepted.
   - **A tag token is unique:** a local tag holding a pulled token under another id was refused by the server and is dropped.
   - **A 404** means no longer a member: the household is removed from the phone.
   - **Unknown values** from a newer server (for example a new watering method) are kept as unknown locally instead of failing.

**`SyncController`: when to run, never on a fixed interval.**

| Trigger | Action |
| --- | --- |
| Sign-in, app start, resume | A pass at once |
| A new outbox entry | A pass after 400 ms, so quick changes go together |
| A lost connection, server error or rate limit | Retry with backoff, **only while the app is in the foreground**: 2 s doubling to 5 min, ±20% jitter |
| A batch the API calls malformed | A bug in this app. It's never dropped, and retries at the longest interval |
| `401` that can't be refreshed, or `426` | Stop until the person signs in or updates (ADR-0023). Changes stay queued |
| The app goes to the background | Retries stop; resume syncs again |

- **Only one pass runs at a time.** A request during a pass runs one more after it.
- **A new outbox entry is one that raises its size.** A failed pass rewrites the outbox (attempts), and must still wait for its backoff.
- **The controller is listened to for the app's lifetime.** In Riverpod 3, a provider nobody listens to is paused, including its outbox subscription; a test caught this.

**"On reconnect"** (AGENTS.md section 5) needs no connectivity package:
- foreground retries reach the server within the backoff (at most 5 minutes);
- every resume syncs at once;
- the live-update socket (2.10) syncs whenever it reconnects.

**Tests:**
- **Engine:** a small in-memory fake of the sync API (`test/helpers/fake_sync_server.dart`) applies the same rules as the Worker: the ledger, per-field last write wins, append-only waterings, unique tokens and the cursor. Two phones, each with its own database, are tested against it:
  - pushing in order and pulling on the other phone;
  - a lost answer retried with the same key, without doubling;
  - later changes in a new batch;
  - **both phones editing offline and agreeing after reconnecting** (AGENTS.md section 10);
  - an edit during a sync surviving the pull;
  - a rejected creation disappearing;
  - leaving the household;
  - nothing lost offline.
- **Controller:** `fake_async` covers backoff, stopping, background and resume, debouncing and sign-out.

## Dependencies

| Package | Use | Licence | Publisher | Maintenance |
| --- | --- | --- | --- | --- |
| `fake_async` ^1.3.3 (dev only) | Controlled time in controller tests | BSD-3-Clause | dart.dev | Dart team package; already a transitive dependency of `flutter_test` |

## Consequences

- **Feature code** (M4) only writes through `LocalChanges` and reads Drift streams. Syncing follows by itself.
- **Live-update signals and tag scans** call `requestSync` (2.10, M4).
- **`SyncStatus`** is available for an offline note in the UI.
- **Sign-out** will clear the local data (`clearAll`), after warning about unsent changes (2.10).
