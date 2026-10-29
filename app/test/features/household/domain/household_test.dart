import 'package:flutter_test/flutter_test.dart';
import 'package:plantnfc/features/household/domain/household.dart';

void main() {
  group('parseInviteCode', () {
    test('accepts the code, trimmed, keeping its case', () {
      expect(parseInviteCode(' Ab3dEf6hIj9k '), 'Ab3dEf6hIj9k');
    });

    test('accepts an invite link', () {
      expect(
        parseInviteCode('https://plants.pampait.pl/i/Ab3dEf6hIj9k'),
        'Ab3dEf6hIj9k',
      );
    });

    test('refuses anything else', () {
      for (final input in [
        '',
        'Ab3dEf6hIj9',
        'Ab3dEf6hIj9kX',
        'Ab3dEf6hIj9-',
        'https://evil.test/i/Ab3dEf6hIj9k',
        'https://plants.pampait.pl/p/Ab3dEf6hIj9k',
        'https://plants.pampait.pl/i/Ab3dEf6hIj9k/x',
      ]) {
        expect(parseInviteCode(input), isNull, reason: input);
      }
    });
  });

  test('cleanName trims and enforces the length', () {
    expect(cleanName('  Our home ', max: 80), 'Our home');
    expect(cleanName('   ', max: 80), isNull);
    expect(cleanName('x' * 61, max: 60), isNull);
    expect(cleanName('x' * 60, max: 60), 'x' * 60);
  });
}
