# ADR-0020: Live updates through one Durable Object per household

- Status: Accepted
- Date: 2026-10-28
- Related: M2 increment 2.7; ADR-0013 (the choice of WebSocket plus Durable Object); AGENTS.md sections 5 and 6; FR-2, FR-7; NFR Sync, Battery, Security

## Context

ADR-0013 chose a foreground WebSocket to one Durable Object per household for "something changed" signals. This ADR records how it's built: who may connect, what is sent and when, and how a socket ends.

## Decision

**Connecting: `GET /v1/live?household_id=…` with `Upgrade: websocket`.**

- The request passes the same gateway checks as every other endpoint: contract headers, version gate (426), access token, and the per-user rate limit.
- The Worker then checks membership as the user (`is_member`, under RLS). Non-members get 404, as for any household they can't see.
- **The socket is handed to the household's object** (`idFromName(household_id)`) through a new internal request. That request carries the verified user id and token expiry in internal headers. They are set by the Worker, never copied from the client, and the object is unreachable from outside.
- **One object holds at most 50 sockets.** Beyond that the API answers 429.

**The Durable Object `HouseholdLive`:**

- **Hibernation API:** idle sockets cost nothing, and the object sleeps between signals.
- **Keepalive pings** are answered automatically (`"ping"` → `"pong"`), without waking the object. The app sends one about every 30 s, so mobile networks and proxies don't drop an idle socket.
- **Storage:** SQLite-backed, as Cloudflare recommends for new classes and as the only kind on the Free plan. It stores nothing itself; each socket's attachment holds the user id and token expiry.
- **One-way:** clients send only pings, and anything else is ignored.

**Signals.** The only message is `{"type":"changed","v":1}`. The app then pulls with its own cursor, so the optional `cursor` in `LiveMessage` isn't sent yet. Clients ignore unknown types, so new ones can be added later. Signals go out:

- after a push in which at least one change was applied (rejections and duplicates change nothing);
- when someone joins through an invite;
- when someone leaves, after their own sockets are closed.

Signals are sent in the background (`waitUntil`) and never delay or fail the API response. A lost signal only delays the update until the next pull: on app resume, reconnect, or a tag scan (AGENTS.md section 5).

**Closing.** Apart from the app closing its own socket when it goes to the background:

| Close code | When | What the app does |
| --- | --- | --- |
| 4001 `token_expired` | The access token behind the socket has expired. Checked when a signal is due, so an expired socket receives nothing. | Refreshes the token and reconnects |
| 4003 `not_member` | The member left the household | Stops reconnecting to that household |

Access is always checked again on every pull, so a socket can never reveal data.

## Consequences

- One more piece of Cloudflare infrastructure, configured per environment in `wrangler.jsonc` (migration tag `v1`, `new_sqlite_classes`).
- Worker tests open real WebSockets through the gateway to the object in `workerd` (`functions/test/live.test.ts`). They cover:
  - refusals for non-members and requests that aren't upgrades;
  - ping and pong;
  - signals after a push and a join;
  - the close codes when a member leaves and when a token expires.
- The app client (connect while in the foreground, ping, reconnect with backoff, pull on each signal) follows in increments 2.9 and 2.10.
- The M2 exit test measures the NFR Sync target (≤ 5 s at p95) on two devices.
