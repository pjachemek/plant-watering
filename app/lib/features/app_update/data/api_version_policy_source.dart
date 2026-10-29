import 'package:plantnfc/core/api/api_failure.dart';
import 'package:plantnfc/core/api/api_interceptors.dart';
import 'package:plantnfc/core/api/api_providers.dart';
import 'package:plantnfc/core/api/generated/models/platform.dart';
import 'package:plantnfc/core/api/generated/plant_api_client.dart';
import 'package:plantnfc/core/config/app_version.dart';
import 'package:plantnfc/core/result/result.dart';
import 'package:plantnfc/features/app_update/domain/version_policy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_version_policy_source.g.dart';

/// `GET /v1/config` (FR-10). Callable before sign-in.
class ApiVersionPolicySource implements VersionPolicySource {
  new(this._api);

  final PlantApiClient _api;

  @override
  Future<VersionPolicy?> fetch() async {
    final result = await guardApi(
      () => _api.config.getConfig(
        xAppVersion: appVersion,
        xPlatform: Platform.android,
        xApiVersion: ApiHeadersInterceptor.apiVersion,
      ),
    );
    return switch (result) {
      Success(:final value) => VersionPolicy(
        minVersion: value.minVersion,
        recommendedVersion: value.recommendedVersion,
      ),
      Failure() => null,
    };
  }
}

/// Tests override this with a fake.
@Riverpod(keepAlive: true)
VersionPolicySource versionPolicySource(Ref ref) =>
    ApiVersionPolicySource(ref.watch(plantApiProvider));
