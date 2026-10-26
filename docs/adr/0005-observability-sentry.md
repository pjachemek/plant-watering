# ADR-0005: Error reporting with Sentry and PII scrubbing

- Status: Accepted
- Date: 2026-10-23
- Related: NFR Observability, NFR Privacy (logs and crash reports), NFR Reliability

## Context

The brief mandates Sentry on the app and Workers with release tracking, and forbids emails, names, tokens or photo URLs in logs and crash reports. Tag tokens appear in URLs (`/p/{tagToken}`), so URLs need scrubbing too.

## Decision

- Sentry is **off unless a DSN is supplied**: `SENTRY_DSN` as a Workers secret, `--dart-define=SENTRY_DSN=...` in the app. Local dev and tests send nothing.
- **Workers:** `dataCollection` turns off user info, cookies, bodies, query strings and stack-frame variables; request headers are allow-listed to `user-agent` and `content-type`. `beforeSend` (`functions/src/lib/sentry.ts`) also drops `user`, redacts sensitive keys, and rewrites emails and `/p/<token>` paths.
- **App:** `sendDefaultPii: false`, no screenshots or view hierarchy, no performance tracing, and a `beforeSend` and `beforeBreadcrumb` scrubber with the same rules (`app/lib/core/observability/`).
- **Releases:** CI passes the release name (`plant-nfc@<version>+<build>`) so errors map to builds.
- Performance tracing is off for MVP. Turning it on later needs a new ADR, because traces carry URLs.

## Consequences

- Events carry less context. Debugging relies on error type, stack trace and release, which is enough for an app this size.
- The scrubbers have unit tests. A new field type that might hold personal data has to be added there.
- Uptime checks and error-spike alerts are configured in Sentry when the prod project exists (M7).
