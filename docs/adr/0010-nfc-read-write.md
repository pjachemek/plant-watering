# ADR-0010: NFC tag reading, writing and link dispatch (M1)

- Status: Accepted for the spike. Findings from real devices are added in the "Device findings" section before M1 closes.
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

## Device findings

_To fill in from the [NFC test matrix](../testing/nfc-test-matrix.md) before M1 closes._

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
