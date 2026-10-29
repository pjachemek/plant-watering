import 'package:flutter_test/flutter_test.dart';
import 'package:plantnfc/features/auth/domain/auth_status.dart';

void main() {
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
