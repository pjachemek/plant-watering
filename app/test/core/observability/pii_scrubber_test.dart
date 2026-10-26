import 'package:flutter_test/flutter_test.dart';
import 'package:plantnfc/core/observability/pii_scrubber.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() {
  group('scrubString', () {
    test('masks emails, tag tokens and signed URL tokens', () {
      expect(
        PiiScrubber.scrubString(
          'jane@example.com opened https://plants.pampait.pl/p/AbC123 '
          'and https://x.supabase.co/obj/a.jpg?token=abc',
        ),
        '[email] opened https://plants.pampait.pl/p/[token] '
        'and https://x.supabase.co/obj/a.jpg?[redacted]',
      );
    });

    test('masks tag tokens in API paths', () {
      expect(
        PiiScrubber.scrubString('GET /v1/tags/AbCdEfGhIjKlMnOpQrStUv 404'),
        'GET /v1/tags/[token] 404',
      );
    });

    test('leaves ordinary text alone', () {
      expect(PiiScrubber.scrubString('sync failed: 503'), 'sync failed: 503');
    });
  });

  test('scrubEvent drops user and request, scrubs message and exceptions', () {
    final event = SentryEvent(
      user: SentryUser(email: 'jane@example.com', name: 'Jane'),
      request: SentryRequest(url: 'https://plants.pampait.pl/p/AbC'),
      message: SentryMessage('Failed for jane@example.com'),
      exceptions: [SentryException(type: 'E', value: 'bad tag /p/QwErTy')],
      breadcrumbs: [
        Breadcrumb(message: 'go /p/QwErTy', data: {'displayName': 'Jane'}),
      ],
    );

    final out = PiiScrubber.scrubEvent(event, Hint());

    expect(out.user, isNull);
    expect(out.request, isNull);
    expect(out.message?.formatted, 'Failed for [email]');
    expect(out.exceptions!.single.value, 'bad tag /p/[token]');
    expect(out.breadcrumbs!.single.message, 'go /p/[token]');
    expect(out.breadcrumbs!.single.data, {'displayName': '[redacted]'});
  });

  test('scrubEvent tolerates an empty event', () {
    final out = PiiScrubber.scrubEvent(SentryEvent(), Hint());

    expect(out.message, isNull);
    expect(out.exceptions, isNull);
  });

  test('scrubBreadcrumb redacts sensitive keys and scrubs values', () {
    final crumb = Breadcrumb(
      message: 'GET https://plants.pampait.pl/p/Tok123',
      data: {
        'url': 'https://plants.pampait.pl/p/Tok123',
        'status_code': 200,
        'reason': 'by jane@example.com',
      },
    );

    final out = PiiScrubber.scrubBreadcrumb(crumb, Hint());

    expect(out.message, 'GET https://plants.pampait.pl/p/[token]');
    expect(out.data, {
      'url': '[redacted]',
      'status_code': 200,
      'reason': 'by [email]',
    });
  });

  test('scrubBreadcrumb tolerates null', () {
    expect(PiiScrubber.scrubBreadcrumb(null, Hint()).message, isNull);
  });
}
