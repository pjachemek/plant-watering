# ADR-0010: NFC tag reading, writing and link dispatch (M1)

- Status: Accepted. Device findings and the decisions taken from them are recorded below (2026-10-28).
- Date: 2026-10-26
- Related: FR-1, FR-3 (write flow), AGENTS.md section 7; NFR Security, Battery, Performance

## Context

M1 proves that a phone can write our link to a sticker and that scanning the sticker opens the app on the tag route. iOS is deferred (ADR-0009), so this ADR covers Android only.

## Decision

**Plugin.** `nfc_manager` 4.x, with its companions `nfc_manager_ndef` (cross-platform NDEF read and write) and `ndef_record` (message encoding). It's the plugin the brief names, and its Android session uses reader mode, which stops the system from dispatching the tag to other apps while we read or write.

**Tag content.** One NDEF message holding one NFC Forum URI record: prefix code `0x04` (`https://`) followed by `plants.pampait.pl/p/{token}`. The token is 128 bits from `Random.secure`, base62-encoded to a fixed 22 characters (`TagToken`). The message is 47 bytes, which fits an NTAG213 (144 bytes of user memory) with plenty of room. We write no Android Application Record and never lock tags. `NdefUriCodec` encodes and decodes URI records itself, because `ndef_record` has no URI helpers.

**Write flow** (`NfcManagerService.writeLink`), following section 7:

1. Open a user-initiated session. If NFC is off or missing, fail with `NfcUnavailable` before opening one.
2. On the tag: if it isn't NDEF → `TagNotNdef`. If it already holds other data and the user hasn't confirmed → `OverwriteNeedsConfirmation(existing)`, without writing. The UI asks, and the user taps again with `overwrite: true`. A tag that already holds this exact link counts as success.
3. Check that the tag is writable (`TagReadOnly`) and that the message fits (`TagTooSmall`).
4. Write, read back and compare. A mismatch → `WriteNotVerified`.
5. Close the session. Android `TagLostException` and `IOException` map to `TagLost` ("moved away too soon"). Any other platform error becomes `NfcUnknownFailure(code)`, which carries only the error class name, never tag contents.

**Opening the app from a tag.** The main activity has two intent filters for `https://plants.pampait.pl/p/…`:

- `NDEF_DISCOVERED`, so Android's tag dispatcher can deliver a scanned tag straight to the app.
- `VIEW` with `autoVerify="true"` (a verified App Link), for the same URL opened from a QR code, a message or the browser. Verification uses `/.well-known/assetlinks.json`, served by the Worker.

Flutter's built-in deep linking passes the intent URI to go_router, which matches `/p/:tagToken` directly. A cold start never shows the home screen first.

**Spike UI.** `/dev/nfc` is a developer screen that can write a fresh test link, read a sticker, and open the tag route. It's registered only in debug builds (`kDebugMode`), with an app-bar entry on the plant list. The production write flow (FR-3) arrives in M4 and reuses `NfcService`.

## Emulator findings (2026-10-26)

Tested on an API 37 emulator, which has no NFC hardware, so dispatch was simulated with `adb shell am start`.

| Check | Result |
| --- | --- |
| Cold start from `NDEF_DISCOVERED` to the tag screen (intent sent to our app) | Tag screen shown directly, no home screen |
| `VIEW` App Link, domain approved, warm start | Opened in our app with no chooser (`HOT`, 1.0 s) |
| `VIEW` App Link, domain approved, cold start | Opened in our app with no chooser, tag screen shown |
| `NDEF_DISCOVERED` for our URL, no target component | **Chooser shown**: Chrome also registers `NDEF_DISCOVERED` for every `https` URL |

The cold starts took 8–9 s on the emulator with software graphics and a debug build. That says nothing about the NFR (2.5 s cold, measured on a release build on a real phone).

**Open risk to check on devices:** when a real tag is scanned with Chrome installed, Android may show a chooser between our app and Chrome. That would break FR-1's "no extra taps". Android ignores priority on non-system apps, and an Android Application Record is ruled out by the brief. Options if the chooser appears:

1. The user picks the app once with "Always". Later scans go straight to the app. This needs a one-time hint in onboarding.
2. Check whether the device's NFC dispatcher falls back to `VIEW` for `https` URIs. If it does, the verified App Link wins without a chooser, and we could drop the `NDEF_DISCOVERED` filter.
3. Use the in-app "Scan" button (foreground reader mode), which never involves the dispatcher.

