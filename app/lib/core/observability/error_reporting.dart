import 'dart:async';

import 'package:plantnfc/core/config/app_config.dart';
import 'package:plantnfc/core/observability/pii_scrubber.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Starts the app with Sentry when a DSN is configured, or directly otherwise.
/// Settings follow ADR-0005: no default PII, screenshots, view hierarchy or
/// performance tracing, and every event goes through [PiiScrubber].
Future<void> runWithErrorReporting(
  AppConfig config,
  FutureOr<void> Function() appRunner,
) async {
  if (!config.errorReportingEnabled) {
    await appRunner();
    return;
  }
  await SentryFlutter.init((options) {
    options
      ..dsn = config.sentryDsn
      ..environment = config.environment
      ..sendDefaultPii = false
      ..attachScreenshot = false
      ..attachViewHierarchy = false
      ..enableAutoPerformanceTracing = false
      ..tracesSampleRate = null
      ..beforeSend = PiiScrubber.scrubEvent
      ..beforeBreadcrumb = PiiScrubber.scrubBreadcrumb;
  }, appRunner: appRunner);
}
