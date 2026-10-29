// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_update_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether this app version may still be used (FR-10). Checked at start and
/// on resume, and set at once when the API answers 426. Nothing entered
/// offline is touched: it stays queued and syncs after the update.

@ProviderFor(AppUpdateController)
final appUpdateControllerProvider = AppUpdateControllerProvider._();

/// Whether this app version may still be used (FR-10). Checked at start and
/// on resume, and set at once when the API answers 426. Nothing entered
/// offline is touched: it stays queued and syncs after the update.
final class AppUpdateControllerProvider
    extends $NotifierProvider<AppUpdateController, AppUpdateState> {
  /// Whether this app version may still be used (FR-10). Checked at start and
  /// on resume, and set at once when the API answers 426. Nothing entered
  /// offline is touched: it stays queued and syncs after the update.
  AppUpdateControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appUpdateControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appUpdateControllerHash();

  @$internal
  @override
  AppUpdateController create() => AppUpdateController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppUpdateState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppUpdateState>(value),
    );
  }
}

String _$appUpdateControllerHash() =>
    r'b8e6f209f73898f4dcb6a61c2969f219ef65af40';

/// Whether this app version may still be used (FR-10). Checked at start and
/// on resume, and set at once when the API answers 426. Nothing entered
/// offline is touched: it stays queued and syncs after the update.

abstract class _$AppUpdateController extends $Notifier<AppUpdateState> {
  AppUpdateState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AppUpdateState, AppUpdateState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppUpdateState, AppUpdateState>,
              AppUpdateState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Opens [storeListing] in the Play Store app (or the browser). Tests
/// override this.

@ProviderFor(openStore)
final openStoreProvider = OpenStoreProvider._();

/// Opens [storeListing] in the Play Store app (or the browser). Tests
/// override this.

final class OpenStoreProvider
    extends
        $FunctionalProvider<
          Future<bool> Function(),
          Future<bool> Function(),
          Future<bool> Function()
        >
    with $Provider<Future<bool> Function()> {
  /// Opens [storeListing] in the Play Store app (or the browser). Tests
  /// override this.
  OpenStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'openStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$openStoreHash();

  @$internal
  @override
  $ProviderElement<Future<bool> Function()> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Future<bool> Function() create(Ref ref) {
    return openStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Future<bool> Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Future<bool> Function()>(value),
    );
  }
}

String _$openStoreHash() => r'2a70a64822bd85d901d599d76ff96ebdce60efb1';
