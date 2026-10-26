# ADR-0009: Defer the iOS app; Android first

- Status: Accepted
- Date: 2026-10-23
- Decided by: product owner
- Related: AGENTS.md sections 2, 7, 10 and 11; NFR Compatibility, Performance

## Context

The brief targets iOS and Android. Building, signing and testing iOS needs macOS with Xcode, a paid Apple Developer account and physical iPhones (NFC can't be tested in the simulator). The product owner doesn't have these right now, and they block progress.

## Decision

**For now we build, test and ship Android only.**

- **Kept:** the Flutter `ios/` project, the iOS settings already in it (deployment target 16.0, bundle ID `pl.pampait.plantnfc`), the AASA template and iOS-neutral code. Code stays cross-platform: no Android-only APIs outside platform services behind interfaces (AGENTS.md section 5), so iOS can resume without a rewrite.
- **Removed:** the CI `ios-build` job on macOS.
- **Not done until iOS resumes:** iOS-specific work in each milestone. That covers the iOS NFC capability and Associated Domains (M1), Sign in with Apple (M2), APNs/FCM setup on iOS (M5), TestFlight and App Store release (CD, M7), and the iPhone rows of the NFC test matrix and NFR measurements.
- **Milestone exits** that say "both platforms" or "iOS and Android" are measured on Android only. "Two devices on different platforms" (M2) becomes two Android devices, or one Android device plus a second account.
- Widget tests keep checking `iOSTapTargetGuideline` because it costs nothing and catches regressions early.

## Consequences

- Household members with iPhones can't use the native app. They can open tags through the read-only web fallback (FR-8, M6), but they can't log waterings until iOS ships. Consider moving M6 earlier if iPhone users join before then.
- Sign in with Apple stays in the FR-7 design. Apple requires it on iOS when other social logins exist, but on Android it's optional, so M2 can start with Google and email magic links.
- Resuming iOS means: restore the CI job (see ADR-0006), add the NFC and Associated Domains capabilities, fill `APPLE_TEAM_ID` in the AASA file, and run the iPhone rows of the section 7 test matrix.
