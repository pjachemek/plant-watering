@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantnfc/app.dart';

import '../helpers/pump_app.dart';

// Goldens are generated on Linux (CI and the Docker image in the README).
// Regenerate with: flutter test --update-goldens --tags golden
void main() {
  final variants = <String, ({Brightness brightness, double textScale})>{
    'light': (brightness: Brightness.light, textScale: 1),
    'dark': (brightness: Brightness.dark, textScale: 1),
    'light_text200': (brightness: Brightness.light, textScale: 2),
  };

  for (final MapEntry(key: name, value: v) in variants.entries) {
    testWidgets('plants screen empty state, $name', (tester) async {
      await pumpApp(tester, brightness: v.brightness, textScale: v.textScale);

      await expectLater(
        find.byType(PlantApp),
        matchesGoldenFile('plants_screen_$name.png'),
      );
    });
  }
}
