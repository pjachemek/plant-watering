import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantnfc/core/result/result.dart';
import 'package:plantnfc/core/router/app_router.dart';
import 'package:plantnfc/features/scan/data/nfc_providers.dart';
import 'package:plantnfc/features/scan/domain/nfc_service.dart';
import 'package:plantnfc/features/scan/domain/tag_link.dart';
import 'package:plantnfc/features/scan/domain/tag_token.dart';

import '../../../helpers/fake_nfc_service.dart';
import '../../../helpers/pump_app.dart';

void main() {
  late FakeNfcService nfc;

  setUp(() => nfc = FakeNfcService());

  Future<void> pumpSpike(
    WidgetTester tester, {
    Brightness brightness = Brightness.light,
    double textScale = 1,
  }) => pumpApp(
    tester,
    location: AppRoutes.nfcSpike,
    brightness: brightness,
    textScale: textScale,
    overrides: [nfcServiceProvider.overrideWithValue(nfc)],
  );

  testWidgets('is reachable from the plant list in debug builds', (
    tester,
  ) async {
    await pumpApp(
      tester,
      overrides: [nfcServiceProvider.overrideWithValue(nfc)],
    );

    await tester.tap(find.byTooltip('NFC test'));
    await tester.pumpAndSettle();

    expect(find.text('Write test sticker'), findsOneWidget);
  });

  testWidgets('write: waits for a sticker, then confirms success', (
    tester,
  ) async {
    await pumpSpike(tester);

    await tester.tap(find.text('Write test sticker'));
    await tester.pump();

    expect(find.text('Hold your phone near the sticker'), findsOneWidget);
    expect(nfc.writes.single.overwrite, isFalse);
    expect(TagLink.parse(nfc.writes.single.link), isNotNull);

    nfc.completeWrite(const Success(null));
    await tester.pumpAndSettle();

    expect(find.text('Sticker written and checked'), findsOneWidget);
  });

  testWidgets('write: cancel returns to idle', (tester) async {
    await pumpSpike(tester);

    await tester.tap(find.text('Write test sticker'));
    await tester.pump();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(nfc.cancels, greaterThan(0));
    expect(find.text('Hold your phone near the sticker'), findsNothing);
  });

  testWidgets('write: asks before overwriting and reuses the same link', (
    tester,
  ) async {
    await pumpSpike(tester);

    await tester.tap(find.text('Write test sticker'));
    await tester.pump();
    nfc.completeWrite(
      Failure(OverwriteNeedsConfirmation(PlantLinkTag(TagToken.generate()))),
    );
    await tester.pumpAndSettle();

    expect(find.text('This sticker already has a plant link'), findsOneWidget);

    await tester.tap(find.text('Overwrite sticker'));
    await tester.pump();

    expect(nfc.writes, hasLength(2));
    expect(nfc.writes.last.overwrite, isTrue);
    expect(nfc.writes.last.link, nfc.writes.first.link);

    nfc.completeWrite(const Success(null));
    await tester.pumpAndSettle();
    expect(find.text('Sticker written and checked'), findsOneWidget);
  });

  testWidgets('write: foreign data gets its own warning', (tester) async {
    await pumpSpike(tester);

    await tester.tap(find.text('Write test sticker'));
    await tester.pump();
    nfc.completeWrite(
      const Failure(OverwriteNeedsConfirmation(ForeignDataTag())),
    );
    await tester.pumpAndSettle();

    expect(find.text('This sticker already holds other data'), findsOneWidget);
  });

  group('failures show a specific message and a retry', () {
    final cases = <NfcFailure, String>{
      const TagLost(): 'The phone moved away too soon',
      const TagReadOnly(): 'This sticker is locked',
      const TagTooSmall(neededBytes: 60, capacityBytes: 40): 'too small',
      const TagNotNdef(): 'sticker type isn’t supported',
      const WriteNotVerified(): 'Hold your phone still on the sticker',
      const NfcUnavailable(NfcAvailability.disabled): 'NFC is turned off',
      const NfcUnavailable(NfcAvailability.unsupported): 'can’t read NFC',
      const NfcUnknownFailure('X'): 'Something went wrong',
    };
    for (final MapEntry(key: failure, value: text) in cases.entries) {
      testWidgets(failure.runtimeType.toString(), (tester) async {
        await pumpSpike(tester);

        await tester.tap(find.text('Write test sticker'));
        await tester.pump();
        nfc.completeWrite(Failure(failure));
        await tester.pumpAndSettle();

        expect(find.textContaining(text), findsOneWidget);

        await tester.tap(find.text('Try again'));
        await tester.pump();
        expect(nfc.writes, hasLength(2));
      });
    }
  });

  testWidgets('read: a plant link opens the tag route', (tester) async {
    await pumpSpike(tester);

    await tester.tap(find.text('Read sticker'));
    await tester.pump();
    nfc.completeRead(Success(PlantLinkTag(TagToken.generate())));
    await tester.pumpAndSettle();

    expect(find.text('This sticker holds a plant link'), findsOneWidget);

    await tester.tap(find.text('Open plant link'));
    await tester.pumpAndSettle();

    expect(find.text('Plant tag'), findsWidgets);
  });

  testWidgets('read: empty and foreign stickers are described', (tester) async {
    await pumpSpike(tester);

    await tester.tap(find.text('Read sticker'));
    await tester.pump();
    nfc.completeRead(const Success(EmptyTag()));
    await tester.pumpAndSettle();
    expect(find.text('This sticker is empty'), findsOneWidget);

    await tester.tap(find.text('Read sticker'));
    await tester.pump();
    nfc.completeRead(const Success(ForeignDataTag()));
    await tester.pumpAndSettle();
    expect(find.text('This sticker holds data from another app'), findsOne);
  });

  testWidgets('read: failure offers a retry that reads again', (tester) async {
    await pumpSpike(tester);

    await tester.tap(find.text('Read sticker'));
    await tester.pump();
    nfc.completeRead(const Failure(TagLost()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Try again'));
    await tester.pump();

    expect(nfc.reads, 2);
  });

  testWidgets('leaving the screen cancels the NFC session', (tester) async {
    final container = await pumpApp(
      tester,
      location: AppRoutes.nfcSpike,
      overrides: [nfcServiceProvider.overrideWithValue(nfc)],
    );
    await tester.tap(find.text('Read sticker'));
    await tester.pump();

    container.read(appRouterProvider).go(AppRoutes.plants);
    await tester.pumpAndSettle();

    expect(nfc.cancels, greaterThan(0));
  });

  for (final brightness in Brightness.values) {
    testWidgets('waiting state meets accessibility guidelines '
        '(${brightness.name})', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpSpike(tester, brightness: brightness);
      await tester.tap(find.text('Write test sticker'));
      await tester.pump();

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      handle.dispose();
    });
  }

  testWidgets('works at 200% text on a small phone', (tester) async {
    await pumpApp(
      tester,
      location: AppRoutes.nfcSpike,
      textScale: 2,
      size: const Size(320, 568),
      overrides: [nfcServiceProvider.overrideWithValue(nfc)],
    );
    // At 200% the buttons sit below the fold; the list must scroll to them.
    final write = find.text('Write test sticker');
    await tester.scrollUntilVisible(write, 50);
    await tester.ensureVisible(write);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Write test sticker'));
    await tester.pump();
    nfc.completeWrite(const Failure(TagLost()));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(find.text('Try again'), 50);
    expect(find.text('Try again'), findsOneWidget);
  });
}
