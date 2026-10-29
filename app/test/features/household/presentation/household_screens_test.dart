import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantnfc/core/result/result.dart';
import 'package:plantnfc/features/household/domain/household.dart';

import '../../../helpers/fake_household_repository.dart';
import '../../../helpers/pump_app.dart';

void main() {
  late FakeHouseholdRepository households;

  setUp(() => households = FakeHouseholdRepository());

  group('without a household', () {
    setUp(() => households = FakeHouseholdRepository(current: null));

    testWidgets('the home screen offers to create or join one', (tester) async {
      await pumpApp(tester, households: households);

      expect(find.text('Set up your household'), findsOneWidget);
      expect(find.text('Create a household'), findsOneWidget);
      expect(find.text('Join with a code'), findsOneWidget);
      expect(find.byTooltip('Household'), findsNothing);
    });

    testWidgets('creating one checks the names, then returns home', (
      tester,
    ) async {
      await pumpApp(tester, households: households);
      await tester.tap(find.text('Create a household'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();
      expect(find.text('Enter a name (up to 80 characters)'), findsOneWidget);
      expect(households.created, isEmpty);

      await tester.enterText(find.byType(TextField).at(0), ' Our home ');
      await tester.enterText(find.byType(TextField).at(1), 'Ann');
      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      expect(households.created.single, (name: 'Our home', displayName: 'Ann'));
      expect(find.text('No plants yet'), findsOneWidget);
      expect(find.byTooltip('Household'), findsOneWidget);
    });

    testWidgets('joining explains an invalid code', (tester) async {
      households.joinResult = const Failure(HouseholdFailure.invalidCode);
      await pumpApp(tester, households: households);
      await tester.tap(find.text('Join with a code'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).at(0), 'Ab3dEf6hIj9k');
      await tester.enterText(find.byType(TextField).at(1), 'Bob');
      await tester.tap(find.text('Join'));
      await tester.pumpAndSettle();

      expect(find.textContaining("isn't valid"), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('an invite link opens the join screen with the code', (
      tester,
    ) async {
      await pumpApp(
        tester,
        households: households,
        location: '/i/Ab3dEf6hIj9k',
      );

      expect(find.text('Join a household'), findsOneWidget);
      expect(find.text('Ab3dEf6hIj9k'), findsOneWidget);

      await tester.enterText(find.byType(TextField).at(1), 'Bob');
      await tester.tap(find.text('Join'));
      await tester.pumpAndSettle();

      expect(households.joined.single.code, 'Ab3dEf6hIj9k');
      expect(find.text('No plants yet'), findsOneWidget);
    });

    testWidgets('the join form takes a pasted link and checks the code', (
      tester,
    ) async {
      await pumpApp(
        tester,
        households: households,
        location: '/household/join',
      );

      await tester.enterText(find.byType(TextField).at(0), 'not a code');
      await tester.enterText(find.byType(TextField).at(1), 'Bob');
      await tester.tap(find.text('Join'));
      await tester.pumpAndSettle();
      expect(
        find.text('Enter the 12-character code or the invite link'),
        findsOneWidget,
      );

      await tester.enterText(
        find.byType(TextField).at(0),
        'https://plants.pampait.pl/i/Ab3dEf6hIj9k',
      );
      await tester.tap(find.text('Join'));
      await tester.pumpAndSettle();
      expect(households.joined.single.code, 'Ab3dEf6hIj9k');
    });
  });

  group('the household screen', () {
    Future<void> open(WidgetTester tester) async {
      await pumpApp(tester, households: households);
      await tester.tap(find.byTooltip('Household'));
      await tester.pumpAndSettle();
    }

    testWidgets('lists the members', (tester) async {
      await open(tester);

      expect(find.text('Our home'), findsOneWidget);
      expect(find.text('Ann'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
    });

    testWidgets('shows a new invite code and copies its link', (tester) async {
      final copied = <String>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.setData') {
            copied.add((call.arguments as Map)['text'] as String);
          }
          return null;
        },
      );
      await open(tester);

      await tester.tap(find.text('Invite someone'));
      await tester.pumpAndSettle();
      expect(find.text('Ab3dEf6hIj9k'), findsOneWidget);
      expect(find.textContaining('expires on'), findsOneWidget);

      await tester.tap(find.text('Copy link'));
      await tester.pumpAndSettle();
      expect(copied, ['https://plants.pampait.pl/i/Ab3dEf6hIj9k']);
      expect(find.text('Invite link copied'), findsOneWidget);
    });

    testWidgets('says when an invite cannot be made offline', (tester) async {
      households.inviteResult = const Failure(HouseholdFailure.network);
      await open(tester);

      await tester.tap(find.text('Invite someone'));
      await tester.pumpAndSettle();

      expect(find.textContaining("Can't reach the server"), findsOneWidget);
    });

    testWidgets('leaving asks first, then goes home', (tester) async {
      await open(tester);

      await tester.tap(find.text('Leave household'));
      await tester.pumpAndSettle();
      expect(find.text('Leave Our home?'), findsOneWidget);
      await tester.tap(find.text('Leave'));
      await tester.pumpAndSettle();

      expect(households.leaves, [false]);
      expect(find.text('Set up your household'), findsOneWidget);
    });

    testWidgets('the last member must confirm deleting the household', (
      tester,
    ) async {
      households.leaveResults = [
        const Failure(HouseholdFailure.confirmationRequired),
        const Success(null),
      ];
      await open(tester);

      await tester.tap(find.text('Leave household'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Leave'));
      await tester.pumpAndSettle();
      expect(find.text('You are the last member'), findsOneWidget);

      await tester.tap(find.text('Delete household'));
      await tester.pumpAndSettle();

      expect(households.leaves, [false, true]);
      expect(find.text('Set up your household'), findsOneWidget);
    });

    testWidgets('cancelling leaves nothing changed', (tester) async {
      await open(tester);

      await tester.tap(find.text('Leave household'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(households.leaves, isEmpty);
      expect(find.text('Members'), findsOneWidget);
    });

    for (final brightness in Brightness.values) {
      testWidgets('meets accessibility guidelines (${brightness.name})', (
        tester,
      ) async {
        final handle = tester.ensureSemantics();
        await pumpApp(tester, households: households, brightness: brightness);
        await tester.tap(find.byTooltip('Household'));
        await tester.pumpAndSettle();

        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        await expectLater(tester, meetsGuideline(textContrastGuideline));
        handle.dispose();
      });
    }
  });

  testWidgets('the forms work at 200% text on a small phone', (tester) async {
    await pumpApp(
      tester,
      households: FakeHouseholdRepository(current: null),
      location: '/household/create',
      textScale: 2,
      size: const Size(320, 568),
    );

    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(
      find.text('Create'),
      50,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Create'), findsOneWidget);
  });
}
