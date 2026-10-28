# ADR-0017: Database access through Hyperdrive as a dedicated role, RLS per request

- Status: Accepted
- Date: 2026-10-28
- Related: M2 increment 2.4; AGENTS.md section 6; NFR Security (data isolation, credentials), Compatibility (minimum version without a release)

## Context

The Worker is the only client of the database (ADR-0012). The brief asks for Hyperdrive, a dedicated database role, and the verified user's claims set in each transaction so RLS still applies as defence in depth.

## Decision

**Role `plantnfc_api`** (migration `20261028140000_api_role.sql`):

- It can log in, doesn't inherit, isn't a superuser, and can't bypass RLS.
- `grant authenticated to plantnfc_api with inherit false, set true`: it can **switch to** `authenticated` but doesn't get its rights by default.
- **Direct rights:** reading `client_versions` only (grant plus an RLS policy; RLS is on everywhere, so a grant alone returns no rows, which a test caught). Nothing else.
- No password in the repo. Locally `seed.sql` sets `local-dev-only`; on hosted projects the owner sets one (`docs/environments.md`).
- `postgres` may act as the role (`grant ... with set true`), because since Postgres 16 a role's creator can manage it but not switch to it. This is needed for tests and administration.

**Every user request** runs in one transaction:

```sql
select set_config('request.jwt.claims', $1, true), set_config('role', 'authenticated', true)
```

Both settings are transaction-local, so nothing leaks to the next request on a pooled Hyperdrive connection. A test checks this on a real connection.

**Driver: node-postgres (`pg`)**, with a client per request, as Cloudflare recommends for Hyperdrive (which does the pooling).

- `postgres.js` was tried first. Closing a Workers socket **rejects** its pending read with "This socket has been closed". Both drivers then re-emit that as an `error` event after their listeners are gone, and it surfaced as unhandled rejections on every request, in tests and potentially in production error reports.
- With `pg`, node-postgres's documented practice applies: **every client gets an `error` listener**. The late close error is expected during `end()`; any other client error is logged, by name only.
- **Test runner only:** Vitest's Workers runner resolves `pg-protocol` and `pg-cloudflare` to an ES-module build and an empty fallback, so `vitest.config.ts` aliases them to their CommonJS (workerd) builds. The real Worker bundle (esbuild) resolves them correctly, which a dry-run build confirms.

**Version policy** now comes from `client_versions`, cached per isolate for 60 seconds, so the minimum version changes without a deploy (NFR Compatibility). If the database can't be read, the Worker variables (`MIN_APP_VERSION`, `RECOMMENDED_APP_VERSION`) are the fallback, because a database outage must not block the update check. Those variables are now a deliberate fallback, not interim.

**Failures:** no binding, or no connection, gives `503 database_unavailable` with `Retry-After`; anything else is a 500 reported to Sentry.

**First database-backed endpoint:** `GET /v1/households`. The query has no household filter: RLS alone decides what comes back, and the tests prove it.

## Tests

- **pgTAP** (`02_api_role.test.sql`): role properties; it isn't a member of `service_role` or `postgres`; reads versions; no direct access to household data; acting as a user, RLS applies and server-only tables are out of reach.
- **Worker integration** (`functions/test/db.test.ts`, against the local database), through the full gateway:
  - each user sees only their household, and a user without one sees an empty list;
  - timestamps are serialised per the contract;
  - `503` without a database;
  - logged in as `plantnfc_api`: it can't become `service_role` or `postgres` (which pgTAP can't test, because `SET ROLE` is checked against the login user), and the context resets after each transaction;
  - the version policy comes from the database, with the variable fallback.
- **CI** starts the local database (`supabase db start`, which applies migrations and the seed) before the Worker tests.

## Consequences

- Running the Worker tests locally needs the database running: `npm run db:start` in the repo root.
- Hosted projects need the owner's one-time steps: apply migrations, set the role password, create the Hyperdrive configuration (`docs/environments.md`).
- **Open risk:** hosted Supabase restricts `postgres`. The `grant authenticated ... with set true` and `grant plantnfc_api to postgres` lines are expected to work there but haven't been run against the dev project yet; `supabase db push` will show it.

## Dependencies added

| Package | Version | Licence | Maintenance | Why |
| --- | --- | --- | --- | --- |
| pg | 8.23.1 | MIT | node-postgres, very active, Cloudflare-documented for Hyperdrive | Postgres driver |
| @types/pg (dev) | 8.23.1 | MIT | DefinitelyTyped | Types |
| pg-cloudflare (via pg) | 1.4.1 | MIT | Same maintainers | Workers socket adapter |
