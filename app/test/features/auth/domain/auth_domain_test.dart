import 'package:flutter_test/flutter_test.dart';
import 'package:plantnfc/features/auth/domain/auth_status.dart';
import 'package:plantnfc/features/auth/domain/email_address.dart';

void main() {
  group('normalizeEmail', () {
    test('trims and lower-cases a plausible address', () {
      expect(normalizeEmail('  Ann.Lee@Example.COM '), 'ann.lee@example.com');
      expect(normalizeEmail('a+plants@mail.co.uk'), 'a+plants@mail.co.uk');
    });

    test('refuses what cannot be an address', () {
      for (final input in [
        '',
        'ann',
        'ann@',
        '@example.com',
        'ann@example',
        'ann@@example.com',
        'ann lee@example.com',
        'ann@example..com',
        '${'a' * 250}@example.com',
      ]) {
        expect(normalizeEmail(input), isNull, reason: input);
      }
    });
  });

  group('AuthStatus', () {
    test('compares by value', () {
      expect(const SignedIn('a'), const SignedIn('a'));
      expect(const SignedIn('a').hashCode, const SignedIn('a').hashCode);
      expect(const SignedIn('a'), isNot(const SignedIn('b')));
      expect(const SignedOut(), const SignedOut());
      expect(const SignedOut().hashCode, const SignedOut().hashCode);
      expect(const SignedOut(), isNot(const SignedIn('a')));
    });

    test('never prints the account id', () {
      expect(const SignedIn('secret-id').toString(), isNot(contains('secret')));
      expect(const SignedOut().toString(), 'SignedOut()');
    });
  });
}
