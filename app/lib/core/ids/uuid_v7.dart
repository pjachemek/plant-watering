import 'dart:math';

/// A UUID v7 (RFC 9562): 48-bit Unix milliseconds, then random bits, so ids
/// sort by creation time (AGENTS.md sections 5 and 8). Same format as the
/// Worker's `uuidv7` in functions/src/lib/ids.ts.
String uuidV7({DateTime? now, Random? random}) {
  final source = random ?? Random.secure();
  final millis = (now ?? DateTime.now()).millisecondsSinceEpoch;
  final bytes = List<int>.generate(16, (_) => source.nextInt(256));
  var time = millis;
  for (var i = 5; i >= 0; i--) {
    bytes[i] = time & 0xff;
    time >>= 8;
  }
  bytes[6] = (bytes[6] & 0x0f) | 0x70; // version 7
  bytes[8] = (bytes[8] & 0x3f) | 0x80; // variant 10
  final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
      '${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
}
