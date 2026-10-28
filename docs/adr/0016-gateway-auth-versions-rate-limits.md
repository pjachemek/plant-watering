# ADR-0016: Gateway sign-in, version enforcement and rate limits

- Status: Accepted
- Date: 2026-10-28
- Related: M2 increment 2.3; FR-10; AGENTS.md section 6; NFR Security (public endpoints, credentials), Compatibility (upgrade enforcement)

## Decision

**Request pipeline for every `/v1` operation**, in this order:

| Step | Failure | Why this order |
| --- | --- | --- |
| 1. Contract headers (`X-App-Version`, `X-Platform`, `X-API-Version`) | `400 invalid_request` | Everything after depends on them |
| 2. Version gate | `426 upgrade_required` | Before sign-in, so an outdated app shows the update screen even with an expired session (FR-10) |
| 3. Sign-in, on operations that require it | `401 unauthorized` (with `WWW-Authenticate: Bearer`) or `503 auth_unavailable` | Before reading any body |
| 4. Rate limit | `429 rate_limited` (with `Retry-After`) | Keyed by user once known |
| 5. Path, query and body | `400 invalid_request` or `invalid_json` | |
| 6. Handler; the response is validated against the contract | `500 invalid_response` | Off-contract data is never sent |

**Sign-in.** The `jose` library verifies Supabase access tokens against the project's JWKS (`<SUPABASE_URL>/auth/v1/.well-known/jwks.json`):

- Only ES256 and RS256 are accepted; legacy shared-secret HS256 tokens are refused.
- The issuer must be `<SUPABASE_URL>/auth/v1` and the audience `authenticated`, the token must not be expired, and `role` must be `authenticated`.
- The key set is cached per isolate for 10 minutes. An unknown key id triggers a refetch (with a 30-second cooldown), so key rotation needs no deploy.
- **A key fetch that fails returns `503`, not `401`.** A 401 tells the app to sign the user out; a short Supabase outage must not do that.

**Version policy.** `GET /v1/config` returns the minimum and recommended versions for the calling platform. It needs no sign-in, but is rate-limited per IP and cached for 5 minutes with `Vary: X-Platform`. Requests below the minimum get `426`. For now the policy comes from the Worker variables `MIN_APP_VERSION` and `RECOMMENDED_APP_VERSION`, behind a `VersionPolicySource` interface. M2.4 switches it to the `client_versions` table, so the minimum can change without a deploy, as the NFR requires.

**Rate limits.** Cloudflare's Workers rate-limiting binding:

- `USER_RATE_LIMITER`: 120 requests per 60 s, keyed `u:<user id>`, on signed-in endpoints.
- `IP_RATE_LIMITER`: 60 requests per 60 s, keyed `ip:<CF-Connecting-IP>`, on public endpoints.
- Bindings aren't inherited by environments, so `dev`, `staging` and `production` each declare their own, with separate namespace ids (`1001`/`1002`, `2001`/`2002`, `3001`/`3002`).
- The binding's counters are per location and approximate, which is fine for abuse protection. It isn't a quota system.

**Testability.** `createApp(options)` takes signing keys, a version-policy source and handlers. Tests sign tokens with a local ES256 key and swap in fake rate limiters, so no test needs the network or a real Supabase project.

## Consequences

- Every `/v1` response is validated before it's sent. A handler bug becomes a logged `500 invalid_response`, never a contract violation in the field.
- Two Worker variables are interim and go away in M2.4.
- The real Supabase JWKS is checked once the dev project's URL is configured. The Supabase projects must use asymmetric signing keys, or every token is refused.

## Dependencies added

| Package | Version | Licence | Maintenance | Why |
| --- | --- | --- | --- | --- |
| jose | 6.2.13 | MIT | Very active, widely used, Web Crypto only (runs on Workers, Node, Bun) | JWT verification against JWKS |
