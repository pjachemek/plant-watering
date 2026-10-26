import 'dart:math';

import 'package:meta/meta.dart';

/// The secret in a tag URL: 128 bits from a secure random source, base62
/// encoded to a fixed 22 characters (AGENTS.md section 7). It is not the plant
/// ID, so a tag can be re-assigned and IDs are never exposed.
@immutable
final class TagToken {
  const new _(this.value);

  /// Generates a new token. [random] must be cryptographically secure in
  /// production; tests may pass a seeded generator.
  factory generate([Random? random]) {
    final rng = random ?? Random.secure();
    var n = BigInt.zero;
    for (var i = 0; i < byteLength; i++) {
      n = (n << 8) | BigInt.from(rng.nextInt(256));
    }
    return TagToken._(_encode(n));
  }

  /// Returns a token if [value] has the exact token format, otherwise `null`.
  static TagToken? tryParse(String value) =>
      _format.hasMatch(value) ? TagToken._(value) : null;

  static const int byteLength = 16;

  /// 62^22 > 2^128 > 62^21, so 22 characters always fit 128 bits.
  static const int length = 22;

  static const String _alphabet =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
  static final RegExp _format = RegExp('^[0-9A-Za-z]{$length}\$');
  static final BigInt _base = BigInt.from(62);

  final String value;

  static String _encode(BigInt n) {
    final chars = List.filled(length, _alphabet[0]);
    var rest = n;
    for (var i = length - 1; i >= 0 && rest > BigInt.zero; i--) {
      chars[i] = _alphabet[(rest % _base).toInt()];
      rest ~/= _base;
    }
    return chars.join();
  }

  @override
  bool operator ==(Object other) => other is TagToken && other.value == value;

  @override
  int get hashCode => value.hashCode;

  /// Redacted so tokens never end up in logs or crash reports.
  @override
  String toString() => 'TagToken(***)';
}
