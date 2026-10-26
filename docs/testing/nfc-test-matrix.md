# NFC test matrix (Android)

Manual checklist from AGENTS.md section 7. Run it before M1 closes and before every release. iOS rows come back when iOS resumes (ADR-0009).

## You need

- Two Android phones with NFC from different manufacturers (for example a Pixel and a Samsung), and Chrome installed on both.
- NTAG213 or NTAG215 stickers: blank ones, one with other data (for example a contact card written with any NFC app), and an on-metal sticker if you have metal pots.
- A debug build of the app, signed with the development debug key, so App Links verify against `assetlinks.json`:
  `flutter build apk --debug`, then `adb install -r build/app/outputs/flutter-apk/app-debug.apk`
- The domain live: `https://plants.pampait.pl/.well-known/assetlinks.json` returns JSON (see [deploy.md](../deploy.md)).

## Before you start

1. Check App Link verification on each phone:
   ```
   adb shell pm get-app-links pl.pampait.plantnfc
   ```
   `plants.pampait.pl` should show `verified`. If not, run `adb shell pm verify-app-links --re-verify pl.pampait.plantnfc`, wait a minute and check again.
2. Write a test sticker: plant list → NFC icon in the app bar → **Write test sticker**. Expect "Sticker written and checked" and a vibration.

## Matrix

Record each result as ✅ / ❌ with a note: the phone, the Android version, and whether a chooser appeared.

| # | Scenario | Steps | Expected | Phone A | Phone B |
| --- | --- | --- | --- | --- | --- |
| 1 | Write blank sticker | Write test sticker on a blank sticker | Success and vibration; **Read sticker** shows "plant link" | | |
| 2 | Overwrite our link | Write again on the same sticker | "already has a plant link" → Overwrite → success | | |
| 3 | Overwrite foreign data | Write on the sticker with a contact card | "holds other data" → Overwrite → success | | |
| 4 | Moved too fast | Tap the sticker and pull away immediately while writing | "moved away too soon" + Try again works | | |
| 5 | NFC off | Turn NFC off, tap Write | "NFC is turned off" message | | |
| 6 | App in foreground (other screen) | Scan the sticker from the plant list | Tag screen opens | | |
| 7 | App in background | Home button, scan the sticker | App comes to front on the tag screen | | |
| 8 | App killed | Swipe the app away in recents, scan | App cold-starts on the tag screen, **not** the plant list | | |
| 9 | Phone locked, screen on | Lock the phone, wake the screen, scan | Android needs unlock; after unlock the tag screen opens (note what happens) | | |
| 10 | App not installed | Uninstall the app, scan | Browser opens `plants.pampait.pl/p/…` with the placeholder page | | |
| 11 | Airplane mode | Airplane mode on (NFC stays on), app killed, scan | Tag screen opens; nothing needs network | | |
| 12 | Chooser check | During rows 6–8, note whether a "Open with" chooser appears (app vs Chrome) | Record it. If it appears, pick the app with **Always**, then repeat row 8 | | |
| 13 | QR / link | Open the tag URL from a messaging app | Opens in the app with no chooser (verified App Link) | | |
| 14 | Metal pot | Repeat rows 1 and 8 with an on-metal sticker on a metal pot | Works, or note the read distance | | |
| 15 | Timing | Row 8 with a stopwatch: tap to tag screen visible (debug build, so only indicative) | Note the seconds | | |

## After the run

Add the results and the decision on the chooser question to "Device findings" in [ADR-0010](../adr/0010-nfc-read-write.md).
