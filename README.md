# Plant NFC

Tap a phone on an NFC sticker on a plant pot to see how and when to water that plant. The household shares plants and watering history in near real time.

The product and technical brief is [AGENTS.md](AGENTS.md). Decisions are recorded in [docs/adr/](docs/adr/).

## Repository

| Path | What |
| --- | --- |
| [app/](app/) | Flutter app (Android; iOS deferred, see ADR-0009) |
| [functions/](functions/) | Cloudflare Workers: server functions, web fallback, link hosting |
| [supabase/](supabase/) | Supabase config, SQL migrations, pgTAP tests |
| [web/](web/) | Well-known files (Universal Links, App Links) |
| [presets/](presets/) | Plant care presets (from M3) |
| [docs/adr/](docs/adr/) | Architecture decision records |

## Prerequisites

- Flutter 3.47.7 (stable). Using [fvm](https://fvm.app) or the official installer is fine. No SDK? See [Flutter in Docker](#flutter-in-docker).
- Node 24 or later.
- Docker (for the local Supabase stack).
- For device builds: Android Studio or the Android SDK with JDK 21. iOS builds are deferred (ADR-0009).

## Run it locally

```sh
# 1. Backend: local Supabase (Postgres, Auth, Realtime, Storage)
npm ci
npm run db:start            # first run pulls Docker images
npx supabase status         # shows the local API URL and anon key

# 2. App config: copy the example and paste the local anon key
cp .env.example .env

# 3. App
cd app
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run --dart-define-from-file=../.env
```

On the Android emulator, set `SUPABASE_URL=http://10.0.2.2:54321` in `.env`. Debug builds allow plain HTTP only to the local stack.

Workers:

```sh
cd functions
npm ci
cp .dev.vars.example .dev.vars
npm run dev                 # http://localhost:8787/health
```

## Checks (same as CI)

```sh
# App
cd app
dart format --output=none --set-exit-if-changed lib test tool
flutter analyze --fatal-infos --fatal-warnings
flutter test --coverage && dart run tool/check_coverage.dart coverage/lcov.info

# Workers
cd functions
npm run format:check && npm run types:check && npm run typecheck && npm run lint && npm run test:coverage

# Database (needs Docker)
npm run db:start && npm run db:test && npm run db:lint
```

Golden images are generated on Linux. Regenerate them with `flutter test --update-goldens --tags golden`, on Linux or in Docker.

## Flutter in Docker

For machines without the Flutter SDK, for example to run checks or regenerate goldens:

```sh
docker build -t plant-flutter:3.47.7 -f tools/flutter.Dockerfile tools
docker run --rm -v "$PWD:/repo" -w /repo/app plant-flutter:3.47.7 \
  sh -c "flutter pub get && flutter test"

# Android build signed with your machine's debug key, so App Links verify
docker run --rm -v "$PWD:/repo" -w /repo/app \
  -v "$HOME/.android/debug.keystore:/root/.android/debug.keystore:ro" \
  plant-flutter:3.47.7 sh -c "flutter build apk --debug"
```

Without the keystore mount, each container signs with a new throwaway key. Tag links then won't open the app, because the fingerprint doesn't match `web/.well-known/assetlinks.json`.

## Conventions

- Conventional Commits; small PRs that link FR and NFR IDs (see the PR template).
- Every new dependency or significant decision gets an ADR.
- Never commit secrets. Only `.env.example` and `.dev.vars.example` are tracked.
