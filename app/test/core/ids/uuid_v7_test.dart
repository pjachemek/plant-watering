import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:plantnfc/core/ids/uuid_v7.dart';

void main() {
  test('is a version 7, RFC 9562 variant UUID', () {
    expect(
      uuidV7(),
      matches(
        RegExp(
          '^[0-9a-f]{8}-[0-9a-f]{4}-7[0-9a-f]{3}-'
          r'[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
        ),
      ),
    );
  });

  test('starts with the time in milliseconds, so ids sort by time', () {
    final at = DateTime.utc(2026, 10, 29, 12);
    final id = uuidV7(now: at);

    expect(
      int.parse(id.replaceAll('-', '').substring(0, 12), radix: 16),
      at.millisecondsSinceEpoch,
    );
    final later = uuidV7(now: at.add(const Duration(milliseconds: 1)));
    expect(id.compareTo(later), lessThan(0));
  });

  test('is random after the time', () {
    final at = DateTime.utc(2026);
    final ids = {for (var i = 0; i < 2000; i++) uuidV7(now: at)};

    expect(ids, hasLength(2000));
    expect(
      uuidV7(now: at, random: Random(1)),
      uuidV7(now: at, random: Random(1)),
    );
  });
}
