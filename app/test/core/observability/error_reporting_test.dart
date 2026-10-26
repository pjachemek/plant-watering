import 'package:flutter_test/flutter_test.dart';
import 'package:plantnfc/core/config/app_config.dart';
import 'package:plantnfc/core/observability/error_reporting.dart';

void main() {
  test('without a DSN the app runs directly and reporting is off', () async {
    const config = AppConfig(
      environment: 'dev',
      supabaseUrl: '',
      supabaseAnonKey: '',
      sentryDsn: '',
    );
    var ran = false;

    await runWithErrorReporting(config, () => ran = true);

    expect(config.errorReportingEnabled, isFalse);
    expect(ran, isTrue);
  });

  test('fromEnvironment defaults to dev with reporting off', () {
    final config = AppConfig.fromEnvironment();

    expect(config.environment, 'dev');
    expect(config.errorReportingEnabled, isFalse);
  });

  test('a DSN turns reporting on', () {
    const config = AppConfig(
      environment: 'staging',
      supabaseUrl: '',
      supabaseAnonKey: '',
      sentryDsn: 'https://public@o0.ingest.sentry.io/0',
    );

    expect(config.errorReportingEnabled, isTrue);
  });
}
