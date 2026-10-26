# ADR-0008: Confirmed framework, domain and bundle ID

- Status: Accepted
- Date: 2026-10-23
- Decided by: product owner
- Supersedes: the framework and domain/bundle ID rows of [ADR-0007](0007-provisional-open-decisions.md)

## Decision

| Decision | Value |
| --- | --- |
| Framework | Flutter (no switch to React Native) |
| App domain | `plants.pampait.pl` |
| iOS bundle ID / Android application ID and namespace | `pl.pampait.plantnfc` |

## Consequences

- Tag URLs are `https://plants.pampait.pl/p/{tagToken}`. Once stickers are written, the domain must stay served for as long as those stickers are in use.
- The bundle ID can't change after the first App Store or Play upload.
- The Android Kotlin package moved to `pl.pampait.plantnfc`. The AASA `appIDs` entry is `APPLE_TEAM_ID.pl.pampait.plantnfc` and the assetlinks `package_name` is `pl.pampait.plantnfc`.
- Still needed for M1: DNS for `plants.pampait.pl` pointed at Cloudflare, the Apple Developer team ID, and the Android signing certificate fingerprints.
- The display name "Plant NFC" is still provisional.
