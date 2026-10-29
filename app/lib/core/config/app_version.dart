/// The app version the API sees in `X-App-Version` (FR-10). Must equal the
/// version name in pubspec.yaml; `test/core/config/app_version_test.dart`
/// checks it, so a release can't ship with a stale value.
const String appVersion = '0.1.0';
