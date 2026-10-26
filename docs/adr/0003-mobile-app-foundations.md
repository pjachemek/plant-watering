# ADR-0003: Mobile app foundations

- Status: Accepted
- Date: 2026-10-23
- Related: AGENTS.md sections 4, 5 and 9; NFR Accessibility, Localisation, Security, Compatibility, Maintainability

## Context

M0 needs a Flutter skeleton with design tokens, theming and CI. The brief fixes the main libraries. This ADR covers the ones added in M0 and the platform settings. Drift, freezed, nfc_manager and the notification packages get their own ADRs when they're introduced (M1, M2, M5).

## Decision

**Structure.** `lib/core/` (design, router, config, observability, result) and `lib/features/<feature>/{presentation,domain,data}/`, created as each feature needs them.

**State and navigation.** Riverpod 3 with code generation (`@riverpod`) and go_router. The router is a `keepAlive` provider. `/p/:tagToken` is a top-level route, so a cold start from a tag never passes through the home screen.

**Design system.** `core/design/tokens.dart` holds the palette, light and dark `ColorScheme`s, spacing, radius, sizes and motion. `AppTheme` builds the Material 3 themes from them. Raw colours and sizes appear only in the tokens file. `AppMotion.resolve` returns zero when the platform asks to reduce motion. Minimum touch target is 48 dp, which meets both 48 dp (Android) and 44 pt (iOS).

**Accessibility checks.** A unit test checks every text/background token pair for 4.5:1 or better contrast in both themes. Widget tests run Flutter's `androidTapTargetGuideline`, `iOSTapTargetGuideline`, `labeledTapTargetGuideline` and `textContrastGuideline`, and render at 200% text on a 320 × 568 screen.

**Localisation.** All strings live in `lib/l10n/app_en.arb` via `flutter gen-l10n` (`generate: true`). English only for v1 (ADR-0007).

**Lints.** `very_good_analysis` plus `strict-casts`, `strict-inference` and `strict-raw-types`. `unawaited_futures` and `discarded_futures` are errors. CI runs `flutter analyze --fatal-infos --fatal-warnings`. One rule is off: `public_member_api_docs`, because this is an app, not a published package. Doc comments are still written where they explain intent.

**Errors.** `core/result/result.dart` is a sealed `Result<T, F>` for typed failures. Domain and data layers return it instead of throwing (AGENTS.md section 5).

**Platform minimums and hardening.**

- iOS deployment target 16.0. Android `minSdk` 26, with target and compile SDK from Flutter 3.47. Flutter 3.47's own minimums are lower, so the brief's targets apply.
- Android: `INTERNET` declared in the main manifest. `allowBackup=false` plus `dataExtractionRules` that exclude everything, so tokens never reach cloud backup or device transfer. A network security config blocks cleartext and trusts system CAs only. Android 8 (API 26–27) would otherwise allow cleartext by default. The debug-only config allows HTTP to `10.0.2.2`, `localhost` and `127.0.0.1` for the local Supabase stack.
- iOS: App Transport Security stays at its strict default. It doesn't apply to IP literals, so the simulator can reach `127.0.0.1`.
- Bundle ID and application ID are `pl.pampait.plantnfc` (confirmed in ADR-0008).

**Coverage.** `tool/check_coverage.dart` enforces 70% overall and 90% for `lib/features/*/domain/`, excluding generated files.

**Goldens.** Goldens are generated on Linux (CI runner or Docker) and cover light, dark and 200% text. They use Flutter's default test font, so they check layout and colour, not typography. Loading the real fonts is a follow-up for M4, when key screens exist.

## Dependencies added

| Package | Constraint (locked) | Licence | Maintenance | Why |
| --- | --- | --- | --- | --- |
| flutter_riverpod | ^3.4.3 | MIT | Very active | State and DI (mandated by the brief) |
| riverpod_annotation / riverpod_generator (dev) | ^4.0.7 / ^4.0.9 | MIT | Very active | Riverpod code generation |
| go_router | ^18.1.1 | BSD-3-Clause | Flutter team | Routing and deep links (mandated by the brief) |
| sentry_flutter | ^10.2.0 | MIT | Official Sentry SDK | Crash reporting (ADR-0005) |
| intl, flutter_localizations | ^0.20.3, SDK | BSD-3-Clause | Dart and Flutter teams | Localisation and locale-aware formats |
| meta | ^1.19.0 | BSD-3-Clause | Dart team | `@immutable` for value types |
| build_runner (dev) | ^2.16.2 | BSD-3-Clause | Dart team | Code generation |
| very_good_analysis (dev) | ^11.0.0 | MIT | Very Good Ventures, active | Strict lint set |
