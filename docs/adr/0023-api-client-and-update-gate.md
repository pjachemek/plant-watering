# ADR-0023: App API client and the update gate

- Status: Accepted
- Date: 2026-10-29
- Related: M2 increment 2.9a; AGENTS.md sections 5 and 6; ADR-0015, ADR-0016, ADR-0021; FR-10; NFR Compatibility, Battery

## Context

The app talks only to the versioned API, through the client generated from the contract (ADR-0015). The brief requires:

- every request carries `X-App-Version`, `X-Platform` and `X-API-Version`;
- a `426` opens a blocking update screen;
- below the recommended version, a dismissible prompt appears;
- parsing is tolerant.

The access token comes from Supabase Auth (ADR-0021).

## Decision

**One Dio client for the API**, with three interceptors:

1. **Version headers on every request**, set centrally so no call can forget them. The app version is a constant (`core/config/app_version.dart`), and a test fails if it differs from `pubspec.yaml`. That saves a package just to read the version at run time.
2. **The access token.** On a `401`, the client refreshes the token once and retries with the new one; a second `401` is passed on. A retried request keeps its refreshed token (a device-independent bug caught by a test).
3. **`426` → the update screen**, at once, from any call.

**Typed failures.** `guardApi` turns every error into an `ApiFailure`:

| Failure | Cause |
| --- | --- |
| `network` | No connection or no answer |
| `unauthorized` | 401 or 403 |
| `notFound` | 404 |
| `conflict` | 409 |
| `rateLimited` | 429 |
| `upgradeRequired` | 426 |
| `server` | 5xx |
| `badRequest` | Any other 4xx, a broken certificate, or an unparseable answer |

No exception reaches the UI. Unknown fields and enum values are already ignored by the generated models (ADR-0015).

**The update gate (FR-10):**

- **When it's checked:** `GET /v1/config` at start and on every resume, with no polling (NFR Battery). Offline, nothing changes.
- **Below the minimum:**
  - A blocking screen, reached by a router redirect that comes **before** the sign-in check, so it also blocks a signed-out app.
  - The back button is disabled. The only action opens the store listing.
  - Lowering the minimum on the server lets the app back in at the next resume, without a release.
- **Below the recommended version:**
  - A banner under every screen, with **Update** and **Dismiss**.
  - Dismissing lasts for the session.
  - It's built from text buttons, not icon tooltips, so it works above the navigator and wraps at 200% text.
- **Offline data is never touched:** whatever is queued stays queued and syncs after the update (increment 2.9b–c).

**Store link:** `https://play.google.com/store/apps/details?id=pl.pampait.plantnfc`, opened in the Play Store app via `url_launcher`. If it can't be opened, the app says so. The manifest declares the https VIEW intent in `<queries>` (Android 11+ package visibility).

## Dependencies

| Package | Use | Licence | Publisher | Maintenance (2026-10-29) |
| --- | --- | --- | --- | --- |
| `url_launcher` ^6.3.3 | Open the store listing | BSD-3-Clause | flutter.dev | Flutter team package, released 2026-10-02 |

## Consequences

- Every feature calls the API through `plantApiProvider` and `guardApi`, and gets the headers, token refresh and update gate for free.
- Tests fake the HTTP layer (`FakeHttpAdapter`) and the version policy (`FakeVersionPolicySource`).
- On iOS (when it resumes), the store link and `X-Platform` change with the platform.
