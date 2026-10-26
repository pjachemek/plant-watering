import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:plantnfc/features/scan/domain/tag_token.dart';

/// Returns the same byte every time, to hit the encoding edge cases.
class _ConstantRandom implements Random {
  new(this.byte);

  final int byte;

  @override
  int nextInt(int max) => byte;

  @override
  bool nextBool() => false;

  @override
  double nextDouble() => 0;
}

void main() {
  test('generates 22 base62 characters', () {
    final token = TagToken.generate();

    expect(token.value, matches(RegExp(r'^[0-9A-Za-z]{22}$')));
  });

  test('all-zero bits pad to 22 zeros', () {
    expect(TagToken.generate(_ConstantRandom(0)).value, '0' * 22);
  });

  test('all-one bits (2^128 - 1) still fit in 22 characters', () {
    // 2^128 - 1 in base62.
    expect(
      TagToken.generate(_ConstantRandom(255)).value,
      '7n42DGM5Tflk9n8mt7Fhc7',
    );
  });

  test('is unique across many draws', () {
    final tokens = {for (var i = 0; i < 10000; i++) TagToken.generate().value};

    expect(tokens, hasLength(10000));
  });

  test('tryParse accepts the exact format only', () {
    expect(TagToken.tryParse('AbCdEfGhIjKlMnOpQrStUv')?.value, isNotNull);
    expect(TagToken.tryParse('AbCdEfGhIjKlMnOpQrStU'), isNull); // 21
    expect(TagToken.tryParse('AbCdEfGhIjKlMnOpQrStUvW'), isNull); // 23
    expect(TagToken.tryParse('AbCdEfGhIjKlMnOpQrSt-v'), isNull);
    expect(TagToken.tryParse(''), isNull);
  });

  test('value equality', () {
    expect(
      TagToken.tryParse('AbCdEfGhIjKlMnOpQrStUv'),
      TagToken.tryParse('AbCdEfGhIjKlMnOpQrStUv'),
    );
    expect(
      TagToken.tryParse('AbCdEfGhIjKlMnOpQrStUv').hashCode,
      TagToken.tryParse('AbCdEfGhIjKlMnOpQrStUv').hashCode,
    );
  });

  test('toString never reveals the token', () {
    final token = TagToken.generate();

    expect(token.toString(), isNot(contains(token.value)));
  });
}
