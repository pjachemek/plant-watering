import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantnfc/app.dart';
import 'package:plantnfc/core/config/config_provider.dart';
import 'package:plantnfc/core/result/result.dart';
import 'package:plantnfc/core/router/app_router.dart';
import 'package:plantnfc/features/auth/data/auth_providers.dart';
import 'package:plantnfc/features/auth/domain/auth_status.dart';

import '../../../helpers/fake_auth_repository.dart';
import '../../../helpers/pump_app.dart';

void main() {
  late FakeAuthRepository auth;

  setUp(() => auth = FakeAuthRepository(signedIn: false));

  group('signed out', () {
    testWidgets('opens on sign-in instead of the plant list', (tester) async {
      await pumpApp(tester, auth: auth);

      expect(find.text('Sign in to Plant NFC'), findsOneWidget);
      expect(find.text('Continue with Google'), findsOneWidget);
      expect(find.text('Email me a sign-in link'), findsOneWidget);
      expect(find.text('Plants'), findsNothing);
    });

    testWidgets('goes to the plant list after signing in with Google', (
      tester,
    ) async {
      await pumpApp(tester, auth: auth);

      await tester.tap(find.text('Continue with Google'));
      await tester.pumpAndSettle();

      expect(find.text('Plants'), findsOneWidget);
    });

    testWidgets('a tag scanned while signed out opens after sign-in', (
      tester,
    ) async {
      await pumpApp(
        tester,
        auth: auth,
        location: AppRoutes.tagPath('AbCdEfGhIjKlMnOpQrStUv'),
      );
      expect(find.text('Sign in to Plant NFC'), findsOneWidget);

      await tester.tap(find.text('Continue with Google'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('This tag link opened the app'),
        findsOneWidget,
      );
    });

    testWidgets(
      'a tag that cold-starts the app signed out opens after sign-in',
      (tester) async {
        // Android hands an app link to Flutter as the full URL (seen on a
        // Pixel: after sign-in the plant list opened instead of the tag).
        tester.binding.platformDispatcher.defaultRouteNameTestValue =
            'https://plants.pampait.pl/p/AbCdEfGhIjKlMnOpQrStUv';
        addTearDown(
          tester.binding.platformDispatcher.clearDefaultRouteNameTestValue,
        );
        final container = ProviderContainer(
          overrides: [
            authRepositoryProvider.overrideWithValue(auth),
            appConfigProvider.overrideWithValue(testConfig),
          ],
        );
        addTearDown(container.dispose);
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const PlantApp(),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Sign in to Plant NFC'), findsOneWidget);

        await tester.tap(find.text('Continue with Google'));
        await tester.pumpAndSettle();

        expect(
          find.textContaining('This tag link opened the app'),
          findsOneWidget,
        );
      },
    );

    testWidgets('shows progress and disables both ways while signing in', (
      tester,
    ) async {
      auth.hold = Completer<void>();
      await pumpApp(tester, auth: auth);

      await tester.tap(find.text('Continue with Google'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      final email = tester.widget<TextField>(find.byType(TextField));
      expect(email.enabled, isFalse);

      auth.hold!.complete();
      await tester.pumpAndSettle();
    });

    testWidgets('says nothing when the account picker is closed', (
      tester,
    ) async {
      auth.googleResult = const Failure(AuthFailure.cancelled);
      await pumpApp(tester, auth: auth);

      await tester.tap(find.text('Continue with Google'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.error_outline), findsNothing);
      expect(find.text('Sign in to Plant NFC'), findsOneWidget);
    });

    testWidgets('explains a failure with an icon and text', (tester) async {
      auth.googleResult = const Failure(AuthFailure.network);
      await pumpApp(tester, auth: auth);

      await tester.tap(find.text('Continue with Google'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.textContaining("Can't reach the server"), findsOneWidget);
    });

    testWidgets('sends an email link and says where it went', (tester) async {
      await pumpApp(tester, auth: auth);

      await tester.enterText(find.byType(TextField), 'ann@example.com');
      await tester.tap(find.text('Email me a sign-in link'));
      await tester.pumpAndSettle();

      expect(auth.emailsSent, ['ann@example.com']);
      expect(find.text('Check your email'), findsOneWidget);
      expect(find.textContaining('ann@example.com'), findsOneWidget);

      await tester.tap(find.text('Use a different email'));
      await tester.pumpAndSettle();
      expect(find.text('Email me a sign-in link'), findsOneWidget);
    });

    testWidgets('reports an address that cannot be used', (tester) async {
      auth.emailResult = const Failure(AuthFailure.invalidEmail);
      await pumpApp(tester, auth: auth);

      await tester.enterText(find.byType(TextField), 'ann');
      await tester.testTextInput.receiveAction(TextInputAction.send);
      await tester.pumpAndSettle();

      expect(find.text('Enter a valid email address.'), findsOneWidget);
    });

    testWidgets('hides Google sign-in when the build has no client id', (
      tester,
    ) async {
      await pumpApp(tester, auth: auth, config: testConfigWithoutGoogle);

      expect(find.text('Continue with Google'), findsNothing);
      expect(find.text('Email me a sign-in link'), findsOneWidget);
    });

    for (final brightness in Brightness.values) {
      testWidgets('meets accessibility guidelines (${brightness.name})', (
        tester,
      ) async {
        final handle = tester.ensureSemantics();
        await pumpApp(tester, auth: auth, brightness: brightness);

        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        await expectLater(tester, meetsGuideline(textContrastGuideline));
        handle.dispose();
      });
    }

    testWidgets('is usable at 200% text size on a small phone', (tester) async {
      await pumpApp(
        tester,
        auth: auth,
        textScale: 2,
        size: const Size(320, 568),
      );

      expect(tester.takeException(), isNull);
      await tester.scrollUntilVisible(
        find.text('Email me a sign-in link'),
        50,
        // The page, not the email field's own scrollable.
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Email me a sign-in link'), findsOneWidget);
    });
  });

  group('signed in', () {
    testWidgets('signing out returns to sign-in', (tester) async {
      final signedIn = FakeAuthRepository();
      await pumpApp(tester, auth: signedIn);

      await tester.tap(find.byTooltip('Sign out'));
      await tester.pumpAndSettle();

      expect(signedIn.signOuts, 1);
      expect(find.text('Sign in to Plant NFC'), findsOneWidget);
    });

    testWidgets('a tag opens straight away, without sign-in', (tester) async {
      await pumpApp(
        tester,
        auth: FakeAuthRepository(),
        location: AppRoutes.tagPath('AbCdEfGhIjKlMnOpQrStUv'),
      );

      expect(
        find.textContaining('This tag link opened the app'),
        findsOneWidget,
      );
    });
  });
}
