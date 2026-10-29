import 'package:dio/dio.dart';
import 'package:plantnfc/core/result/result.dart';

/// Why a call to the API failed, in terms the app can act on
/// (AGENTS.md section 5: typed failures, no exceptions reach the UI).
enum ApiFailure {
  /// No connection or no answer. Retry later; data stays queued.
  network,

  /// Not signed in, or the session can't be refreshed.
  unauthorized,

  /// Not there, or not visible to this user (the API doesn't say which).
  notFound,

  /// Conflicts with the current state, for example the last member leaving
  /// without confirming.
  conflict,

  /// Too many requests; retry after a pause.
  rateLimited,

  /// This app version is below the minimum (FR-10).
  upgradeRequired,

  /// The server failed. Retry later.
  server,

  /// The request or the answer broke the contract: a bug, not retried.
  badRequest,
}

/// Maps an error thrown by Dio (or by parsing an answer) to an [ApiFailure].
ApiFailure apiFailureOf(Object error) {
  if (error is! DioException) return ApiFailure.badRequest;
  final status = error.response?.statusCode;
  if (status == null) {
    return error.type == DioExceptionType.badCertificate
        ? ApiFailure.badRequest
        : ApiFailure.network;
  }
  return switch (status) {
    401 || 403 => ApiFailure.unauthorized,
    404 => ApiFailure.notFound,
    409 => ApiFailure.conflict,
    426 => ApiFailure.upgradeRequired,
    429 => ApiFailure.rateLimited,
    >= 500 => ApiFailure.server,
    _ => ApiFailure.badRequest,
  };
}

/// Runs one API [call] and returns its value or the [ApiFailure].
Future<Result<T, ApiFailure>> guardApi<T>(Future<T> Function() call) async {
  try {
    return Success(await call());
  } on DioException catch (error) {
    return Failure(apiFailureOf(error));
  } on Object catch (error) {
    // An answer the generated client couldn't parse.
    return Failure(apiFailureOf(error));
  }
}
