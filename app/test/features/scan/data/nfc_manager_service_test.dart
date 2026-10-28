import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ndef_record/ndef_record.dart';
import 'package:nfc_manager/nfc_manager.dart' as nm;
import 'package:nfc_manager/nfc_manager_ios.dart' show NfcReaderSessionErrorIos;
import 'package:plantnfc/core/result/result.dart';
import 'package:plantnfc/features/scan/data/ndef_uri_codec.dart';
import 'package:plantnfc/features/scan/data/nfc_manager_service.dart';
import 'package:plantnfc/features/scan/domain/nfc_service.dart';
import 'package:plantnfc/features/scan/domain/tag_link.dart';
import 'package:plantnfc/features/scan/domain/tag_token.dart';

/// Stands in for the platform plugin. Tags are only delivered when the test
/// calls [discover].
class _FakeManager implements nm.NfcManager {
  nm.NfcAvailability availability = nm.NfcAvailability.enabled;
  PlatformException? startError;
  void Function(nm.NfcTag)? _onDiscovered;
  int starts = 0;
  int stops = 0;

  @override
  Future<nm.NfcAvailability> checkAvailability() async => availability;

  @override
  Future<bool> isAvailable() async =>
      availability == nm.NfcAvailability.enabled;

  @override
  Future<void> startSession({
    required Set<nm.NfcPollingOption> pollingOptions,
    required void Function(nm.NfcTag tag) onDiscovered,
    String? alertMessageIos,
    bool invalidateAfterFirstReadIos = true,
    void Function(NfcReaderSessionErrorIos)? onSessionErrorIos,
    bool noPlatformSoundsAndroid = false,
  }) async {
    starts++;
    final error = startError;
    if (error != null) throw error;
    _onDiscovered = onDiscovered;
  }

  @override
  Future<void> stopSession({
    String? alertMessageIos,
    String? errorMessageIos,
  }) async {
    stops++;
    _onDiscovered = null;
  }

  void discover() => _onDiscovered?.call(const nm.NfcTag(data: Object()));
}

NdefRecord _text(String s) => NdefRecord(
  typeNameFormat: TypeNameFormat.wellKnown,
  type: Uint8List.fromList([0x54]),
  identifier: Uint8List(0),
  payload: Uint8List.fromList([0x02, 0x65, 0x6e, ...s.codeUnits]),
);

