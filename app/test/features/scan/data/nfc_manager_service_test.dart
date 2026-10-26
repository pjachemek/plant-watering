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

  group('NfcManagerService sessions', () {
    late _FakeManager manager;
    late NfcManagerService service;
    final link = TagLink.build(TagToken.generate());

    setUp(() {
      manager = _FakeManager();
      service = NfcManagerService(manager: manager);
    });

    test('maps availability', () async {
      expect(await service.availability(), NfcAvailability.available);
      manager.availability = nm.NfcAvailability.disabled;
      expect(await service.availability(), NfcAvailability.disabled);
      manager.availability = nm.NfcAvailability.unsupported;
      expect(await service.availability(), NfcAvailability.unsupported);
    });

    test('does not open a session when NFC is off', () async {
      manager.availability = nm.NfcAvailability.disabled;

      final result = await service.readTag();

      expect(manager.starts, 0);
      expect(
        (result as Failure<TagContent, NfcFailure>).failure,
        isA<NfcUnavailable>(),
      );
    });

    test('cancel completes a pending write with NfcCancelled and stops '
        'the session', () async {
      final pending = service.writeLink(link);
      await pumpEventQueue();
      await service.cancel();

      final result = await pending;

      expect(
        (result as Failure<void, NfcFailure>).failure,
        isA<NfcCancelled>(),
      );
      expect(manager.stops, greaterThan(0));
    });

    test('a session start error becomes a typed failure', () async {
      manager.startError = PlatformException(code: 'not_supported');

      final result = await service.readTag();

      expect(
        (result as Failure<TagContent, NfcFailure>).failure,
        isA<NfcUnavailable>(),
      );
    });

    test('a tag the platform cannot read as NDEF fails and ends the '
        'session', () async {
      final pending = service.writeLink(link);
      await pumpEventQueue();
      manager.discover();

      final result = await pending;

      expect(result.isFailure, isTrue);
      expect(manager.stops, greaterThan(0));
    });
  });
}
