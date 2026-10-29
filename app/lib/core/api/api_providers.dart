import 'package:dio/dio.dart';
import 'package:plantnfc/core/api/api_interceptors.dart';
import 'package:plantnfc/core/api/generated/plant_api_client.dart';
import 'package:plantnfc/core/config/config_provider.dart';
import 'package:plantnfc/features/app_update/presentation/app_update_controller.dart';
import 'package:plantnfc/features/auth/data/auth_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_providers.g.dart';

/// The HTTP client for the versioned API, the app's only backend (ADR-0012).
/// Every request carries the version headers and, when signed in, the
/// access token; a 426 switches the app to its update screen (FR-10).
@Riverpod(keepAlive: true)
Dio apiDio(Ref ref) {
  final config = ref.watch(appConfigProvider);
  final auth = ref.watch(authRepositoryProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );
  dio.interceptors.addAll([
    ApiHeadersInterceptor(),
    AuthInterceptor(
      dio: dio,
      accessToken: auth.accessToken,
      refreshAccessToken: auth.refreshAccessToken,
    ),
    UpgradeRequiredInterceptor(
      () => ref.read(appUpdateControllerProvider.notifier).upgradeRequired(),
    ),
  ]);
  ref.onDispose(dio.close);
  return dio;
}

/// The generated client (ADR-0015) on [apiDio].
@Riverpod(keepAlive: true)
PlantApiClient plantApi(Ref ref) => PlantApiClient(ref.watch(apiDioProvider));
