# ADR-0013: Live updates by WebSocket, reminders by server-sent visible notifications

- Status: Accepted
- Date: 2026-10-27
- Decided by: product owner, choosing from the options below
- Supersedes: the "Change notifications" design in [ADR-0012](0012-api-gateway.md) (FCM silent push as the change signal)
- Related: FR-2 (others see a watering within 5 s), FR-4 (reminders, cleared when someone else waters); NFR Sync, Battery, Privacy

## Context

ADR-0012 used FCM silent push both to refresh other members' apps and to clear their pending reminders. The product owner questioned its reliability, rightly:

- **iOS:** background (`content-available`) pushes are low priority and throttled, and aren't delivered at all after the user swipes the app away.
- **Android:** high-priority data messages usually arrive, even in Doze, but apps in the "restricted" battery bucket, aggressive manufacturer battery managers, and force-stopped apps lose them.
- **Local notifications** fire on schedule without running app code, so a locally scheduled reminder can't check whether the plant was already watered.

Visible notifications behave differently. The OS displays them without waking the app, and replaces an earlier one that has the same Android `tag` or iOS `apns-collapse-id`, again without app code.

The problem splits in two: **live freshness while the app is open**, and **reminder correctness while it is closed**.

## Options considered

**Live updates (app open)**

| Option | Notes |
| --- | --- |
| **A1. WebSocket to a Durable Object per household** | Typically under 1 s; stays on Cloudflare; no Supabase SDK in the app |
| A2. Supabase Realtime Broadcast | Equally fast, but brings the Realtime client back into the app |
| A3. Pull on open, resume and scan, plus foreground polling | Simplest, but misses 5 s unless polling hard, which goes against the battery NFR |

**Reminders (app closed)**

| Option | Notes |
| --- | --- |
| **B1. Server-sent visible digest, replaced in place** | Correct at send time; needs the phone online near digest time |
| B2. Local digest plus best-effort background sync | Works offline, but correctness depends on the OS running background work |
| B3. Local digest only, corrected when the app opens | Simplest; misses FR-4's "cleared on all devices" |

## Decision

**A1 + B1.**

**Live updates**

- While in the foreground, the app opens one WebSocket to `GET /v1/live`. It's authenticated like any API call, with the access token in the `Authorization` header (the app's WebSocket client can send headers, unlike browsers), so the token never appears in URLs or logs.
- The Worker routes the socket to the household's Durable Object, which uses the hibernation API so idle sockets cost almost nothing.
- After every accepted `POST /v1/sync/push`, the Worker tells that Durable Object to broadcast `{"type":"changed","v":1,"cursor":"…"}`. The app then pulls through `GET /v1/sync/pull`. The socket carries signals only, never data.
- The app also pulls on start, resume, reconnect and tag scan. On a scan, the card renders from cache immediately and then refreshes, so the most important moment, standing at the pot, is always fresh.

**Reminders**

- A Cron Trigger runs every 15 minutes. For each user whose `digest_time` has arrived in their `time_zone`, it computes due plants from the latest data, sends a visible FCM notification (or nothing), and records it in `digest_sends`.
- After a push containing watering events, the Worker re-sends the day's digest to members who already received one. It uses the same tag or collapse ID, with no sound, so the shown notification is replaced by the new list or a quiet "All plants watered".
- Notification text is generic ("3 plants need water"), never nicknames or member names, because payloads pass through Google's servers (and Apple's, later). The FCM TTL is a few hours, so a phone that was offline doesn't get yesterday's digest.
- On Android, FCM notification messages aren't shown automatically while the app is in the foreground. `flutter_local_notifications` displays them in that case and is only used for that.

**Silent push** may still be sent as a high-priority data message to trigger a background pull, but no requirement depends on it.

## Consequences

- **FR-4 holds without background execution:** a digest is correct when sent, and corrected in place afterwards.
- **NFR Sync (≤ 5 s):** met by the WebSocket while the app is open. A closed app has nothing to update on screen, and it pulls on open.
- **Offline phones** get the digest when they reconnect within the TTL. A local fallback that fires only if no server digest arrived could be added later; it's not in the MVP.
- **New infrastructure:** Durable Objects (one class, SQLite-backed, with the hibernation API) and a Cron Trigger. Check the Cloudflare plan limits for Durable Objects before M2. Both are tested with Vitest in `workerd`, and Durable Objects run locally in `wrangler dev`.
- **Data model:** `notification_prefs.time_zone` and a `digest_sends` table (`AGENTS.md` section 8).
- **Milestones:** live updates join M2 (they belong to the sync exit). Server digests and in-place updates are M5. M5's exit is verified with the app swiped away and in battery-saving mode on real devices.
- **Privacy:** the new rule (generic notification text) is in `AGENTS.md` section 6. The store privacy disclosures in M7 must mention push notifications.
