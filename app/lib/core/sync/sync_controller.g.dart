// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Writes changes made on this phone (ADR-0024).

@ProviderFor(localChanges)
final localChangesProvider = LocalChangesProvider._();

/// Writes changes made on this phone (ADR-0024).

final class LocalChangesProvider
    extends $FunctionalProvider<LocalChanges, LocalChanges, LocalChanges>
    with $Provider<LocalChanges> {
  /// Writes changes made on this phone (ADR-0024).
  LocalChangesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localChangesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localChangesHash();

  @$internal
  @override
  $ProviderElement<LocalChanges> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocalChanges create(Ref ref) {
    return localChanges(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalChanges value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalChanges>(value),
    );
  }
}

String _$localChangesHash() => r'cceaf5fe6b4167dd610bf362c5ef91cf4a89099f';

/// One sync pass for the signed-in user; tests override it.

@ProviderFor(syncRunner)
final syncRunnerProvider = SyncRunnerProvider._();

/// One sync pass for the signed-in user; tests override it.

final class SyncRunnerProvider
    extends
        $FunctionalProvider<
          Future<ApiFailure?> Function(String userId),
          Future<ApiFailure?> Function(String userId),
          Future<ApiFailure?> Function(String userId)
        >
    with $Provider<Future<ApiFailure?> Function(String userId)> {
  /// One sync pass for the signed-in user; tests override it.
  SyncRunnerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncRunnerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncRunnerHash();

  @$internal
  @override
  $ProviderElement<Future<ApiFailure?> Function(String userId)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Future<ApiFailure?> Function(String userId) create(Ref ref) {
    return syncRunner(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(
    Future<ApiFailure?> Function(String userId) value,
  ) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<Future<ApiFailure?> Function(String userId)>(
            value,
          ),
    );
  }
}

String _$syncRunnerHash() => r'634da3ae44ac520aceecd9ebe0260fd2632c2787';

/// How many changes wait in the outbox; tests override it.

@ProviderFor(outboxSize)
final outboxSizeProvider = OutboxSizeProvider._();

/// How many changes wait in the outbox; tests override it.

final class OutboxSizeProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  /// How many changes wait in the outbox; tests override it.
  OutboxSizeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'outboxSizeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$outboxSizeHash();

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    return outboxSize(ref);
  }
}

String _$outboxSizeHash() => r'a53c4f38ae585d64c242fb902043379bc8f07422';

/// Decides when the sync engine runs (AGENTS.md section 5, ADR-0025): on
/// sign-in, at start and on resume, and soon after a change is queued. No
/// polling (NFR Battery): failures are retried with backoff only while the
/// app is in the foreground. Live-update signals and tag scans call
/// [requestSync] too (2.10, M4).

@ProviderFor(SyncController)
final syncControllerProvider = SyncControllerProvider._();

/// Decides when the sync engine runs (AGENTS.md section 5, ADR-0025): on
/// sign-in, at start and on resume, and soon after a change is queued. No
/// polling (NFR Battery): failures are retried with backoff only while the
/// app is in the foreground. Live-update signals and tag scans call
/// [requestSync] too (2.10, M4).
final class SyncControllerProvider
    extends $NotifierProvider<SyncController, SyncStatus> {
  /// Decides when the sync engine runs (AGENTS.md section 5, ADR-0025): on
  /// sign-in, at start and on resume, and soon after a change is queued. No
  /// polling (NFR Battery): failures are retried with backoff only while the
  /// app is in the foreground. Live-update signals and tag scans call
  /// [requestSync] too (2.10, M4).
  SyncControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncControllerHash();

  @$internal
  @override
  SyncController create() => SyncController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncStatus>(value),
    );
  }
}

String _$syncControllerHash() => r'6e2144807709b404fa9500b33b303c9d38de753a';

/// Decides when the sync engine runs (AGENTS.md section 5, ADR-0025): on
/// sign-in, at start and on resume, and soon after a change is queued. No
/// polling (NFR Battery): failures are retried with backoff only while the
/// app is in the foreground. Live-update signals and tag scans call
/// [requestSync] too (2.10, M4).

abstract class _$SyncController extends $Notifier<SyncStatus> {
  SyncStatus build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SyncStatus, SyncStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SyncStatus, SyncStatus>,
              SyncStatus,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
