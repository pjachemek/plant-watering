import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:plantnfc/app.dart';
import 'package:plantnfc/core/router/app_router.dart';

/// Pumps the real app at [location], with the given platform brightness and
/// text scale, with optional provider [overrides], and returns the provider
/// container.
Future<ProviderContainer> pumpApp(
  WidgetTester tester, {
  String location = AppRoutes.plants,
  Brightness brightness = Brightness.light,
  double textScale = 1,
  Size size = const Size(390, 844),
  List<Override> overrides = const [],
}) async {
  tester.platformDispatcher
    ..platformBrightnessTestValue = brightness
    ..textScaleFactorTestValue = textScale;
  tester.view
    ..physicalSize = size * tester.view.devicePixelRatio
    ..devicePixelRatio = tester.view.devicePixelRatio;
  addTearDown(tester.platformDispatcher.clearAllTestValues);
  addTearDown(tester.view.reset);

  final container = ProviderContainer(overrides: overrides);
  addTearDown(container.dispose);
  container.read(appRouterProvider).go(location);

  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const PlantApp()),
  );
  await tester.pumpAndSettle();
  return container;
}
