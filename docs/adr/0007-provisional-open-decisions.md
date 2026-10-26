# ADR-0007: Provisional defaults for open product decisions

- Status: Provisional (each item is confirmed or replaced by the product owner). Framework, domain and bundle ID superseded by [ADR-0008](0008-confirmed-framework-domain-bundle-id.md).
- Date: 2026-10-23
- Related: AGENTS.md section 12 "Open decisions"

## Context

AGENTS.md section 12 lists decisions for the product owner. M0 can't wait for all of them, so we start with the brief's defaults and keep each one easy to change.

## Decision

| Open decision | Provisional default | Cost of changing later |
| --- | --- | --- |
| ~~Framework~~ | **Confirmed: Flutter** (ADR-0008) | n/a |
| Personal use or public store release | Build to store quality (the brief's quality bar); store listings, support page and legal review deferred to M7 | Low until M7 |
| App name and domain | **Confirmed:** domain `plants.pampait.pl`, bundle ID `pl.pampait.plantnfc` (ADR-0008). Display name "Plant NFC" still provisional | Display name: low |
| Languages for v1 | English only, all strings in ARB files so adding locales is translation work only | Low |
| Default hemisphere | Northern | Low (it is a household setting) |
| Push provider | FCM for both platforms, data messages only | Medium (affects M5 only) |
| Web fallback card default | **Off** for new households (privacy by default; the household opts in) | Low (one column default) |

## Consequences

- Remaining placeholders are greppable: `STAGING_PROJECT_REF`, `PROD_PROJECT_REF`, `APPLE_TEAM_ID`. `assetlinks.json` has the debug-key fingerprint; upload and Play signing keys are added with the Play Console app.
- M1 needs DNS for the domain, an Apple Developer team ID and the Android signing certificate fingerprint. Those are blockers for M1, not M0.
