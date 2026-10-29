import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantnfc/core/api/api_failure.dart';
import 'package:plantnfc/core/api/api_interceptors.dart';
import 'package:plantnfc/core/config/app_version.dart';
import 'package:plantnfc/core/result/result.dart';

import '../../helpers/fake_http_adapter.dart';

void main() {
  late FakeHttpAdapter http;
  late Dio dio;
  String? token;
  String? refreshed;
  var upgrades = 0;

  setUp(() {
    token = 'token-1';
    refreshed = 'token-2';
    upgrades = 0;
    http = FakeHttpAdapter((_) => (200, {'ok': true}));
    dio = Dio(BaseOptions(baseUrl: 'https://api.test/v1'))
      ..httpClientAdapter = http;
    dio.interceptors.addAll([
      ApiHeadersInterceptor(),
      AuthInterceptor(
        dio: dio,
        accessToken: () async => token,
        refreshAccessToken: () async => refreshed,
      ),
      UpgradeRequiredInterceptor(() => upgrades++),
    ]);
  });

  Future<ApiFailure?> failureOf(Future<Object?> Function() call) =>
      guardApi(call).then((r) => r.fold((_) => null, (failure) => failure));

  test('every request carries the version headers and the token', () async {
    await dio.get<Object?>('/config');

    final headers = http.requests.single.headers;
    expect(headers['X-App-Version'], appVersion);
    expect(headers['X-Platform'], 'android');
    expect(headers['X-API-Version'], '1');
    expect(headers['Authorization'], 'Bearer token-1');
  });

  test('sends no token when signed out', () async {
    token = null;

    await dio.get<Object?>('/config');

    expect(http.requests.single.headers, isNot(contains('Authorization')));
  });

  test('on 401 refreshes the token once and retries', () async {
    http.respond = (r) => r.headers['Authorization'] == 'Bearer token-2'
        ? (200, {'ok': true})
        : (401, null);

    final response = await dio.get<Object?>('/households');

    expect(response.statusCode, 200);
    expect(http.requests, hasLength(2));
  });

  test('passes on a second 401, and a 401 it cannot refresh', () async {
    http.respond = (_) => (401, null);

    expect(
      await failureOf(() => dio.get<Object?>('/households')),
      ApiFailure.unauthorized,
    );
    expect(http.requests, hasLength(2));

    http.requests.clear();
    refreshed = null;
    expect(
      await failureOf(() => dio.get<Object?>('/households')),
      ApiFailure.unauthorized,
    );
    expect(http.requests, hasLength(1));
  });

  test('reports 426 so the app can switch to its update screen', () async {
    http.respond = (_) => (426, null);

    expect(
      await failureOf(() => dio.get<Object?>('/households')),
      ApiFailure.upgradeRequired,
    );
    expect(upgrades, 1);
  });

  test('maps errors to typed failures', () async {
    Future<ApiFailure?> statusFailure(int status) {
      http.respond = (_) => (status, null);
      return failureOf(() => dio.get<Object?>('/x'));
    }

    expect(await statusFailure(404), ApiFailure.notFound);
    expect(await statusFailure(409), ApiFailure.conflict);
    expect(await statusFailure(429), ApiFailure.rateLimited);
    expect(await statusFailure(503), ApiFailure.server);
    expect(await statusFailure(400), ApiFailure.badRequest);

    http.respond = (r) =>
        throw DioException.connectionError(requestOptions: r, reason: 'off');
    expect(await failureOf(() => dio.get<Object?>('/x')), ApiFailure.network);

    expect(
      await guardApi<int>(() async => throw const FormatException('bad')),
      const Failure<int, ApiFailure>(ApiFailure.badRequest),
    );
  });
}
