import 'package:flutter_test/flutter_test.dart';
import 'package:plantnfc/core/result/result.dart';
import 'package:plantnfc/features/auth/domain/auth_status.dart';

import '../../../helpers/fake_auth_repository.dart';
import '../../../helpers/pump_app.dart';

void main() {
  late FakeAuthRepository auth;

  setUp(() => auth = FakeAuthRepository(signedIn: false));

  testWidgets('signs in with the code from the link, then shows plants', (
    tester,
  ) async {
    await pumpApp(tester, auth: auth, location: '/auth/callback?code=abc');

    expect(auth.codesUsed, ['abc']);
    expect(find.text('Plants'), findsOneWidget);
  });

  testWidgets('explains an unusable link and leads back to sign-in', (
    tester,
  ) async {
    auth.linkResult = const Failure(AuthFailure.linkInvalid);
    await pumpApp(tester, auth: auth, location: '/auth/callback?code=old');

    expect(find.text("Couldn't sign you in"), findsOneWidget);
    expect(find.textContaining('Ask for a new one'), findsOneWidget);

    await tester.tap(find.text('Back to sign-in'));
    await tester.pumpAndSettle();
    expect(find.text('Sign in to Plant NFC'), findsOneWidget);
  });

  testWidgets('treats a link without a code (an error link) as unusable', (
    tester,
  ) async {
    await pumpApp(
      tester,
      auth: auth,
      location: '/auth/callback?error=access_denied&error_code=otp_expired',
    );

    expect(auth.codesUsed, isEmpty);
    expect(find.text("Couldn't sign you in"), findsOneWidget);
  });

  testWidgets('ignores a link opened while already signed in', (tester) async {
    final signedIn = FakeAuthRepository();
    await pumpApp(tester, auth: signedIn, location: '/auth/callback?code=x');

    expect(signedIn.codesUsed, isEmpty);
    expect(find.text('Plants'), findsOneWidget);
  });
}
