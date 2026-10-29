import 'package:dio/dio.dart';
import 'package:plantnfc/core/config/app_version.dart';

/// The headers every request carries (AGENTS.md section 5, NFR
/// Compatibility: 100% of requests carry version headers). Set here, so no
/// call can forget them.
class ApiHeadersInterceptor extends Interceptor {
  new({this.platform = 'android'});

  final String platform;

  static const String apiVersion = '1';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers
      ..['X-App-Version'] = appVersion
      ..['X-Platform'] = platform
      ..['X-API-Version'] = apiVersion;
    handler.next(options);
  }
}

/// Adds the access token, and on a 401 refreshes it once and retries
/// (ADR-0021). A second 401 is passed on: the session is gone.
class AuthInterceptor extends Interceptor {
  new({
    required this.dio,
    required this.accessToken,
    required this.refreshAccessToken,
  });

  /// The client the retry goes through (the one this interceptor is on).
  final Dio dio;
  final Future<String?> Function() accessToken;
  final Future<String?> Function() refreshAccessToken;

  static const String _retried = 'auth_retried';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // A retry already carries the refreshed token.
    if (options.extra[_retried] != true) {
      final token = await accessToken();
      if (token != null) options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    if (err.response?.statusCode != 401 || request.extra[_retried] == true) {
      handler.next(err);
      return;
    }
    final token = await refreshAccessToken();
    if (token == null) {
      handler.next(err);
      return;
    }
    request
      ..extra[_retried] = true
      ..headers['Authorization'] = 'Bearer $token';
    try {
      handler.resolve(await dio.fetch<Object?>(request));
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }
}

/// Tells the app when the API refuses this version (426, FR-10).
class UpgradeRequiredInterceptor extends Interceptor {
  new(this.onUpgradeRequired);

  final void Function() onUpgradeRequired;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 426) onUpgradeRequired();
    handler.next(err);
  }
}
