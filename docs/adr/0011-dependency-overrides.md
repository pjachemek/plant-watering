# ADR-0011: Override vulnerable transitive dependencies in the Workers tooling

- Status: Accepted
- Date: 2026-10-26
- Related: NFR Security (dependencies: no known critical CVEs; automated scanning), ADR-0004

## Context

`npm audit` in `functions/` reported 5 vulnerabilities (3 high, 2 moderate) in two transitive packages:

| Package | Installed | Advisories | Fixed in |
| --- | --- | --- | --- |
| undici | 7.29.1 | GHSA-xjj6-f33q-929c (high, DoS via excessive content-encodings), GHSA-4qv8-2p9j-2685 (DoS in the EventSource parser), GHSA-f72v-6w45-q472 (Subresource Integrity bypass) | 7.30.1 |
| zod | 4.6.5 | GHSA-mrhx-c7xc-m3w5 (high, memory exhaustion on oversized collections) | 4.6.6 |

Both come only from dev tooling: `wrangler` → `miniflare` → `undici`, and `@cloudflare/vitest-plugin` → `zod`. Neither is in the deployed Worker bundle, which contains only `hono` and `@sentry/cloudflare`. They still run on developer machines and in CI, and the brief asks for no known high CVEs.

The newest releases (wrangler 4.152.0, @cloudflare/vitest-plugin 1.4.7) still pin the vulnerable versions. `npm audit fix --force` would downgrade `@cloudflare/vitest-plugin` to `0.0.0` and break the tests.

## Decision

Add npm `overrides` in `functions/package.json` that force the patched versions in the same major line:

```json
"overrides": { "undici": "7.30.1", "zod": "4.6.7" }
```

Both are patch-level bumps. Formatting, type checks, lint, all Worker tests (which run in miniflare and use undici) and a production dry-run build pass with them. `npm audit` and OSV-Scanner over all three lockfiles report no issues.

## Consequences

- Overrides hide upstream updates. **Remove each one once wrangler, miniflare and @cloudflare/vitest-plugin depend on a patched version on their own.** Dependabot's weekly PRs and the CI OSV scan will show when that happens; check with `npm ls undici zod` after removing.
- If an override ever conflicts with a tool's declared range, prefer upgrading the tool over widening the override.
