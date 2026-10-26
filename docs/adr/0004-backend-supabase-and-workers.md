# ADR-0004: Backend on Supabase and Cloudflare Workers, no Deno

- Status: Accepted; partly superseded by [ADR-0012](0012-api-gateway.md) (clients no longer call Supabase directly, no Realtime, no database webhooks)
- Date: 2026-10-23
- Related: AGENTS.md sections 4 and 6; NFR Security, Observability

## Context

AGENTS.md section 4 fixes the backend: Supabase (Postgres, Auth, RLS, Realtime, Storage) plus Cloudflare Workers with Hono for server logic, the web fallback and link hosting. Deno, including Supabase Edge Functions, is excluded.

## Decision

- **Supabase** config lives in `supabase/config.toml`, created with `supabase init`. `[edge_runtime]` is disabled so nobody adds Deno functions by accident. The vector storage bucket is disabled because nothing needs it.
- **Supabase CLI** is pinned as an npm dev dependency in the root `package.json`, so CI and developers get the same version without a global install.
- **Environments:** three Supabase projects (`dev`, `staging`, `prod`) and three Worker environments (`dev` top-level, `staging`, `production` in `wrangler.jsonc`). Project refs are placeholders until the projects are created (see ADR-0007).
- **Workers** live in `functions/`: TypeScript strict mode (`noUncheckedIndexedAccess`, `exactOptionalPropertyTypes`), ESLint `strictTypeChecked` with zero warnings, Prettier. `createApp()` builds the Hono app separately from the Sentry-wrapped entry point so routes are testable in isolation.
- **Types:** Worker runtime types come from `wrangler types` (`worker-configuration.d.ts`, committed). CI runs `wrangler types --check` so the file can't drift from `wrangler.jsonc`.
- **Tests** run in the real `workerd` runtime via `@cloudflare/vitest-plugin`, with coverage thresholds of 70%.
- **Security headers** are set on every response: HSTS, `nosniff`, `Referrer-Policy: no-referrer` and a default-deny CSP. This suits the web fallback page, which has no third-party scripts (AGENTS.md section 6).

## Consequences

- Server code uses only Web APIs plus Hono, so it can move to Node or Bun.
- TypeScript is pinned to 6.0.x because `typescript-eslint` 8.72 supports `<6.1`. Upgrade both together.
- `@cloudflare/vitest-pool-workers` was renamed to `@cloudflare/vitest-plugin`; we use the new name. The old package bundled a `workerd` too old for our compatibility date.

## Dependencies added

| Package | Version | Licence | Maintenance | Why |
| --- | --- | --- | --- | --- |
| hono | 4.13.13 | MIT | Very active, used across Workers ecosystem | Router and middleware (mandated by the brief) |
| @sentry/cloudflare | 11.8.0 | MIT | Official Sentry SDK, active | Error reporting (ADR-0005) |
| wrangler (dev) | 4.152.0 | MIT OR Apache-2.0 | Official Cloudflare CLI | Dev server, deploy, type generation |
| @cloudflare/vitest-plugin (dev) | 1.4.7 | MIT | Official Cloudflare | Run tests inside `workerd` |
| vitest, @vitest/coverage-istanbul (dev) | 5.0.5 | MIT | Very active | Test runner and coverage (mandated by the brief) |
| typescript (dev) | 6.0.3 | Apache-2.0 | Microsoft, active | Type checking |
| eslint, @eslint/js (dev) | 10.13.0, 10.0.1 | MIT | Very active | Linting |
| typescript-eslint (dev) | 8.72.0 | MIT | Very active | Type-aware lint rules |
| prettier (dev) | 3.9.10 | MIT | Very active | Formatting |
| supabase CLI (dev, root) | 2.121.0 | MIT | Official Supabase | Local stack, migrations, pgTAP tests |
