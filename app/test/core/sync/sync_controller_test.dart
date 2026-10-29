import 'dart:async';
import 'dart:math';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantnfc/core/api/api_failure.dart';
import 'package:plantnfc/core/sync/sync_controller.dart';
import 'package:plantnfc/features/auth/data/auth_providers.dart';
import 'package:plantnfc/features/auth/domain/auth_status.dart';

import '../../helpers/fake_auth_repository.dart';

void main() {
  late FakeAuthRepository auth;
  late List<ApiFailure?> answers;
  late int runs;
  late StreamController<int> outbox;

  ProviderContainer start() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(auth),
        syncRunnerProvider.overrideWithValue((_) async {
          runs++;
          return answers.isEmpty ? null : answers.removeAt(0);
        }),
        outboxSizeProvider.overrideWith((ref) => outbox.stream),
      ],
    );
    addTearDown(container.dispose);
    // Listened, as the app does: an unlistened provider is paused.
    container.listen(syncControllerProvider, (_, _) {});
    return container;
  }

  setUp(() {
    auth = FakeAuthRepository();
    answers = [];
    runs = 0;
    outbox = StreamController<int>.broadcast();
  });

  test('backs off from 2 s, doubling, up to 5 minutes, with jitter', () {
    final r = Random(1);
    Duration at(int failures) => SyncController.backoff(failures, r);

    expect(at(1).inMilliseconds, inInclusiveRange(1600, 2400));
    expect(at(3).inMilliseconds, inInclusiveRange(6400, 9600));
    expect(at(20).inSeconds, inInclusiveRange(240, 360));
  });

  test('syncs on start when signed in, and not when signed out', () {
    fakeAsync((time) {
      start();
      time.flushMicrotasks();
      expect(runs, 1);
    });

    fakeAsync((time) {
      runs = 0;
      auth = FakeAuthRepository(signedIn: false);
      start();
      time.elapse(const Duration(minutes: 1));
      expect(runs, 0);

      auth.setStatus(const SignedIn(FakeAuthRepository.userId));
      time.flushMicrotasks();
      expect(runs, 1);
    });
  });

  test('retries a lost connection with backoff, then settles', () {
    fakeAsync((time) {
      answers = [ApiFailure.network, ApiFailure.network];
      final container = start();
      time.flushMicrotasks();
      expect(container.read(syncControllerProvider), SyncStatus.waitingToRetry);

      time.elapse(const Duration(seconds: 3)); // first retry after ~2 s
      expect(runs, 2);
      time.elapse(const Duration(seconds: 5)); // second after ~4 s
      expect(runs, 3);
      expect(container.read(syncControllerProvider), SyncStatus.idle);

      time.elapse(const Duration(hours: 1));
      expect(runs, 3); // no polling once in step
    });
  });

  test('stops when sign-in or an update is needed', () {
    for (final failure in [
      ApiFailure.unauthorized,
      ApiFailure.upgradeRequired,
    ]) {
      fakeAsync((time) {
        runs = 0;
        answers = [failure];
        final container = start();
        time.elapse(const Duration(hours: 1));
        expect(runs, 1);
        expect(container.read(syncControllerProvider), SyncStatus.stopped);
      });
    }
  });

  test('does not retry in the background; syncs again on resume', () {
    fakeAsync((time) {
      answers = [ApiFailure.network];
      final container = start();
      time.flushMicrotasks();

      container.read(syncControllerProvider.notifier).appPaused();
      time.elapse(const Duration(hours: 1));
      expect(runs, 1);

      container.read(syncControllerProvider.notifier).appResumed();
      time.flushMicrotasks();
      expect(runs, 2);
    });
  });

  test('a newly queued change syncs soon, grouped with quick follow-ups', () {
    fakeAsync((time) {
      start();
      time.flushMicrotasks();
      expect(runs, 1);

      outbox.add(1);
      time.elapse(const Duration(milliseconds: 100));
      outbox.add(2);
      time.elapse(const Duration(milliseconds: 100));
      expect(runs, 1);
      time.elapse(const Duration(milliseconds: 500));
      expect(runs, 2);

      // A failed pass rewrites the outbox (attempts): no new sync for that.
      outbox.add(2);
      time.elapse(const Duration(seconds: 1));
      expect(runs, 2);
    });
  });

  test('signing out stops retries', () {
    fakeAsync((time) {
      answers = [ApiFailure.network];
      final container = start();
      time.flushMicrotasks();

      auth.setStatus(const SignedOut());
      time.elapse(const Duration(hours: 1));

      expect(runs, 1);
      expect(container.read(syncControllerProvider), SyncStatus.stopped);
    });
  });
}
