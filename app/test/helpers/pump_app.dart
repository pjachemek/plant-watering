import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:plantnfc/app.dart';
import 'package:plantnfc/core/config/app_config.dart';
import 'package:plantnfc/core/config/config_provider.dart';
import 'package:plantnfc/core/router/app_router.dart';
import 'package:plantnfc/core/sync/sync_controller.dart';
import 'package:plantnfc/features/app_update/data/api_version_policy_source.dart';
import 'package:plantnfc/features/app_update/domain/version_policy.dart';
import 'package:plantnfc/features/auth/data/auth_providers.dart';
import 'package:plantnfc/features/auth/domain/auth_repository.dart';
import 'package:plantnfc/features/household/data/api_household_repository.dart';
import 'package:plantnfc/features/household/domain/household.dart';

import 'fake_auth_repository.dart';
import 'fake_household_repository.dart';
import 'fake_version_policy_source.dart';

/// The configuration widget tests run with: Google sign-in available.
const AppConfig testConfig = AppConfig(
  environment: 'dev',
  apiBaseUrl: 'http://api.localhost/v1',
  supabaseUrl: 'http://127.0.0.1:54321',
  supabaseAnonKey: 'test-anon-key',
  sentryDsn: '',
  googleWebClientId: 'test-web-client.apps.googleusercontent.com',
);

/// As [testConfig], but a build without Google sign-in.
const AppConfig testConfigWithoutGoogle = AppConfig(
  environment: 'dev',
  apiBaseUrl: 'http://api.localhost/v1',
  supabaseUrl: 'http://127.0.0.1:54321',
  supabaseAnonKey: 'test-anon-key',
  sentryDsn: '',
  googleWebClientId: '',
);

/// The overrides every widget test needs: a fake sign-in (signed in unless
/// [auth] says otherwise), [config], an up-to-date version policy, and no
/// syncing or database. [overrides] come last and win.
List<Override> testOverrides({
  AuthRepository? auth,
  VersionPolicySource? versionPolicy,
  HouseholdRepository? households,
  AppConfig config = testConfig,
  List<Override> overrides = const [],
}) => [
  authRepositoryProvider.overrideWithValue(auth ?? FakeAuthRepository()),
  appConfigProvider.overrideWithValue(config),
  versionPolicySourceProvider.overrideWithValue(
    versionPolicy ?? FakeVersionPolicySource(),
  ),
  householdRepositoryProvider.overrideWithValue(
    households ?? FakeHouseholdRepository(),
  ),
  // Widget tests don't sync; the engine has its own tests.
  syncRunnerProvider.overrideWithValue((_) async => null),
  outboxSizeProvider.overrideWith((ref) => const Stream<int>.empty()),
  ...overrides,
];

/// Pumps the real app at [location], with the given platform brightness and
/// text scale, with optional provider [overrides], and returns the provider
/// container. Signed in unless an [auth] repository says otherwise.
Future<ProviderContainer> pumpApp(
  WidgetTester tester, {
  String location = AppRoutes.plants,
  Brightness brightness = Brightness.light,
  double textScale = 1,
  Size size = const Size(390, 844),
  List<Override> overrides = const [],
  AuthRepository? auth,
  VersionPolicySource? versionPolicy,
  HouseholdRepository? households,
  AppConfig config = testConfig,
}) async {
  tester.platformDispatcher
    ..platformBrightnessTestValue = brightness
    ..textScaleFactorTestValue = textScale;
  tester.view
    ..physicalSize = size * tester.view.devicePixelRatio
    ..devicePixelRatio = tester.view.devicePixelRatio;
  addTearDown(tester.platformDispatcher.clearAllTestValues);
  addTearDown(tester.view.reset);

  final container = ProviderContainer(
    overrides: testOverrides(
      auth: auth,
      versionPolicy: versionPolicy,
      households: households,
      config: config,
      overrides: overrides,
    ),
  );
  addTearDown(container.dispose);
  container.read(appRouterProvider).go(location);

  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const PlantApp()),
  );
  await tester.pumpAndSettle();
  return container;
}
