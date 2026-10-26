import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantnfc/core/router/app_router.dart';

import 'helpers/pump_app.dart';

void main() {
  group('plants screen (empty state)', () {
    for (final brightness in Brightness.values) {
      testWidgets('renders in ${brightness.name} mode', (tester) async {
        await pumpApp(tester, brightness: brightness);

        expect(find.text('Plants'), findsOneWidget);
        expect(find.text('No plants yet'), findsOneWidget);
        expect(find.bySemanticsLabel('Potted plant illustration'), findsOne);
        final context = tester.element(find.text('No plants yet'));
        expect(Theme.of(context).brightness, brightness);
      });
    }

    testWidgets('add plant shows a placeholder message', (tester) async {
      await pumpApp(tester);

      await tester.tap(find.text('Add plant'));
      await tester.pump();

      expect(find.text('Coming soon'), findsOneWidget);
    });

    testWidgets('is usable at 200% text size on a small phone', (tester) async {
      await pumpApp(tester, textScale: 2, size: const Size(320, 568));

      expect(tester.takeException(), isNull);
      await tester.scrollUntilVisible(find.text('Add plant'), 50);
      expect(find.text('Add plant'), findsOneWidget);
    });

    testWidgets('meets accessibility guidelines', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpApp(tester);

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      handle.dispose();
    });
  });

  group('deep links', () {
    testWidgets('/p/:tagToken opens the tag screen directly', (tester) async {
      await pumpApp(tester, location: AppRoutes.tagPath('AbC123xyz'));

      expect(find.text('Plant tag'), findsWidgets);
      expect(find.text('Plants'), findsNothing);
      // The token is a bearer secret for the public card; never display it.
      expect(find.textContaining('AbC123xyz'), findsNothing);
    });

    testWidgets('tag screen leads back to the plant list', (tester) async {
      await pumpApp(tester, location: AppRoutes.tagPath('AbC123xyz'));

      await tester.tap(find.text('Go to plants'));
      await tester.pumpAndSettle();

      expect(find.text('No plants yet'), findsOneWidget);
    });

    testWidgets('unknown paths show not found with a way home', (tester) async {
      await pumpApp(tester, location: '/nope');

      expect(find.text('Page not found'), findsWidgets);
      await tester.tap(find.text('Go to plants'));
      await tester.pumpAndSettle();
      expect(find.text('No plants yet'), findsOneWidget);
    });

    testWidgets('tag screen meets accessibility guidelines', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpApp(
        tester,
        location: AppRoutes.tagPath('AbC'),
        brightness: Brightness.dark,
      );

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      handle.dispose();
    });
  });
}
