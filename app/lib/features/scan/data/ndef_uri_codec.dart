import 'dart:convert';
import 'dart:typed_data';

import 'package:ndef_record/ndef_record.dart';

/// Encodes and decodes NFC Forum URI records (RTD-URI 1.0): type "U",
/// payload = one prefix byte + the rest of the URI in UTF-8.
abstract final class NdefUriCodec {
  /// Prefix codes from the RTD-URI spec, indexed by code.
  static const List<String> _prefixes = [
    '', 'http://www.', 'https://www.', 'http://', 'https://', 'tel:', //
    'mailto:', 'ftp://anonymous:anonymous@', 'ftp://ftp.', 'ftps://',
    'sftp://', 'smb://', 'nfs://', 'ftp://', 'dav://', 'news:',
    'telnet://', 'imap:', 'rtsp://', 'urn:', 'pop:', 'sip:', 'sips:',
    'tftp:', 'btspp://', 'btl2cap://', 'btgoep://', 'tcpobex://',
    'irdaobex://', 'file://', 'urn:epc:id:', 'urn:epc:tag:',
    'urn:epc:pat:', 'urn:epc:raw:', 'urn:epc:', 'urn:nfc:',
  ];

  static final Uint8List _typeU = Uint8List.fromList([0x55]); // "U"

  /// A message with exactly one URI record, as the tag format requires
  /// (AGENTS.md section 7). No Android Application Record is added.
  static NdefMessage messageFor(Uri uri) =>
      NdefMessage(records: [recordFor(uri)]);

  static NdefRecord recordFor(Uri uri) {
    final text = uri.toString();
    // Pick the longest matching prefix to save bytes on small tags.
    var code = 0;
    for (var i = 1; i < _prefixes.length; i++) {
      final p = _prefixes[i];
      if (text.startsWith(p) && p.length > _prefixes[code].length) code = i;
    }
    final rest = utf8.encode(text.substring(_prefixes[code].length));
    return NdefRecord(
      typeNameFormat: TypeNameFormat.wellKnown,
      type: _typeU,
      identifier: Uint8List(0),
      payload: Uint8List.fromList([code, ...rest]),
    );
  }

  /// The URI in [record], or `null` if it isn't a URI record.
  static String? decode(NdefRecord record) {
    if (record.typeNameFormat == TypeNameFormat.absoluteUri) {
      return _utf8OrNull(record.type);
    }
    final isUriRecord =
        record.typeNameFormat == TypeNameFormat.wellKnown &&
        record.type.length == 1 &&
        record.type[0] == _typeU[0];
    final payload = record.payload;
    if (!isUriRecord || payload.isEmpty || payload[0] >= _prefixes.length) {
      return null;
    }
    final rest = _utf8OrNull(payload.sublist(1));
    return rest == null ? null : _prefixes[payload[0]] + rest;
  }

  static String? _utf8OrNull(List<int> bytes) {
    try {
      return utf8.decode(bytes);
    } on FormatException {
      return null;
    }
  }
}