## Device findings (2026-10-28)

Tested on a **Pixel 9 Pro, Android 17 (build CP3A.261005.005)**, debug build signed with the development key. `plants.pampait.pl` was live and App Links showed `verified`. Evidence comes from logcat (`NfcDispatcher`, `NfcService`, activity manager).

| Scenario | Result |
| --- | --- |
| Write a blank sticker, read it back, open the plant link | ✅ |
| Overwrite our own link (confirmation shown first) | ✅ |
| Write with a shaky hand | Once showed "didn't save the link correctly"; a retry worked. The cause can't be proven (the log had rolled over). Mitigated: read-back is retried once and the message asks the user to hold still |
| **Scan with the app closed or in the background** | Android 17's NFC service logs `tryNdef: matched Web link - prompting user` and shows a **notification the user must tap**; it then sends the link as a normal `VIEW` intent, and the verified App Link opens our app with **no chooser**. Our `NDEF_DISCOVERED` filter isn't used for web links |
| **Scan with the app open** (after the change below) | Delivered straight to the app as `NDEF_DISCOVERED`: **no prompt**, tag screen opens |
| Phone left resting on the sticker after a write | Before the fix: Android re-detected the sticker and showed its prompt. After the fix: nothing happens ✅ |
| Leave the NFC screen and return (Home, then reopen), then write | ✅ |
| Link opened from outside the app while it runs | Before the fix: a **second copy of the app** was created in the NFC system task. After the fix: the running copy is reused ✅ |
| Cold start, app closed | 1.3–1.6 s to the first screen (debug build) |

**Answer to the open risk above:** no Chrome chooser on this device. Instead, Android 17 asks for **one confirmation tap** before opening any web link from a sticker. This is an OS rule and can't be avoided without an Android Application Record, which the brief rules out.

### Decisions taken from the findings (product owner, 2026-10-28)

1. **Accept one tap when the app isn't open.** FR-1's "no extra taps" holds while the app is open; with the app closed, Android's prompt adds one tap.
2. **Foreground dispatch filtered to our domain** (`MainActivity`). While the app is on screen, Android hands stickers with `https://plants.pampait.pl/p/…` straight to the app. Every other tag, and phone-as-card features such as contactless payment, keep working through Android. The pending intent targets `MainActivity` explicitly (it must be mutable so Android can attach the tag). It adds no polling, so it's consistent with the battery NFR's intent.
3. **Android drops the foreground filter when reader mode ends.** So Dart switches it off while a write or read session is open and back on when the session closes, through the `pl.pampait.plantnfc/tag_dispatch` channel.
4. **NFC sessions last as long as the screen that uses them.** Stickers seen while no operation is pending are ignored, so a phone still on a sticker after a write is never handed back to Android.
5. **`launchMode="singleTask"`** (kept with `taskAffinity=""`): links opened from outside reuse the running app instead of starting a second copy with its own Flutter engine.
6. **Write verification re-reads once** before reporting a mismatch.

### Not covered on devices yet

These checklist rows still need running before release (the [test matrix](../testing/nfc-test-matrix.md) is the checklist):

- A **second Android phone from another manufacturer** (for example Samsung).
- App swiped away (killed), phone locked, app not installed (web fallback page), airplane mode, an on-metal sticker, a foreign-data sticker, NFC turned off.
- Timings on a release build (NFR: 1.5 s warm and 2.5 s cold from tag to card).

## Consequences

- All NFC access goes through `NfcService`, so widget tests use `FakeNfcService` and no test needs NFC hardware.
- The spike screen ships only in debug builds, so release builds have no unfinished UI.
- If devices confirm the chooser problem, FR-1 needs one of the options above, decided in this ADR's device findings.

## Dependencies added

| Package | Constraint (locked) | Licence | Maintenance | Why |
| --- | --- | --- | --- | --- |
| nfc_manager | ^4.2.1 | MIT | okadan.net, 160/160 pub points, about 530 likes, last release 2026-04 | NFC sessions on Android and iOS (named in the brief) |
| nfc_manager_ndef | ^1.1.0 | MIT | Same publisher, 160/160 pub points | Cross-platform NDEF read and write on top of nfc_manager |
| ndef_record | ^1.5.0 | MIT | Same publisher, 160/160 pub points, last release 2026-09 | NDEF message encoding and decoding (already a dependency of nfc_manager) |
