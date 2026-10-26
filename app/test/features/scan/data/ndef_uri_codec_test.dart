import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:ndef_record/ndef_record.dart';
import 'package:plantnfc/features/scan/data/ndef_uri_codec.dart';
import 'package:plantnfc/features/scan/domain/tag_link.dart';
import 'package:plantnfc/features/scan/domain/tag_token.dart';

NdefRecord _uriRecord(List<int> payload) => NdefRecord(
  typeNameFormat: TypeNameFormat.wellKnown,
  type: Uint8List.fromList([0x55]),
  identifier: Uint8List(0),
  payload: Uint8List.fromList(payload),
);

void main() {
  final link = TagLink.build(TagToken.generate());

  test('encodes our link as one well-known URI record with https:// prefix '
      'code', () {
    final message = NdefUriCodec.messageFor(link);
    final record = message.records.single;

    expect(record.typeNameFormat, TypeNameFormat.wellKnown);
    expect(record.type, [0x55]);
    expect(record.payload.first, 0x04);
    expect(
      utf8.decode(record.payload.sublist(1)),
      link.toString().substring('https://'.length),
    );
  });

  test('round-trips through bytes', () {
    final bytes = NdefUriCodec.messageFor(link).encode();
    final decoded = NdefMessage.decode(bytes).records.single;

    expect(NdefUriCodec.decode(decoded), link.toString());
  });

  test('fits an NTAG213 (137 bytes of NDEF space) with room to spare', () {
    expect(NdefUriCodec.messageFor(link).byteLength, lessThan(64));
  });

  test('picks the longest prefix', () {
    final record = NdefUriCodec.recordFor(Uri.parse('https://www.example.com'));

    expect(record.payload.first, 0x02);
    expect(NdefUriCodec.decode(record), 'https://www.example.com');
  });

  test('uses no prefix for unknown schemes', () {
    final record = NdefUriCodec.recordFor(Uri.parse('geo:52.2,21.0'));

    expect(record.payload.first, 0x00);
    expect(NdefUriCodec.decode(record), 'geo:52.2,21.0');
  });

  test('decodes absolute-URI records', () {
    final record = NdefRecord(
      typeNameFormat: TypeNameFormat.absoluteUri,
      type: Uint8List.fromList(utf8.encode('https://a.example/x')),
      identifier: Uint8List(0),
      payload: Uint8List(0),
    );

    expect(NdefUriCodec.decode(record), 'https://a.example/x');
  });

  group('decode returns null for', () {
    test('an empty payload', () {
      expect(NdefUriCodec.decode(_uriRecord([])), isNull);
    });

    test('an unknown prefix code', () {
      expect(NdefUriCodec.decode(_uriRecord([0x7f, 0x61])), isNull);
    });

    test('invalid UTF-8', () {
      expect(NdefUriCodec.decode(_uriRecord([0x04, 0xff, 0xfe])), isNull);
    });

    test('a text record', () {
      final record = NdefRecord(
        typeNameFormat: TypeNameFormat.wellKnown,
        type: Uint8List.fromList([0x54]), // "T"
        identifier: Uint8List(0),
        payload: Uint8List.fromList([0x02, 0x65, 0x6e, 0x68, 0x69]),
      );

      expect(NdefUriCodec.decode(record), isNull);
    });

    test('an absolute-URI record with invalid UTF-8', () {
      final record = NdefRecord(
        typeNameFormat: TypeNameFormat.absoluteUri,
        type: Uint8List.fromList([0xff]),
        identifier: Uint8List(0),
        payload: Uint8List(0),
      );

      expect(NdefUriCodec.decode(record), isNull);
    });
  });
}
