# Plant NFC App — Agent Brief

Oct 22, 2026 · @Pawel Jachemek

## 1. Role and mission

You are a senior mobile and backend engineering team building a cross-platform (iOS + Android) app that lets a household tap a phone on an NFC sticker on a plant pot and instantly see how and when to water that plant.

Your job is to deliver a production-quality MVP in small, reviewable increments. Quality bar: an app that could be published to the App Store and Google Play without rework, even if it is first used by one household.

How to use this brief:

- Treat sections 2–8 as the product and technical specification.
- Treat section 9 (Non-functional requirements) as hard acceptance criteria. A feature is not done until it meets them.
- Follow the working agreement in section 12. When this brief is silent or ambiguous, choose the industry best practice, record the choice as an ADR, and continue.
- Export this brief as Markdown and keep it in the repository root as `AGENTS.md` so every agent session starts from it.

## 2. Product context

**Problem.** Household members forget when each plant needs water and how to water it (amount, method). Generic reminder apps don't help at the pot, and mainstream plant apps are built around AI identification and subscriptions.

**Solution.** An NFC sticker on each pot holds a link. Holding a phone near it opens that plant's care card: how to water, how often, when it was last watered, and a one-tap "Watered" button. Setting up a new plant takes under a minute: pick it from a preset list, optionally add a photo, write the sticker.

**Users.** A household of 2+ people on mixed platforms (at least one iPhone and one Android). Everyone in the household sees the same plants and the same watering history in near real time.

**In scope for MVP**

- Scan a tag to open a plant card (app installed, phone locked or unlocked per OS limits).
- Log a watering with one tap; shared across the household.
- Add a plant from a searchable preset database, write its tag.
- Next-watering date and reminder notifications.
- Plant list, edit and delete plant, re-assign or replace a tag.
- Household with invite link.
- Read-only web fallback card for people without the app.

**Explicit non-goals (do not build)**

- No AI or photo-based plant identification. The user always knows the plant.
- No AI chat, diagnosis or generated care advice.
- No subscriptions, paywalls, ads or third-party tracking SDKs.
- No hardware sensors (soil moisture etc.) in MVP.
- No social features beyond the household.

## 3. Functional requirements

Each story lists its acceptance criteria. IDs (FR-x) are referenced in commits, tests and PRs.

**FR-1 Scan to plant card.** As a household member, I hold my phone to a pot and see that plant's card.

- With the app installed and logged in, scanning opens the plant card directly (no home screen, no extra taps).
- Card shows: nickname, species name, photo, watering method and amount, interval, last watered (relative and absolute, with who), next due date, light and short tips.
- Card renders from local cache when offline.
- A tag not linked to any plant in my household shows "Unknown tag" with options: link it to an existing plant or add a new plant.
- A tag belonging to another household never reveals that household's data.

**FR-2 Log watering.** One large "Watered" button records a watering event with timestamp and user.

- Visual and haptic confirmation within 100 ms; works offline and syncs later.
- Undo available for 10 seconds.
- Other household devices reflect the change within 5 seconds when online.
- Optional: "Watered all due plants" bulk action from the plant list.

**FR-3 Add plant.** Search presets, choose one, set nickname, optional photo and room, write the tag.

- Search is offline, typo-tolerant, matches common and Latin names and aliases; results in under 100 ms.
- "Custom plant" option when no preset fits; user enters method, amount, interval.
- Preset values are copied as defaults; user can override interval, amount, method, notes per plant.
- Write flow: clear "Hold your phone near the sticker" screen with illustration, success and failure states, retry. Verifies the written content by reading it back.
- Plant can be saved without a tag and linked later.

**FR-4 Next watering and reminders.**

