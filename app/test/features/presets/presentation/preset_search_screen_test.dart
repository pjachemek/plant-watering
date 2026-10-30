import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantnfc/core/router/app_router.dart';
import 'package:plantnfc/features/presets/data/preset_catalog_loader.dart';
import 'package:plantnfc/features/presets/domain/preset.dart';

import '../../../helpers/pump_app.dart';

void main() {
  // The bundled file, read once: the asset cache would keep a load from an
  // earlier test whose fake clock is gone, so it never completes here.
  late PresetCatalog catalog;
  setUpAll(() {
    catalog = parsePresetCatalog(File(presetAsset).readAsStringSync());
  });

  Future<void> open(WidgetTester tester, {double textScale = 1}) async {
    await pumpApp(
      tester,
      location: AppRoutes.presetSearch,
      textScale: textScale,
      size: textScale > 1 ? const Size(320, 568) : const Size(390, 844),
      overrides: [presetCatalogProvider.overrideWithValue(AsyncData(catalog))],
    );
    await tester.pumpAndSettle();
  }

  testWidgets('finds presets by Polish name and shows how long it took', (
    tester,
  ) async {
    await open(tester);

    await tester.enterText(find.byType(TextField), 'skrzyd');
    await tester.pumpAndSettle();

    expect(find.text('Peace lily'), findsOneWidget);
    expect(find.textContaining('Matched: Skrzydłokwiat'), findsOneWidget);
    expect(find.textContaining(RegExp(r'1 result in \d+\.\d ms')), findsOne);
  });

  testWidgets('says when nothing matches', (tester) async {
    await open(tester);

    await tester.enterText(find.byType(TextField), 'xyzzy');
    await tester.pumpAndSettle();

    expect(find.text('No presets match'), findsOneWidget);
  });

  testWidgets('works at 200% text on a small phone', (tester) async {
    await open(tester, textScale: 2);

    await tester.enterText(find.byType(TextField), 'palm');
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(
      find.text('Areca palm'),
      50,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Areca palm'), findsOneWidget);
  });
}
