import 'package:go_router/go_router.dart';
import 'package:plantnfc/core/router/not_found_screen.dart';
import 'package:plantnfc/features/plants/presentation/plants_screen.dart';
import 'package:plantnfc/features/scan/presentation/tag_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// Route paths. `/p/:tagToken` must match the tag URL format and the
/// AASA / assetlinks paths (AGENTS.md sections 5 and 7).
abstract final class AppRoutes {
  static const String plants = '/';
  static const String tag = '/p/:tagToken';

  static String tagPath(String tagToken) => '/p/$tagToken';
}

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final router = GoRouter(
    initialLocation: AppRoutes.plants,
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
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
  ref.onDispose(router.dispose);
  return router;
}
