import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:plantnfc/core/router/not_found_screen.dart';
import 'package:plantnfc/features/auth/data/auth_providers.dart';
import 'package:plantnfc/features/auth/domain/auth_repository.dart';
import 'package:plantnfc/features/auth/domain/auth_status.dart';
import 'package:plantnfc/features/auth/presentation/auth_callback_screen.dart';
import 'package:plantnfc/features/auth/presentation/sign_in_screen.dart';
import 'package:plantnfc/features/plants/presentation/plants_screen.dart';
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

  /// Target of email sign-in links; must match `AppConfig.authRedirect` and
  /// the App Link filter in AndroidManifest.xml (ADR-0021).
  static const String authCallback = '/auth/callback';

  /// Developer NFC test screen (M1). Registered in debug builds only.
  static const String nfcSpike = '/dev/nfc';
}

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final auth = ref.watch(authRepositoryProvider);
  final refresh = _AuthRefresh(auth);
  final router = GoRouter(
    initialLocation: AppRoutes.plants,
    refreshListenable: refresh,
    redirect: (context, state) =>
        authRedirect(signedIn: auth.status is SignedIn, location: state.uri),
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
        path: AppRoutes.signIn,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: AppRoutes.authCallback,
        builder: (context, state) =>
            AuthCallbackScreen(code: state.uri.queryParameters['code']),
      ),
      if (kDebugMode)
        GoRoute(
          path: AppRoutes.nfcSpike,
          builder: (context, state) => const NfcSpikeScreen(),
        ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
  ref
    ..onDispose(router.dispose)
    ..onDispose(refresh.dispose);
  return router;
}

/// Signed out: everything except sign-in leads to sign-in, remembering where
/// it was going, so a tag scanned before signing in still opens its plant.
/// Signed in: the sign-in screens lead on. A signed-in cold start from a tag
/// goes straight to it (AGENTS.md section 5).
@visibleForTesting
String? authRedirect({required bool signedIn, required Uri location}) {
  final path = location.path;
  final onSignIn = path == AppRoutes.signIn || path == AppRoutes.authCallback;
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

/// Tells the router to re-check [authRedirect] when the auth status changes.
class _AuthRefresh extends ChangeNotifier {
  new(AuthRepository auth) {
    _subscription = auth.statusChanges.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthStatus> _subscription;

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
