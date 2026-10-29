import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantnfc/core/api/generated/plant_api_client.dart';
import 'package:plantnfc/features/app_update/data/api_version_policy_source.dart';

import '../../../helpers/fake_http_adapter.dart';

void main() {
  test('reads the policy from GET /config, ignoring unknown fields', () async {
    final http = FakeHttpAdapter(
      (_) => (
        200,
        {
          'platform': 'android',
          'min_version': '0.1.0',
          'recommended_version': '0.2.0',
          'api_version': '1',
          'features': <String, bool>{},
          'added_later': 'ignored',
        },
      ),
    );
    final dio = Dio(BaseOptions(baseUrl: 'https://api.test/v1'))
      ..httpClientAdapter = http;

    final policy = await ApiVersionPolicySource(PlantApiClient(dio)).fetch();

    expect(http.requests.single.path, '/config');
    expect(policy?.minVersion, '0.1.0');
    expect(policy?.recommendedVersion, '0.2.0');
  });

  test('returns null when the policy cannot be read', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://api.test/v1'))
      ..httpClientAdapter = FakeHttpAdapter((_) => (503, null));

    expect(await ApiVersionPolicySource(PlantApiClient(dio)).fetch(), isNull);
  });
}
