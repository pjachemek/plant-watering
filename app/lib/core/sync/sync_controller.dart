import 'dart:async';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:plantnfc/core/api/api_failure.dart';
import 'package:plantnfc/core/api/api_providers.dart';
import 'package:plantnfc/core/database/app_database.dart';
import 'package:plantnfc/core/database/local_changes.dart';
import 'package:plantnfc/core/sync/sync_engine.dart';
import 'package:plantnfc/features/auth/data/auth_providers.dart';
import 'package:plantnfc/features/auth/domain/auth_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_controller.g.dart';

/// Where syncing stands, for the UI (for example an offline note).
enum SyncStatus {
  /// Nothing running; the last pass succeeded or none was needed yet.
  idle,
  syncing,

  /// The last pass couldn't reach the server; it is retried with backoff
  /// while the app is open. Everything stays queued on the phone.
  waitingToRetry,

  /// Signed out, or this version must be updated: nothing is sent.
  stopped,
}

/// Writes changes made on this phone (ADR-0024).
@Riverpod(keepAlive: true)
LocalChanges localChanges(Ref ref) =>
    LocalChanges(ref.watch(appDatabaseProvider));

/// One sync pass for the signed-in user; tests override it.
@Riverpod(keepAlive: true)
Future<ApiFailure?> Function(String userId) syncRunner(Ref ref) {
  final engine = SyncEngine(
    db: ref.watch(appDatabaseProvider),
    api: ref.watch(plantApiProvider),
    changes: ref.watch(localChangesProvider),
  );
  return (userId) => engine.syncAll(userId: userId);
}

/// How many changes wait in the outbox; tests override it.
@Riverpod(keepAlive: true)
Stream<int> outboxSize(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final count = db.outbox.seq.count();
  return (db.selectOnly(
    db.outbox,
  )..addColumns([count])).watchSingle().map((row) => row.read(count) ?? 0);
}

/// Decides when the sync engine runs (AGENTS.md section 5, ADR-0025): on
/// sign-in, at start and on resume, and soon after a change is queued. No
/// polling (NFR Battery): failures are retried with backoff only while the
/// app is in the foreground. Live-update signals and tag scans call
/// [requestSync] too (2.10, M4).
@Riverpod(keepAlive: true)
class SyncController extends _$SyncController {
  Timer? _debounce;
  Timer? _retry;
  bool _running = false;
  bool _again = false;
  bool _foreground = true;
  int _failures = 0;
  int _queued = 0;
  final Random _random = Random();

  /// Enough doublings to reach the 5-minute ceiling.
  static const int _maxFailures = 9;

  /// How long to wait before asking the server again after [failures]
  /// failed passes: 2 s doubling to 5 min, with ±20% jitter.
  static Duration backoff(int failures, [Random? random]) {
    final base = min(2 * pow(2, max(0, failures - 1)), 300).toDouble();
    final jitter = 0.8 + (random ?? Random()).nextDouble() * 0.4;
    return Duration(milliseconds: (base * jitter * 1000).round());
  }

  @override
  SyncStatus build() {
    final auth = ref.watch(authRepositoryProvider);
    final authChanges = auth.statusChanges.listen((status) {
      if (status is SignedIn) {
        requestSync();
      } else {
        _stop();
      }
    });
    ref
      ..listen(outboxSizeProvider, (_, next) {
        final size = next.value ?? 0;
        // Only new entries: a failed pass also writes the outbox (attempts),
        // and must wait for its backoff.
        if (size > _queued) requestSync(soon: true);
        _queued = size;
      })
      ..onDispose(() {
        unawaited(authChanges.cancel());
        _cancelTimers();
      });
    if (auth.status is SignedIn) unawaited(Future.microtask(requestSync));
    return SyncStatus.idle;
  }

  /// Runs a pass now, or after a short pause when [soon] (to group quick
  /// changes into one push). A request during a pass runs another after it.
  void requestSync({bool soon = false}) {
    if (ref.read(authRepositoryProvider).status is! SignedIn) return;
    _debounce?.cancel();
    if (soon) {
      _debounce = Timer(const Duration(milliseconds: 400), _start);
    } else {
      _start();
    }
  }

  /// The app went to the background: stop retrying (NFR Battery).
  void appPaused() {
    _foreground = false;
    _cancelTimers();
  }

  /// Back in the foreground: sync at once.
  void appResumed() {
    _foreground = true;
    requestSync();
  }

  void _start() {
    if (_running) {
      _again = true;
      return;
    }
    _retry?.cancel();
    unawaited(_run());
  }

  Future<void> _run() async {
    final status = ref.read(authRepositoryProvider).status;
    if (status is! SignedIn) return;
    _running = true;
    state = SyncStatus.syncing;
    final failure = await ref.read(syncRunnerProvider)(status.userId);
    _running = false;
    if (!ref.mounted) return;
    switch (failure) {
      case null:
        _failures = 0;
        state = SyncStatus.idle;
      case ApiFailure.unauthorized || ApiFailure.upgradeRequired:
        // Needs the person (sign in again, update the app); retrying won't
        // help. Changes stay queued.
        state = SyncStatus.stopped;
      case ApiFailure.badRequest:
        // A batch the API calls malformed is a bug in this app. It stays
        // queued (never dropped) and is retried at the longest interval.
        _failures = _maxFailures;
        _scheduleRetry();
      case ApiFailure.network ||
          ApiFailure.server ||
          ApiFailure.rateLimited ||
          ApiFailure.notFound ||
          ApiFailure.conflict:
        _failures = min(_failures + 1, _maxFailures);
        _scheduleRetry();
    }
    if (_again) {
      _again = false;
      _start();
    }
  }

  void _scheduleRetry() {
    state = SyncStatus.waitingToRetry;
    if (_foreground) _retry = Timer(backoff(_failures, _random), _start);
  }

  void _stop() {
    _cancelTimers();
    _failures = 0;
    state = SyncStatus.stopped;
  }

  void _cancelTimers() {
    _debounce?.cancel();
    _retry?.cancel();
  }
}
