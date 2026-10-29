# ADR-0026: Household screens, invite links, live client and sign-out

- Status: Accepted
- Date: 2026-10-29
- Related: M2 increment 2.10; FR-2, FR-7; ADR-0013, ADR-0018, ADR-0020, ADR-0024, ADR-0025; NFR Sync, Battery, Privacy, Accessibility

## Context

M2 ends with two phones sharing plants and waterings, including after being offline (AGENTS.md section 11). Several pieces were still missing:

- getting people into one household;
- the app's side of live updates;
- removing household data when someone signs out;
- a way to create plants and waterings before the plant screens arrive (M4).

## Decision

**Households (FR-7):**
- Without a household, the home screen offers **Create a household** or **Join with a code**.
- The app shows one household, the oldest it belongs to. The data model allows more, and switching can come later without breaking changes.
- **Invites** show the 12-character code once, in large monospace text, with a **Copy link** button. A screen reader spells the code out character by character.
  - There's no share sheet, to avoid another dependency. Copying the link covers messaging apps.
- **The join form** takes the code or the whole invite link.
- **Invite links** (`https://plants.pampait.pl/i/{code}`) are a verified App Link (`/i/` in the manifest, already covered by `assetlinks.json`). They open the join screen with the code filled in.
  - If the person is signed out, sign-in comes first, then the join screen (the router keeps the destination, ADR-0021).
  - In a browser, the Worker serves a static page that explains what to do. The page never shows the code or checks it; only the app redeems it, for a signed-in person.
- **Leaving** asks for confirmation. The last member gets a second warning that the household and all its plants and waterings are deleted for everyone.
- **Online only:** creating, joining, inviting and leaving need the server, and say so when offline. Everything already on the phone still works offline.

**Live updates client (ADR-0013, ADR-0020):**

| Aspect | Behaviour |
| --- | --- |
| Transport | `dart:io` `WebSocket`, behind a `LiveTransport` interface so tests can fake it. No new dependency. |
| When it's open | Signed in, in the foreground, with a household. It closes on pause or sign-out, and moves when the household changes. |
| On connect | One sync, to catch up on anything missed while closed |
| "changed" signal | A sync, debounced with other triggers; unknown message types are ignored |
| Keepalive | `ping` every 30 s; the server answers without waking its object |
| Close 4001 | Refresh the access token, reconnect at once |
| Close 4003 | Stop and sync, which drops the household from the phone |
| Other drops and failed connects | Reconnect with backoff, 1 s doubling to 60 s, ±20% jitter, only in the foreground |

Like the sync controller, the live provider is *listened to* for the app's lifetime, because Riverpod 3 pauses a provider nobody listens to.

**Signing out:**
- Before signing out, the app counts the outbox. If changes haven't reached the server, it warns that they'll be lost and asks for confirmation.
- Signing out then clears the local database (`clearAll`, ADR-0024), so the next account on the phone never sees the previous household.

**Sync test screen (debug builds only):** `/dev/sync`, like the M1 NFC screen.
- It shows the sync status, the live status and the number of queued changes.
- It can add a test plant (a custom plant with 7/14-day intervals), water it and undo, showing the last watering and who did it.
- It writes through `LocalChanges` and reads Drift directly. The real plant screens (M4) will go through feature repositories.
- It has **no widget test**. Drift's stream queries need real time, which hung the widget test's fake clock. Everything it uses is covered elsewhere: the `LocalChanges`, sync engine and household repository tests (against SQLite), and the controller and live tests. The screen itself is exercised by the M2 exit test on devices. It isn't in release builds.

**Test helpers:** `testOverrides` gives every widget test fake sign-in, version policy and households; no sync, socket or database; and a sign-out without a database. Riverpod refuses a second override of the same provider, so tests change these through parameters, not by adding overrides.

## Consequences

- **The M2 exit test can run.** Two Android devices (the Pixel and an emulator, or a second phone) on the deployed `development` Worker:
  1. Phone A creates a household and invites; phone B joins.
  2. Test plants and waterings appear on the other phone within seconds.
  3. Offline edits on both phones match after reconnecting.
- **The `development` Worker must be redeployed first.** It doesn't have the live-updates Durable Object (2.7) or the invite page yet. The invite page also needs the production Worker to be redeployed for `plants.pampait.pl`.
- **M4 replaces the sync test screen** with the real plant list, card and watering flow, and moves sign-out to a settings screen.