- Next due = last watered + interval for the current season (summer Apr–Sep, winter Oct–Mar, northern hemisphere default; hemisphere setting).
- Daily digest notification at a user-chosen time (in the user's time zone) listing due plants; no notification if none due. The server computes and sends it from the latest household data, so it never lists a plant someone already watered.
- Notifications are per user and can be turned off per user or per plant.
- When anyone waters a plant, a digest already shown on other devices is replaced in place with the updated list, or with a quiet "all watered" note, without sound.

**FR-5 Plant list.** Home screen lists plants sorted by due date, grouped Overdue / Today / Upcoming, filterable by room.

**FR-6 Manage plants and tags.** Edit any field, delete plant (with confirmation), replace a lost or damaged tag, unlink a tag. Watering history view per plant.

**FR-7 Household.**

- Sign up with external identity providers only: Sign in with Apple (iOS) and Google. No email or password sign-in (ADR-0022).
- First user creates a household; others join via an invite link or code that expires in 7 days.
- All members have equal rights in MVP. A member can leave; the last member leaving deletes the household after confirmation.

**FR-8 Web fallback.** Scanning with a phone that doesn't have the app opens a mobile web page with the plant's care card (read-only) and store download links.

- Shows only care info and nickname, never member names, emails or history.
- Household can disable the public card in settings, in which case the page shows only download links.

**FR-9 Account and data.** In-app account deletion, data export (JSON), privacy policy and terms links.

**FR-10 App updates.** Below the minimum supported version, the app shows a blocking screen with a store link; below the recommended version, a dismissible prompt. Data entered offline is kept and synced after updating.

## 4. Tech stack

Defaults below are decided unless section 12 says otherwise. Use the latest stable versions at project start and pin them; do not add a dependency without an ADR stating why, its licence and its maintenance status. Do not use Deno or any Deno-based service, including Supabase Edge Functions: after Cloudflare's acquisition of Deno, the runtime only gets about a year of fixes. Server code targets standard Web APIs so it can move between runtimes.

| Layer | Choice | Why |
| --- | --- | --- |
| Mobile framework | Flutter (stable), Dart 3 with sound null safety | One codebase, strong custom UI, mature NFC plugin |
| State management | Riverpod (code generation) | Testable, compile-safe dependency injection |
| Navigation and deep links | go\_router | Declarative routes, handles Universal/App Links |
| Local database | Drift (SQLite) | Typed queries, migrations, reactive streams for offline-first |
| Models | freezed + json\_serializable | Immutable models, exhaustive unions |
| NFC | nfc\_manager | NDEF read/write on iOS and Android |
| Notifications | Firebase Cloud Messaging visible notifications sent by the server; flutter\_local\_notifications only to show them while the app is in the foreground | The OS displays visible notifications without running app code and replaces them in place by tag or collapse ID; silent push is unreliable when the app is idle or swiped away (ADR-0013) |
| Backend | Supabase: Postgres, Auth, Storage. No Edge Functions; Data API disabled for clients | Managed Postgres and sign-in; RLS as defence in depth; open source, low cost |
| API contract | OpenAPI 3.1 spec in the repo; Zod validation in the Worker; Dart client generated from the spec | One source of truth for the app–backend boundary; breaking changes caught in CI |
| API gateway, web fallback and link hosting | Cloudflare Workers (TypeScript, Hono): versioned API at api.\<domain>/v1 plus web pages; Hyperdrive for Postgres connections; Durable Objects for live updates; Cron Triggers for reminder digests; tests with Vitest | The only backend the app talks to; owns the contract so the database can change without breaking old app versions; Hono also runs on Node or Bun |
| Crash and error reporting | Sentry (mobile + Workers), PII scrubbing on | Single view across platforms |
| CI/CD | GitHub Actions + fastlane | Automated tests, signed builds, store uploads |
| Infrastructure as code | Supabase CLI migrations, config in repo | Reproducible environments |

## 5. Mobile architecture

The app is offline-first: the local database is the source of truth for the UI, and a sync engine reconciles it with the backend in the background.

**Structure.** Feature-first folders (`plants/`, `scan/`, `watering/`, `presets/`, `household/`, `reminders/`, `settings/`), each with three layers:

- **Presentation:** widgets and Riverpod notifiers. No business logic, no direct database or network calls.
- **Domain:** entities, value objects, use cases (e.g. `LogWatering`, `ComputeNextDue`). Pure Dart, no Flutter imports, 100% unit-testable.
- **Data:** repositories implementing domain interfaces; local (Drift) and remote (versioned API, see below) data sources.

Shared code lives in `core/` (design system, theming, logging, error types, result type). Platform services (NFC, notifications, camera, connectivity) sit behind interfaces so they can be faked in tests.

**Data flow.**

1. UI watches a repository stream backed by Drift and renders immediately from local data.
2. User actions write to Drift and append a row to an outbox table in the same transaction.
3. The sync engine drains the outbox to the API (POST /v1/sync/push) with retries and exponential backoff, and pulls remote changes from GET /v1/sync/pull (a delta query by change cursor: each row records the transaction that last wrote it, ADR-0014) on every live-update signal, on app start and resume, on reconnect, and when a tag is scanned (the card shows cached data at once, then refreshes).
4. While the app is in the foreground it keeps one WebSocket to its household's live-update channel (`GET /v1/live`). The socket carries only "something changed" signals; data always comes through the pull. The socket closes when the app goes to the background.

**API client.** The app depends only on the versioned API, through a Dart client generated from the OpenAPI spec. The Supabase SDK is used for sign-in and token refresh only. Every request sends `X-App-Version`, `X-Platform` and `X-API-Version`. A `426 Upgrade Required` response opens a blocking update screen; below the recommended version, a dismissible prompt appears. Parsing is tolerant: unknown fields and enum values are ignored, never fatal.

**Conflict rules.**

- Watering events are append-only and idempotent (client-generated UUID v7). "Last watered" is derived as the latest event, so two people watering offline never conflict.
- Plant edits use last-write-wins per field with server timestamps.
- Deletes are soft deletes (`deleted_at`) so they sync reliably; purge after 30 days.

**Deep link handling.** One route `/p/:tagToken` resolves the token against the local database first, then the server, then shows "Unknown tag". Cold start from a tag scan must not pass through onboarding or the home screen when the user is logged in.

**Error handling.** Typed failures in the domain layer; no unhandled exceptions reach the UI. Every error state has a human-readable message and a recovery action.

**Design system.** Central tokens for colour, typography, spacing, radius and motion. Material 3 on Android with platform-adaptive controls on iOS (date pickers, dialogs, haptics). Light and dark themes. No hard-coded colours or strings in widgets.

## 6. Backend architecture

The app talks to exactly one backend: a versioned API on Cloudflare Workers. Supabase sits behind it as a private database, auth and storage platform; the app never reads or writes tables directly, so the schema can change without breaking app versions in the wild.

**API gateway and contract**

- Base URL `https://api.plants.pampait.pl/v1`. MVP endpoints: `POST /sync/push`, `GET /sync/pull?cursor=`, `POST /households`, `POST /invites`, `POST /invites/accept`, `GET /tags/{token}`, `POST /photos/upload-url`, `GET /account/export`, `DELETE /account`, `GET /config`.
- The OpenAPI 3.1 spec in the repo is the source of truth. The Worker validates every request and response against it; the Dart client is generated from it.
- The app signs in with Supabase Auth and sends the access token. The Worker verifies it against Supabase's published signing keys (JWKS) and rejects anything else.
- Versioning: major version in the URL; changes within a version are additive only. A breaking change means a new version run side by side. Old versions return a `Sunset` header and stay available for at least 6 months after their replacement ships.
- Version enforcement: minimum and recommended app versions per platform live in a config table, served by `GET /config`. Requests below the minimum get `426 Upgrade Required`.
- Push requests carry client UUIDs and an `Idempotency-Key`; responses report a result per item, so retries are safe.
- Rate limits per user on all endpoints and per IP on public ones.

**Environments.** Three Supabase projects: `dev`, `staging`, `prod`. Schema changes only through versioned SQL migrations in the repo (`supabase/migrations`), applied by CI. No manual changes in the dashboard.

**Access control.**

- RLS enabled on every table, default deny. Policies grant access only where `household_id` is in the caller's memberships.
- A `security definer` helper `is_member(household_id)` is used by all policies; it is covered by tests.
- The mobile app uses the anon key for Supabase Auth only. The Data API is disabled for client roles, so tables, views and functions are unreachable from the app. The service role key never leaves the server.
- Write policy tests (pgTAP or SQL test scripts) proving a user cannot read or write another household's rows.

**Worker handlers behind the API**, each small and tested:

- `create-invite` and `accept-invite`: generate and redeem single-use, expiring invite codes.
- `public-plant`: given a tag token, returns the public care card fields only, or 404. Rate-limited.
- `live-updates`: one Durable Object per household holds the members' foreground WebSockets (hibernation API) and broadcasts a change signal after every accepted push.
- `reminder-digest`: a Cron Trigger every 15 minutes finds users whose digest time has arrived, computes due plants from the latest data, and sends a visible FCM notification (or none if nothing is due).
- `digest-update`: after a push containing new watering events, re-sends the day's digest to members who already received it, with the same tag or collapse ID, so it silently replaces the one on screen.
- `delete-account` and `export-data`: GDPR flows.

The Worker reaches Postgres through Cloudflare Hyperdrive with a dedicated database role. In each transaction it sets the verified user's claims, so RLS policies still apply as defence in depth. Business logic lives in Worker code and private Postgres functions that clients cannot call. Account deletion and notifications use narrowly scoped elevated functions. Because every write passes through the Worker, no database webhooks are needed.

**Change notifications** (ADR-0013). Clients never subscribe to tables, and correctness never depends on silent push.

- **App open:** the household Durable Object sends a small versioned signal over the WebSocket, e.g. `{"type":"changed","v":1,"cursor":"…"}`, and the app pulls through the API.
- **App closed:** nothing needs to reach the app. Reminders are server-sent visible notifications, computed at send time and replaced in place when plants are watered. They carry generic text only (for example "3 plants need water"), never nicknames or member names, and expire after a few hours (FCM TTL).
- **Best effort only:** a high-priority FCM data message may also trigger a background pull, but nothing relies on it.
- Supabase Realtime is not used.

**Storage.** Plant photos in a private bucket, path `household_id/plant_id/uuid.jpg`, with RLS. Client resizes to max 1600 px and strips EXIF location before upload. The API issues short-lived signed upload and download URLs; cache on device.

**App domain.** One domain (`plants.pampait.pl`) hosts:

- `/.well-known/apple-app-site-association` (Universal Links, paths `/p/*`).
- `/.well-known/assetlinks.json` (Android App Links, `autoVerify` enabled).
- `/p/{tagToken}`: the web fallback page, server-rendered, under 50 KB, no third-party scripts or cookies.
- Privacy policy, terms and support pages.

The API is served from `api.plants.pampait.pl` by the same Worker project.

## 7. NFC specification

The tag stores one HTTPS link and nothing else; all plant data lives in the app and backend.

**Tag format**

- Hardware: NTAG213 or NTAG215 stickers; on-metal variant for metal pots.
- One NDEF message with one URI record: `https://plants.pampait.pl/p/{tagToken}`.
- `tagToken`: 128-bit cryptographically random value, base62-encoded (about 22 characters). It is not the plant ID, so a tag can be re-assigned and IDs are never exposed.
- No personal data, household ID or plant name on the tag.
- Do not add an Android Application Record: it would send non-app users to the Play Store and break the web fallback.
- Do not permanently lock tags in MVP. Document that anyone with an NFC writer could overwrite a tag; the impact is limited to that sticker.

**Read flows**

- iPhone XS and later: background tag reading shows a system banner; tapping it opens the Universal Link in the app.
- Android: verified App Link opens the app directly on the plant route.
- In-app "Scan" button: foreground read session for older iPhones and as a fallback when background reading is unavailable.
- Phones without NFC: each plant can generate a printable QR code with the same URL.

**Write flow**

1. User taps "Write sticker" on a saved plant.
2. App opens a foreground NFC session (iOS: NDEF reader session with a clear alert message; Android: reader mode, which stops the system from dispatching the tag elsewhere).
3. Before writing, check the tag is NDEF-writable and has enough capacity. If it already holds one of our links, offer to re-assign it; if it holds other data, warn before overwriting.
4. Write the record, read it back and compare, then save the tag-to-plant link (works offline via the outbox).
5. Show success with a haptic. On failure, show the specific reason (moved too fast, not writable, too small) and a retry.

**Platform setup**

- iOS: NFC Tag Reading capability, `NFCReaderUsageDescription`, Associated Domains (`applinks:`). Requires a paid Apple Developer account and a physical device.
- Android: `NFC` permission, `uses-feature android.hardware.nfc` with `required=false` so non-NFC phones can still install and use QR, intent filter with `autoVerify=true` for `/p/` paths.

**Test matrix.** At minimum one older and one current iPhone and two Android devices from different manufacturers (e.g. Pixel and Samsung). Test locked screen, app killed, app in background, app not installed, airplane mode.

## 8. Data model and preset database

All synced tables carry `id` (UUID v7), `household_id`, `created_at`, `updated_at`, `deleted_at` and `change_xid` (the sync cursor, ADR-0014). Timestamps are UTC; convert to local time only in the UI.

| Table | Key fields | Notes |
| --- | --- | --- |
| `households` | name, public\_cards\_enabled, hemisphere | One per home |
| `household_members` | household\_id, user\_id, display\_name, joined\_at | Equal rights in MVP |
| `invites` | household\_id, code\_hash, expires\_at, used\_at | Store a hash, never the code |
| `plants` | nickname, preset\_id, room, photo\_path, overrides (interval\_summer\_days, interval\_winter\_days, amount, method, notes) | Overrides null = use preset |
| `tags` | token, plant\_id, written\_at, written\_by | Unique token; one active tag per plant |
| `watering_events` | plant\_id, user\_id, watered\_at, source (scan, list, bulk) | Append-only |
| `devices` | user\_id, platform, push\_token, last\_seen\_at | For FCM |
| `notification_prefs` | user\_id, digest\_time, time\_zone, enabled, muted\_plant\_ids | Per user; the time zone is needed for server-sent digests |
| `client_versions` | platform, min\_version, recommended\_version | Server-only; version enforcement (FR-10) |
| `digest_sends` | user\_id, local\_date, sent\_at, plant\_ids, collapse\_key | Which digest each user got today, so it can be replaced in place |
| `sync_changes` | change\_id, household\_id, idempotency\_key, status, problem | Server-only; one row per pushed change, so retries are safe (ADR-0019) |

Derived values (last watered, next due, overdue) are computed, not stored, so they can never drift.

**Preset database**

- A curated, versioned `presets.json` bundled with the app (offline, instant search). Target 120–150 common houseplants for v1.
- Fields per preset: `id` (stable slug), `common_name`, `latin_name`, `aliases[]` (including other languages), `interval_summer_days`, `interval_winter_days`, `method` (top, bottom, soak, mist), `amount` (small, medium, large, plus a plain-language hint), `soil_check` (e.g. "top 2 cm dry"), `light`, `tips[]` (max 3, under 120 characters each), `pet_toxic` (yes, no, unknown), `sources[]`.
- Validate with a JSON Schema in CI; reject duplicates, missing fields and out-of-range intervals (1–60 days).
- Write all care text in original wording. Do not copy text or data sets from other apps or websites; use reputable horticultural references only to check facts, and list them in `sources`.
- Plants keep a copy of the preset version they were created with; a later preset update never silently changes a user's overrides.
- Search: normalise accents and case, match prefixes and aliases, fuzzy match with edit distance 1–2.

## 9. Non-functional requirements

These are acceptance criteria, measured on a mid-range Android phone about three years old and a current iPhone, in release builds. Each target needs an automated check or a documented manual test.

| Area | Requirement | Target |
| --- | --- | --- |
| Performance | Tag scan to plant card visible | ≤ 1.5 s warm start, ≤ 2.5 s cold start |
| Performance | App cold start to interactive plant list | ≤ 2 s |
| Performance | "Watered" tap to visual and haptic feedback | ≤ 100 ms |
| Performance | Scrolling and animations | 60 fps, < 1% janky frames |
| Performance | Download size per platform | < 30 MB |
| Sync | Watering by one member visible to others when online | ≤ 5 s at p95 |
| Offline | Read cards, log watering, add and edit plants without network | 100% of these flows work; no data loss after app kill or reboot |
| Reliability | Crash-free sessions | ≥ 99.5% |
| Reliability | Backend backups | Daily backups on prod, restore tested before launch |
| Security | Mobile app baseline | OWASP MASVS L1; no high findings from MobSF scan |
| Security | Data isolation | RLS on every table; automated tests prove no cross-household access |
| Security | Credentials | Session tokens in Keychain or Keystore; no secrets in the repo or app bundle; secret scanning in CI |
| Security | Transport | HTTPS only, TLS 1.2+, no cleartext traffic allowed in app config |
| Security | Public endpoints | Rate-limited; tokens unguessable (128-bit); 404 for unknown and disabled tokens alike |
| Security | Dependencies | Automated vulnerability scanning; no known critical CVEs at release |
| Privacy | Data minimisation | Collect only email, display name, plant and watering data; no analytics or ad SDKs |
| Privacy | GDPR rights | In-app export and account deletion; deletion complete within 30 days |
| Privacy | Photos | EXIF location stripped before upload |
| Privacy | Logs and crash reports | No emails, names, tokens or photo URLs |
| Privacy | Store disclosures | App Store privacy labels and Play Data safety form match actual behaviour |
| Accessibility | Standard | WCAG 2.2 AA equivalent for mobile |
| Accessibility | Screen readers | Every control labelled for VoiceOver and TalkBack; logical focus order |
| Accessibility | Text scaling | Usable at 200% system font size without clipped text |
| Accessibility | Contrast and targets | Text contrast ≥ 4.5:1; touch targets ≥ 44 pt (iOS) and 48 dp (Android) |
| Accessibility | Colour and motion | Status never shown by colour alone; respect reduce-motion |
| Localisation | Strings and formats | All strings in ARB files; locale-aware dates; layouts safe for long text and RTL |
| Battery | Background work | No polling; sync on app open, resume, scan and live-update signals; WebSocket only while the app is in the foreground; NFC sessions only when user-initiated |
| Compatibility | OS versions | iOS 16+ and Android 8.0 (API 26)+ unless current stable Flutter requires higher (record in ADR) |
| Scalability | Capacity without redesign | 10,000 households on the smallest paid Supabase tier; indexes on all foreign keys and `watered_at` |
| Observability | Errors and health | Sentry on app and Workers with release tracking; uptime check on the web fallback; alert on error spikes |
| Compatibility | Old app versions keep working; breaking changes only through a new API version | CI blocks breaking spec changes within a version; ≥ 6 months from replacement to sunset |
| Compatibility | Upgrade enforcement for unsupported app versions | 100% of requests carry version headers; minimum version changeable without an app release |
| Maintainability | Code quality | Strict lint rules, zero warnings in CI; formatter enforced |
| Maintainability | Test coverage | Domain layer ≥ 90%, overall ≥ 70% |
| Maintainability | Onboarding | New developer runs the app locally in ≤ 15 minutes using the README |
| Usability | Add plant | New user adds first plant and writes a tag in ≤ 60 s |
| Usability | Visual quality | Consistent design tokens, light and dark mode, platform-appropriate controls, polished empty and error states |

## 10. Engineering practices

**Repository.** One monorepo: `app/` (Flutter), `supabase/` (migrations, policies, tests), functions/ (Cloudflare Workers API; openapi.yaml is the contract), `web/` (fallback page and well-known files), `presets/` (JSON, schema, validator), `docs/adr/`, `docs/status/` (session status notes), `tools/` (developer tooling such as the Flutter Docker image), `AGENTS.md`.

**Testing**

- Unit tests for all domain use cases (next-due calculation, season switching, conflict rules, preset search).
- Widget tests for every screen, including empty, loading, error and offline states.
- Golden tests for key screens in light, dark and 200% text size.
- Integration tests for scan-to-card, add-plant and log-watering flows using a fake NFC service.
- Database tests for every RLS policy; Worker tests with Vitest in the Workers runtime.
- Sync tests: simulate two devices editing offline, then reconnect; assert the conflict rules hold.
- Manual real-device NFC checklist (section 7 test matrix) before each release.

**CI (every pull request)**

- Format check, lint, unit, widget and golden tests, coverage thresholds.
- Supabase migrations applied to a fresh local database; RLS tests run.
- Preset JSON schema validation; API contract tests and an OpenAPI breaking-change check (e.g. oasdiff) against the last released spec.
- Secret scanning and dependency vulnerability scan.
- Debug builds for iOS and Android must succeed.

**CD**

- Merges to `main` deploy to staging and ship internal builds (TestFlight, Play internal testing) via fastlane.
- Production releases from tags, with phased rollout on both stores.
- Database migrations never reach clients directly: every supported API version keeps working across them (expand, migrate, then contract).

**Conventions**

- Conventional Commits; small pull requests (target under 400 changed lines) with a description linking FR and NFR IDs.
- An ADR for every significant decision: context, options, decision, consequences.
- Semantic versioning for the app; build numbers from CI.
- Feature flags (simple remote config table) for anything risky or incomplete.

## 11. Milestones and definition of done

Work strictly in this order; each milestone ends with a demo on real devices and a short written status. iOS is currently deferred (ADR-0009): demos, exits and test-matrix rows apply to Android only until it resumes.

1. **M0 Foundations.** Monorepo, Flutter skeleton with design tokens and theming, CI pipeline, three Supabase environments, Sentry, ADRs for the stack. Exit: CI green, app launches on both platforms.
2. **M1 NFC spike.** Write a link to a tag; scanning opens the app on a test route on both platforms (installed, killed, locked). Domain with AASA and assetlinks live. Exit: test matrix passes; findings recorded in an ADR.
3. **M2 Data and sync.** Schema, migrations, RLS with tests, auth, API gateway with OpenAPI contract and version enforcement, household and invites, Drift database, outbox and sync engine, live updates over WebSocket (one Durable Object per household). Exit: two devices on different platforms share plants and waterings, including offline-then-reconnect.
4. **M3 Presets.** Schema, validator, first 40 presets, offline search. Exit: search meets the 100 ms target; CI validates the file.
5. **M4 Core UX.** Plant list, plant card, add-plant and write-tag flow, log watering with undo, edit and delete, photos. Exit: FR-1, 2, 3, 5, 6 pass; usability target ≤ 60 s met.
6. **M5 Reminders.** Next-due logic, seasons, server-sent daily digest (Cron Trigger), in-place digest updates after household waterings. Exit: FR-4 passes; no reminder lists a plant already watered by someone else, verified on real devices with the app swiped away and in battery-saving mode.
7. **M6 Web fallback and account.** Public card page, disable toggle, export and account deletion, QR fallback. Exit: FR-8 and FR-9 pass.
8. **M7 Hardening and release.** Full NFR audit, accessibility pass, remaining presets to 120+, store listings, privacy labels, internal then phased release. Exit: every row in section 9 is green.

**Definition of done (every task)**

- [ ] Acceptance criteria for the referenced FR met and demonstrated.
- [ ] Relevant NFR targets checked; no regression in existing ones.
- [ ] Tests written and passing in CI; coverage thresholds held.
- [ ] Accessibility labels, dark mode, large text and offline behaviour checked for any new UI.
- [ ] No new lint warnings, secrets or unapproved dependencies.
- [ ] Docs, ADRs and `AGENTS.md` updated if behaviour or structure changed.

## 12. Working agreement and open decisions

**How agents work**

- Before coding a task, write a short plan: files to touch, FR and NFR IDs covered, tests to add. Then implement.
- Ask the product owner before changing the stack, the scope or any non-goal. Decide everything else yourself and record it in an ADR.
- Never weaken a check to make it pass: no disabled tests, lowered coverage thresholds, ignored lint rules or loosened RLS policies.
- Never commit secrets, real user data or production keys. Use `.env.example` with placeholders.
- Do not add AI features, analytics, ads, tracking or new third-party services without explicit approval.
- When several agents work in parallel, one agent owns database migrations at a time; others request schema changes through it. Rebase before merging and keep `main` releasable.
- End each session with a status note: done, in progress, blocked, next step, and any risks.

**Open decisions (confirm with the product owner)**

- [x] Framework: Flutter (confirmed 2026-10-23, ADR-0008).
- [x] Platforms: **Android only for now; iOS deferred** (2026-10-23, ADR-0009). Where this brief says iOS, iPhone or "both platforms", apply it to Android until iOS resumes.
- [ ] Personal use only, or public store release? This sets the M7 scope (store listings, support page, legal review).
- [x] Domain `plants.pampait.pl` (API at `api.plants.pampait.pl`); bundle ID and application ID `pl.pampait.plantnfc` (confirmed 2026-10-23, ADR-0008). App name still provisional ("Plant NFC").
- [x] Architecture: the app talks only to the versioned API on Cloudflare Workers, never to Supabase tables (confirmed 2026-10-26, ADR-0012).
- [x] Live updates and reminders: foreground WebSocket through a Durable Object per household; server-sent visible digest, replaced in place; silent push never relied on (confirmed 2026-10-27, ADR-0013).
- [x] Sign-in: external identity providers only (Google; Apple with iOS); no email magic links or passwords (confirmed 2026-10-29, ADR-0022).
- [ ] App languages for v1 and the default hemisphere for seasons.
- [ ] Push provider: FCM for both platforms (default) or direct APNs for iOS.
- [ ] Should the web fallback card be on or off by default for new households?
