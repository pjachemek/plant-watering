# ADR-0002: Monorepo layout and toolchain pins

- Status: Accepted
- Date: 2026-10-23
- Related: AGENTS.md section 10; NFR Maintainability

## Context

The brief asks for one monorepo, the latest stable versions pinned at project start, and a new developer running the app locally in 15 minutes or less.

## Decision

Layout:

| Path | Contents |
| --- | --- |
| `app/` | Flutter app (iOS, Android) |
| `functions/` | Cloudflare Workers (TypeScript, Hono) |
| `supabase/` | Supabase config, migrations, pgTAP tests |
| `web/` | Well-known files and static assets for the app domain |
| `presets/` | Plant presets, schema, validator (M3) |
| `docs/adr/` | Architecture decision records |
| `package.json` (root) | Pinned Supabase CLI and database scripts only |

Toolchain pins:

- **Flutter 3.47.7 / Dart 3.13.5** (latest stable on 2026-10-23). CI pins `FLUTTER_VERSION`; `pubspec.yaml` requires `flutter >=3.47.7`.
- **Dart and Flutter packages**: `pubspec.yaml` uses caret ranges, and `pubspec.lock` is committed. CI runs `pub get --enforce-lockfile`, so the resolved versions are pinned.
- **npm packages**: exact versions in `package.json`, `package-lock.json` committed, `npm ci` in CI.
- **Node 24 or later** (CI uses 24). npm 12 blocks install scripts by default. `functions/package.json` `allowScripts` approves only `workerd` and `esbuild`, which download their platform binaries.
- **Docker** is needed for the local Supabase stack.

The root `.gitignore` replaces the one from the initial commit, which was the template for the Flutter SDK repository itself. That template ignored `*.lock` and would have dropped `pubspec.lock`.

## Consequences

- Dependabot opens weekly update PRs for Actions, npm and pub.
- No Flutter Docker image exists for 3.47.x (the Cirrus Labs images stop at 3.44.0). Developers without a local SDK can build one from the official archive; see the README.
