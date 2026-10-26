# app/

Flutter app for iOS and Android. Setup and checks are in the [root README](../README.md); architecture is in [AGENTS.md](../AGENTS.md) section 5 and [ADR-0003](../docs/adr/0003-mobile-app-foundations.md).

```
lib/
  core/        design tokens and theme, router, config, observability, Result type
  features/    one folder per feature, each with presentation/, domain/, data/
  l10n/        ARB string files (all user-facing text)
tool/          check_coverage.dart (CI coverage gate)
```
