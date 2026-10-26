import 'package:sentry_flutter/sentry_flutter.dart';

/// Removes personal data from Sentry events and breadcrumbs before they leave
/// the device (NFR Privacy: no emails, names, tokens or photo URLs). Mirrors
/// `functions/src/lib/sentry.ts`; see ADR-0005.
abstract final class PiiScrubber {
  static final RegExp _sensitiveKey = RegExp(
    'token|email|name|authorization|cookie|photo|jwt|secret|key|url',
    caseSensitive: false,
  );
  static final RegExp _email = RegExp(r'[^\s@]+@[^\s@]+\.[^\s@]+');
  static final RegExp _tagPath = RegExp('/p/[A-Za-z0-9]+');
  static final RegExp _signedUrlQuery = RegExp(r'\?[^\s]*token=[^\s]*');

  static String scrubString(String value) => value
      .replaceAll(_email, '[email]')
      .replaceAll(_tagPath, '/p/[token]')
      .replaceAll(_signedUrlQuery, '?[redacted]');

  static Map<String, dynamic>? _scrubMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    return map.map((key, value) {
      if (_sensitiveKey.hasMatch(key)) return MapEntry(key, '[redacted]');
      if (value is String) return MapEntry(key, scrubString(value));
      return MapEntry(key, value);
    });
  }

  static SentryEvent scrubEvent(SentryEvent event, Hint hint) {
    event
      ..user = null
      ..request = null
      ..breadcrumbs = event.breadcrumbs?.map(scrubBreadcrumbValue).toList();
    final message = event.message;
    if (message != null) {
      event.message = SentryMessage(scrubString(message.formatted));
    }
    for (final exception in event.exceptions ?? const <SentryException>[]) {
      final value = exception.value;
      if (value != null) exception.value = scrubString(value);
    }
    return event;
  }

  static Breadcrumb scrubBreadcrumb(Breadcrumb? crumb, Hint hint) =>
      scrubBreadcrumbValue(crumb ?? Breadcrumb());

  static Breadcrumb scrubBreadcrumbValue(Breadcrumb crumb) {
    final message = crumb.message;
    if (message != null) crumb.message = scrubString(message);
    crumb.data = _scrubMap(crumb.data);
    return crumb;
  }
}
