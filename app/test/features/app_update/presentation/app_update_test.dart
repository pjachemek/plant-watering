import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantnfc/features/app_update/domain/version_policy.dart';
import 'package:plantnfc/features/app_update/presentation/app_update_controller.dart';

import '../../../helpers/fake_auth_repository.dart';
import '../../../helpers/fake_version_policy_source.dart';
import '../../../helpers/pump_app.dart';

/// Background and back, through every state Android passes on the way.
void resume(WidgetTester tester) {
  [
    AppLifecycleState.inactive,
    AppLifecycleState.hidden,
    AppLifecycleState.paused,
    AppLifecycleState.hidden,
    AppLifecycleState.inactive,
    AppLifecycleState.resumed,
  ].forEach(tester.binding.handleAppLifecycleStateChanged);
}

void main() {
  late FakeVersionPolicySource policy;
  late List<String> storeOpens;
  var storeOpensOk = true;

  setUp(() {
    policy = FakeVersionPolicySource();
    storeOpens = [];
    storeOpensOk = true;
  });

  Future<void> pump(
    WidgetTester tester, {
    bool signedIn = true,
    double textScale = 1,
    Size size = const Size(390, 844),
    Brightness brightness = Brightness.light,
  }) async {
    await pumpApp(
      tester,
      auth: FakeAuthRepository(signedIn: signedIn),
      versionPolicy: policy,
      textScale: textScale,
      size: size,
      brightness: brightness,
      overrides: [
        openStoreProvider.overrideWithValue(() async {
          storeOpens.add('play');
          return storeOpensOk;
        }),
      ],
    );
  }

  group('below the minimum version', () {
    setUp(() {
      policy.policy = const VersionPolicy(
        minVersion: '99.0.0',
        recommendedVersion: '99.0.0',
      );
    });

    testWidgets('blocks the app, even before sign-in', (tester) async {
      await pump(tester, signedIn: false);

      expect(find.text('Update Plant NFC'), findsOneWidget);
      expect(find.text('Sign in to Plant NFC'), findsNothing);
    });

    testWidgets('opens the store listing', (tester) async {
      await pump(tester);

      await tester.tap(find.text('Open Google Play'));
      await tester.pumpAndSettle();

      expect(storeOpens, ['play']);
    });

    testWidgets('says so when the store cannot be opened', (tester) async {
      storeOpensOk = false;
      await pump(tester);

      await tester.tap(find.text('Open Google Play'));
      await tester.pumpAndSettle();

      expect(find.textContaining("Couldn't open Google Play"), findsOneWidget);
    });

    testWidgets('lets the app back in once the minimum is lowered', (
      tester,
    ) async {
      await pump(tester);
      policy.policy = const VersionPolicy(
        minVersion: '0.0.1',
        recommendedVersion: '0.0.1',
      );

      resume(tester);
      await tester.pumpAndSettle();

      expect(find.text('Plants'), findsOneWidget);
    });

    for (final brightness in Brightness.values) {
      testWidgets('meets accessibility guidelines (${brightness.name})', (
        tester,
      ) async {
        final handle = tester.ensureSemantics();
        await pump(tester, brightness: brightness);

        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        await expectLater(tester, meetsGuideline(textContrastGuideline));
        handle.dispose();
      });
    }

    testWidgets('is usable at 200% text on a small phone', (tester) async {
      await pump(tester, textScale: 2, size: const Size(320, 568));

      expect(tester.takeException(), isNull);
      await tester.scrollUntilVisible(find.text('Open Google Play'), 50);
      expect(find.text('Open Google Play'), findsOneWidget);
    });
  });

  testWidgets('a 426 from the API switches to the update screen', (
    tester,
  ) async {
    final container = await pumpApp(
      tester,
      auth: FakeAuthRepository(),
      versionPolicy: policy,
    );
    expect(find.text('Plants'), findsOneWidget);

    container.read(appUpdateControllerProvider.notifier).upgradeRequired();
    await tester.pumpAndSettle();

    expect(find.text('Update Plant NFC'), findsOneWidget);
  });

  group('below the recommended version', () {
    setUp(() {
      policy.policy = const VersionPolicy(
        minVersion: '0.0.1',
        recommendedVersion: '99.0.0',
      );
    });

    testWidgets('shows a prompt that opens the store or goes away', (
      tester,
    ) async {
      await pump(tester);

      expect(find.text('Plants'), findsOneWidget);
      expect(
        find.text('A new version of Plant NFC is available.'),
        findsOneWidget,
      );

      await tester.tap(find.text('Update'));
      await tester.pumpAndSettle();
      expect(storeOpens, ['play']);

      await tester.tap(find.text('Dismiss'));
      await tester.pumpAndSettle();
      expect(
        find.text('A new version of Plant NFC is available.'),
        findsNothing,
      );
    });

    testWidgets('fits at 200% text on a small phone', (tester) async {
      await pump(tester, textScale: 2, size: const Size(320, 568));

      expect(tester.takeException(), isNull);
      expect(find.text('Update'), findsOneWidget);
      expect(find.text('Dismiss'), findsOneWidget);
    });

    testWidgets('stays dismissed when checked again on resume', (tester) async {
      await pump(tester);
      await tester.tap(find.text('Dismiss'));
      await tester.pumpAndSettle();

      resume(tester);
      await tester.pumpAndSettle();

      expect(policy.fetches, 2);
      expect(
        find.text('A new version of Plant NFC is available.'),
        findsNothing,
      );
    });
  });

  testWidgets('offline, nothing changes', (tester) async {
    policy.policy = null;
    await pump(tester);

    expect(find.text('Plants'), findsOneWidget);
    expect(find.text('Update Plant NFC'), findsNothing);
  });
}
