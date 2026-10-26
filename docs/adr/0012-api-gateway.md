# ADR-0012: The app talks only to a versioned API on Cloudflare Workers

- Status: Accepted
- Date: 2026-10-26
- Decided by: product owner (updated brief, merged into AGENTS.md)
- Supersedes: the parts of [ADR-0004](0004-backend-supabase-and-workers.md) that assume clients call Supabase directly, use Realtime, or rely on database webhooks
- Related: FR-10, AGENTS.md sections 4, 5, 6, 9, 10 and 11; NFR Compatibility (two new rows), Security, Sync

## Context

The original brief had the app call Supabase directly (the Data API with RLS, plus Realtime subscriptions) and kept Workers for a few server functions. The product owner changed this: the app talks to exactly one backend, a versioned API on Cloudflare Workers, and Supabase becomes a private database, auth and storage platform behind it. The aim is that the database schema can change without breaking app versions already installed on phones.

## Decision

**Architecture**

- **One Worker, two hosts.** `api.plants.pampait.pl` serves the JSON API under `/v1`; `plants.pampait.pl` keeps the app-link files and web pages. `src/app.ts` dispatches by hostname, using the `API_HOST` variable per environment (`api.localhost` locally). Each host has its own 404 and 500 handling, so the API never returns HTML and the web host never exposes `/v1`.
- **API errors** use RFC 9457 problem details (`application/problem+json` with `type`, `title` and `status`). `type` is a stable code the app can switch on. No user data goes in error bodies.
- **Supabase.** The Data API (PostgREST) is disabled for clients (`[api] enabled = false`), new objects need explicit grants (`auto_expose_new_tables = false`), and Realtime is off. Auth and Storage keep running. The app uses the anon key for sign-in and token refresh only.
- **Database access** (M2): the Worker reaches Postgres through Cloudflare Hyperdrive with a dedicated role. It sets the verified user's claims in each transaction, so RLS still applies as defence in depth. There are no database webhooks, because every write passes through the Worker.
- **Change notifications:** FCM silent push with a small versioned payload, after which the app pulls `/v1/sync/pull`. Clients never subscribe to tables.

**Done in this change**

| Area | Change |
| --- | --- |
| `AGENTS.md` | Merged the updated brief, keeping confirmed decisions (domain, Flutter, iOS deferral, folders) |
| `supabase/config.toml` | Data API and Realtime disabled; explicit grants required. Checked locally: Auth `200`, `/rest/v1/` unavailable, no Realtime container, pgTAP and lint pass |
| `functions/` | Host-based routing, API app with problem details, production custom domain `api.plants.pampait.pl`, `API_HOST` per environment, tests for both hosts |
| PII scrubbing | App and Worker also redact tokens in `/tags/{token}` paths (`GET /v1/tags/{token}` is in the endpoint list) |
| App config | `API_BASE_URL` added (default `https://api.plants.pampait.pl/v1`); Supabase settings documented as sign-in only |

**Deferred to M2** (where the brief puts the API gateway), each with an ADR entry for its new dependencies:

- `functions/openapi.yaml` (OpenAPI 3.1) as the contract, with Zod validation in the Worker and a generated Dart client.
- JWT verification against Supabase JWKS; per-user and per-IP rate limits.
- Version headers (`X-App-Version`, `X-Platform`, `X-API-Version`), `GET /v1/config`, `426 Upgrade Required` and the FR-10 update screens.
- `Idempotency-Key` handling on `POST /v1/sync/push`.
- The Hyperdrive binding and database role.
- CI: contract tests and an OpenAPI breaking-change check (for example oasdiff) against the last released spec.

**Brief clarification.** The new brief's section 5 still said the data layer has "remote (Supabase) data sources", which contradicts its own "API client" paragraph. `AGENTS.md` now reads "remote (versioned API)".

## Consequences

- Old app versions keep working as long as their API version is supported (at least 6 months after a replacement ships), whatever the database looks like.
- The Worker becomes the critical path for every read and write, so its tests, error tracking and uptime checks matter more.
- **Risk, NFR Sync (≤ 5 s at p95):** Realtime pushed changes over an open socket. FCM silent push is usually fast but not guaranteed, and Android may delay it when a phone is idle. M2 and M5 must send high-priority data messages, measure the delay on real devices, and keep the pull on app open and resume. If p95 misses 5 s, the brief allows a Realtime Broadcast channel carrying the same payload.
- Local development needs `wrangler dev` alongside the Supabase stack. From the Android emulator, set `API_HOST=10.0.2.2` in `functions/.dev.vars`.
