import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:plantnfc/core/router/not_found_screen.dart';
import 'package:plantnfc/features/app_update/domain/version_policy.dart';
import 'package:plantnfc/features/app_update/presentation/app_update_controller.dart';
import 'package:plantnfc/features/app_update/presentation/update_required_screen.dart';
import 'package:plantnfc/features/auth/data/auth_providers.dart';
import 'package:plantnfc/features/auth/domain/auth_repository.dart';
import 'package:plantnfc/features/auth/domain/auth_status.dart';
import 'package:plantnfc/features/auth/presentation/sign_in_screen.dart';
import 'package:plantnfc/features/household/presentation/household_forms.dart';
import 'package:plantnfc/features/household/presentation/household_screen.dart';
import 'package:plantnfc/features/plants/presentation/plants_screen.dart';
import 'package:plantnfc/features/plants/presentation/sync_test_screen.dart';
import 'package:plantnfc/features/scan/presentation/nfc_spike_screen.dart';
import 'package:plantnfc/features/scan/presentation/tag_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// Route paths. `/p/:tagToken` must match the tag URL format and the
/// AASA / assetlinks paths (AGENTS.md sections 5 and 7).
abstract final class AppRoutes {
  static const String plants = '/';
  static const String tag = '/p/:tagToken';

  static String tagPath(String tagToken) => '/p/$tagToken';

  /// Sign-in (FR-7). `?from=` is where to go afterwards.
  static const String signIn = '/sign-in';

  /// Blocking update screen (FR-10).
  static const String updateRequired = '/update';

  /// Household (FR-7).
  static const String household = '/household';
  static const String householdCreate = '/household/create';

  /// `?code=` fills in the invite code.
  static const String householdJoin = '/household/join';

  /// Invite links (`https://plants.pampait.pl/i/{code}`, ADR-0018): the App
  /// Link opens the join screen with the code filled in.
  static const String invite = '/i/:code';

  /// Developer NFC test screen (M1). Registered in debug builds only.
  static const String nfcSpike = '/dev/nfc';

  /// Developer sync test screen (M2 exit test). Debug builds only.
  static const String syncTest = '/dev/sync';
}

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final auth = ref.watch(authRepositoryProvider);
  final refresh = _RouterRefresh(auth);
  ref.listen(appUpdateControllerProvider, (_, _) => refresh.ping());
  final router = GoRouter(
    initialLocation: AppRoutes.plants,
    refreshListenable: refresh,
    redirect: (context, state) => appRedirect(
      updateRequired:
          ref.read(appUpdateControllerProvider).status ==
          AppUpdateStatus.required,
      signedIn: auth.status is SignedIn,
      location: state.uri,
    ),
    routes: [
      GoRoute(
        path: AppRoutes.plants,
        builder: (context, state) => const PlantsScreen(),
      ),
      GoRoute(
        path: AppRoutes.tag,
        builder: (context, state) =>
            TagScreen(tagToken: state.pathParameters['tagToken']!),
      ),
      GoRoute(
        path: AppRoutes.updateRequired,
        builder: (context, state) => const UpdateRequiredScreen(),
      ),
      GoRoute(
        path: AppRoutes.household,
        builder: (context, state) => const HouseholdScreen(),
      ),
      GoRoute(
        path: AppRoutes.householdCreate,
        builder: (context, state) => const CreateHouseholdScreen(),
      ),
      GoRoute(
        path: AppRoutes.householdJoin,
        builder: (context, state) =>
            JoinHouseholdScreen(code: state.uri.queryParameters['code']),
      ),
      GoRoute(
        path: AppRoutes.invite,
        builder: (context, state) =>
            JoinHouseholdScreen(code: state.pathParameters['code']),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) => const SignInScreen(),
      ),
      if (kDebugMode) ...[
        GoRoute(
          path: AppRoutes.nfcSpike,
          builder: (context, state) => const NfcSpikeScreen(),
        ),
        GoRoute(
          path: AppRoutes.syncTest,
          builder: (context, state) => const SyncTestScreen(),
        ),
      ],
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
  ref
    ..onDispose(router.dispose)
    ..onDispose(refresh.dispose);
  return router;
}

/// Where to go instead of [location], or `null` to stay.
///
/// Below the minimum version every screen leads to the update screen, and
/// nothing else is consulted, not even sign-in (FR-10). Once allowed again,
/// the update screen leads home; then [authRedirect] applies.
@visibleForTesting
String? appRedirect({
  required bool updateRequired,
  required bool signedIn,
  required Uri location,
}) {
  final onUpdate = location.path == AppRoutes.updateRequired;
  if (updateRequired) return onUpdate ? null : AppRoutes.updateRequired;
  if (onUpdate) return AppRoutes.plants;
  return authRedirect(signedIn: signedIn, location: location);
}

/// Signed out: everything except sign-in leads to sign-in, remembering where
/// it was going, so a tag scanned before signing in still opens its plant.
/// Signed in: the sign-in screen leads on. A signed-in cold start from a tag
/// goes straight to it (AGENTS.md section 5).
@visibleForTesting
String? authRedirect({required bool signedIn, required Uri location}) {
  final path = location.path;
  final onSignIn = path == AppRoutes.signIn;
  if (!signedIn) {
    if (onSignIn) return null;
    // Path and query only: an app link arrives as the full URL
    // (https://plants.pampait.pl/p/...), which must not count as leaving the
    // app when it's followed after sign-in.
    final from = Uri(
      path: path,
      query: location.hasQuery ? location.query : null,
    ).toString();
    return Uri(
      path: AppRoutes.signIn,
      queryParameters: path == AppRoutes.plants ? null : {'from': from},
    ).toString();
  }
  if (!onSignIn) return null;
  final from = location.queryParameters['from'];
  // Only paths inside the app, never another host.
  return from != null && from.startsWith('/') && !from.startsWith('//')
      ? from
      : AppRoutes.plants;
}

/// Tells the router to re-check its redirects when the auth status or the
/// update status changes.
class _RouterRefresh extends ChangeNotifier {
  new(AuthRepository auth) {
    _subscription = auth.statusChanges.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthStatus> _subscription;

  void ping() => notifyListeners();

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
