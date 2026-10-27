# Status: brief update, API gateway, 2026-10-26

Branch `brief-api-gateway`, based on `m1-nfc-spike`.

## Done

- `AGENTS.md` updated from the new brief: FR-10 (app updates), the API gateway and contract (sections 4–6), two new Compatibility NFRs, CI contract checks, and M2 scope. Confirmed decisions (domain, Flutter, iOS deferral, folders) are kept. Recorded in [ADR-0012](../adr/0012-api-gateway.md).
- **Supabase:** client Data API and Realtime turned off, explicit grants required. Verified on the local stack.
- **Worker:** one Worker serves `api.plants.pampait.pl` (JSON API, RFC 9457 errors) and `plants.pampait.pl` (web pages). 22 tests, 100% line coverage.
- **App:** `API_BASE_URL` setting; crash-report scrubbing covers `/tags/{token}`. 122 tests, coverage unchanged.

## Needs the product owner

- **Redeploy the Worker** (`npm run deploy:production` in `functions/`) to create `api.plants.pampait.pl`. The app domain keeps working as before.
- The M1 device test on the Pixel 9 Pro is paused at row 1 (write a blank sticker). Nothing in this change affects it.

## Next step

Finish the M1 test matrix, then M2, which now includes the OpenAPI contract, JWT checks, version enforcement (FR-10) and Hyperdrive.

## Risks

- ~~FCM silent push replaces Realtime~~ Resolved 2026-10-27 in [ADR-0013](../adr/0013-live-updates-and-reminders.md): live updates use a foreground WebSocket (Durable Object per household) and reminders are server-sent visible notifications, replaced in place. Silent push is never relied on.
- Durable Objects are new infrastructure: check Cloudflare plan limits before M2.