void main() {
  group('classifyNdefMessage', () {
    final token = TagToken.generate();
    final ours = NdefUriCodec.recordFor(TagLink.build(token));

    test('null or no records is empty', () {
      expect(classifyNdefMessage(null), const EmptyTag());
      expect(
        classifyNdefMessage(
          NdefMessage(
            records: [
              NdefRecord(
                typeNameFormat: TypeNameFormat.empty,
                type: Uint8List(0),
                identifier: Uint8List(0),
                payload: Uint8List(0),
              ),
            ],
          ),
        ),
        const EmptyTag(),
      );
    });

    test('a single plant link is ours', () {
      expect(
        classifyNdefMessage(NdefMessage(records: [ours])),
        PlantLinkTag(token),
      );
    });

    test('foreign links, text and extra records are foreign', () {
      expect(
        classifyNdefMessage(
          NdefMessage(
            records: [NdefUriCodec.recordFor(Uri.parse('https://x.example'))],
          ),
        ),
        const ForeignDataTag(),
      );
      expect(
        classifyNdefMessage(NdefMessage(records: [_text('hi')])),
        const ForeignDataTag(),
      );
      expect(
        classifyNdefMessage(NdefMessage(records: [ours, _text('hi')])),
        const ForeignDataTag(),
      );
    });
  });

  group('failureFromPlatform', () {
    test('maps Android exceptions to typed failures', () {
      expect(
        failureFromPlatform(PlatformException(code: 'TagLostException')),
        isA<TagLost>(),
      );
      expect(
        failureFromPlatform(PlatformException(code: 'IOException')),
        isA<TagLost>(),
      );
      expect(
        failureFromPlatform(PlatformException(code: 'not_supported')),
        isA<NfcUnavailable>().having(
          (f) => f.availability,
          'availability',
          NfcAvailability.unsupported,
        ),
      );
      expect(
        failureFromPlatform(PlatformException(code: 'tag_not_found')),
        isA<TagNotNdef>(),
      );
      expect(
        failureFromPlatform(PlatformException(code: 'FormatException')),
        isA<NfcUnknownFailure>().having(
          (f) => f.code,
          'code',
          'FormatException',
        ),
      );
      expect(
        failureFromPlatform(StateError('x')),
        isA<NfcUnknownFailure>().having((f) => f.code, 'code', 'StateError'),
      );
    });
  });

  group('verifyWrittenLink', () {
    final link = TagLink.build(TagToken.generate());
    final written = NdefMessage(records: [NdefUriCodec.recordFor(link)]);
    final other = NdefMessage(
      records: [NdefUriCodec.recordFor(TagLink.build(TagToken.generate()))],
    );

    /// Returns each message in turn and counts the reads.
    ({Future<NdefMessage?> Function() read, int Function() count}) reader(
      List<NdefMessage?> messages,
    ) {
      var reads = 0;
      return (read: () async => messages[reads++], count: () => reads);
    }

    test('passes on the first read when the link is there', () async {
      final r = reader([written]);

      expect(await verifyWrittenLink(r.read, link), isTrue);
      expect(r.count(), 1);
    });

    test('re-reads once after an empty or partial read-back', () async {
      final r = reader([null, written]);

      expect(await verifyWrittenLink(r.read, link), isTrue);
      expect(r.count(), 2);
    });

    test('fails after two reads that never show the link', () async {
      final r = reader([null, other]);

      expect(await verifyWrittenLink(r.read, link), isFalse);
      expect(r.count(), 2);
    });

    test('lets a lost tag surface as a platform error', () async {
      Future<NdefMessage?> lost() =>
          Future.error(PlatformException(code: 'TagLostException'));

      await expectLater(
        verifyWrittenLink(lost, link),
        throwsA(isA<PlatformException>()),
      );
    });
  });

  group('NfcManagerService sessions', () {
    late _FakeManager manager;
    late NfcManagerService service;
    late List<bool> dispatch;
    final link = TagLink.build(TagToken.generate());

    setUp(() {
      manager = _FakeManager();
      dispatch = [];
      service = NfcManagerService(
        manager: manager,
        setTagDispatch: ({required enabled}) async => dispatch.add(enabled),
      );
    });

    test('maps availability', () async {
      expect(await service.availability(), NfcAvailability.available);
      manager.availability = nm.NfcAvailability.disabled;
      expect(await service.availability(), NfcAvailability.disabled);
      manager.availability = nm.NfcAvailability.unsupported;
      expect(await service.availability(), NfcAvailability.unsupported);
    });

    test('does not open a session or touch dispatch when NFC is off', () async {
      manager.availability = nm.NfcAvailability.disabled;

      final result = await service.readTag();

      expect(manager.starts, 0);
      expect(dispatch, isEmpty);
      expect(
        (result as Failure<TagContent, NfcFailure>).failure,
        isA<NfcUnavailable>(),
      );
    });

    test('switches the app tag filter off before the session opens', () async {
      unawaited(service.writeLink(link));
      await pumpEventQueue();

      expect(dispatch, [false]);
      expect(manager.starts, 1);
    });

    test('cancel completes a pending write with NfcCancelled, stops the '
        'session and hands the tag filter back', () async {
      final pending = service.writeLink(link);
      await pumpEventQueue();
      await service.cancel();

      final result = await pending;

      expect(
        (result as Failure<void, NfcFailure>).failure,
        isA<NfcCancelled>(),
      );
      expect(manager.stops, 1);
      expect(dispatch, [false, true]);
    });

    test('a session start error becomes a typed failure and restores the '
        'tag filter', () async {
      manager.startError = PlatformException(code: 'not_supported');

      final result = await service.readTag();

      expect(
        (result as Failure<TagContent, NfcFailure>).failure,
        isA<NfcUnavailable>(),
      );
      expect(dispatch, [false, true]);
    });

    test('the session stays open after an operation, so a phone still on '
        'the sticker is not handed to the system', () async {
      final first = service.writeLink(link);
      await pumpEventQueue();
      manager.discover();
      expect((await first).isFailure, isTrue); // fake tag is not NDEF

      expect(manager.stops, 0);
      expect(dispatch, [false]);

      // The sticker is re-detected while nothing is pending: ignored.
      manager.discover();
      await pumpEventQueue();

      // The next operation reuses the open session.
      final second = service.readTag();
      await pumpEventQueue();
      expect(manager.starts, 1);
      manager.discover();
      expect((await second).isFailure, isTrue);

      await service.cancel();
      expect(manager.stops, 1);
      expect(dispatch, [false, true]);
    });

    test('a new operation cancels the pending one', () async {
      final first = service.readTag();
      await pumpEventQueue();
      final second = service.writeLink(link);
      await pumpEventQueue();

      expect(
        (await first as Failure<TagContent, NfcFailure>).failure,
        isA<NfcCancelled>(),
      );
      manager.discover();
      expect((await second).isFailure, isTrue);
      expect(manager.starts, 1);
    });

    test('cancel without a session does nothing', () async {
      await service.cancel();

      expect(manager.stops, 0);
      expect(dispatch, isEmpty);
    });
  });

  test('platformSetTagDispatch tolerates a missing native side', () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    await expectLater(platformSetTagDispatch(enabled: true), completes);
  });
}
