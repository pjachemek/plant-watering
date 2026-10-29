import 'package:plantnfc/features/app_update/domain/version_policy.dart';

/// A [VersionPolicySource] for widget tests: up to date unless set.
class FakeVersionPolicySource implements VersionPolicySource {
  VersionPolicy? policy = const VersionPolicy(
    minVersion: '0.0.1',
    recommendedVersion: '0.0.1',
  );
  int fetches = 0;

  @override
  Future<VersionPolicy?> fetch() async {
    fetches++;
    return policy;
  }
}
