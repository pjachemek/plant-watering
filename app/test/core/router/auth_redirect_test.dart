import 'package:flutter_test/flutter_test.dart';
import 'package:plantnfc/core/router/app_router.dart';

void main() {
  String? redirect(String location, {required bool signedIn}) =>
      authRedirect(signedIn: signedIn, location: Uri.parse(location));

  group('signed out', () {
    test('sends the home screen to sign-in', () {
      expect(redirect('/', signedIn: false), '/sign-in');
    });

    test('remembers where a deep link was going', () {
      expect(
        redirect('/p/AbCdEfGhIjKlMnOpQrStUv', signedIn: false),
        '/sign-in?from=%2Fp%2FAbCdEfGhIjKlMnOpQrStUv',
      );
    });

    test('remembers an app link that arrives as a full URL by its path', () {
      expect(
        redirect(
          'https://plants.pampait.pl/p/AbCdEfGhIjKlMnOpQrStUv',
          signedIn: false,
        ),
        '/sign-in?from=%2Fp%2FAbCdEfGhIjKlMnOpQrStUv',
      );
    });

    test('leaves the sign-in screen alone', () {
      expect(redirect('/sign-in', signedIn: false), isNull);
    });
  });

  group('signed in', () {
    test('leaves app screens alone, so a tag opens straight away', () {
      expect(redirect('/', signedIn: true), isNull);
      expect(redirect('/p/AbCdEfGhIjKlMnOpQrStUv', signedIn: true), isNull);
    });

    test('moves on from sign-in to where it was going', () {
      expect(
        redirect('/sign-in?from=%2Fp%2FAbCdEfGhIjKlMnOpQrStUv', signedIn: true),
        '/p/AbCdEfGhIjKlMnOpQrStUv',
      );
      expect(redirect('/sign-in', signedIn: true), '/');
    });

    test('never follows a destination outside the app', () {
      expect(redirect('/sign-in?from=https://evil.test', signedIn: true), '/');
      expect(redirect('/sign-in?from=//evil.test', signedIn: true), '/');
    });
  });
}
