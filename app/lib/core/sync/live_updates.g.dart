// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_updates.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(liveTransport)
final liveTransportProvider = LiveTransportProvider._();

final class LiveTransportProvider
    extends $FunctionalProvider<LiveTransport, LiveTransport, LiveTransport>
    with $Provider<LiveTransport> {
  LiveTransportProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'liveTransportProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$liveTransportHash();

  @$internal
  @override
  $ProviderElement<LiveTransport> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LiveTransport create(Ref ref) {
    return liveTransport(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LiveTransport value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LiveTransport>(value),
    );
  }
}

String _$liveTransportHash() => r'cc473168e6b9e0eeb61c4a08f0fe8c922fdf5732';

/// The live-updates connection (ADR-0013, ADR-0020, ADR-0026): while the app
/// is open, signed in and in a household, one WebSocket to that household's
/// channel. Each "changed" signal runs a sync, so other phones' changes
/// show within seconds (FR-2, NFR Sync). The socket never carries data, and
/// it closes in the background (NFR Battery).

@ProviderFor(LiveUpdates)
final liveUpdatesProvider = LiveUpdatesProvider._();

/// The live-updates connection (ADR-0013, ADR-0020, ADR-0026): while the app
/// is open, signed in and in a household, one WebSocket to that household's
/// channel. Each "changed" signal runs a sync, so other phones' changes
/// show within seconds (FR-2, NFR Sync). The socket never carries data, and
/// it closes in the background (NFR Battery).
final class LiveUpdatesProvider
    extends $NotifierProvider<LiveUpdates, LiveStatus> {
  /// The live-updates connection (ADR-0013, ADR-0020, ADR-0026): while the app
  /// is open, signed in and in a household, one WebSocket to that household's
  /// channel. Each "changed" signal runs a sync, so other phones' changes
  /// show within seconds (FR-2, NFR Sync). The socket never carries data, and
  /// it closes in the background (NFR Battery).
  LiveUpdatesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'liveUpdatesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$liveUpdatesHash();

  @$internal
  @override
  LiveUpdates create() => LiveUpdates();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LiveStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LiveStatus>(value),
    );
  }
}

String _$liveUpdatesHash() => r'47bbfe40a14ed524057020deeaa4918ae2d99c54';

/// The live-updates connection (ADR-0013, ADR-0020, ADR-0026): while the app
/// is open, signed in and in a household, one WebSocket to that household's
/// channel. Each "changed" signal runs a sync, so other phones' changes
/// show within seconds (FR-2, NFR Sync). The socket never carries data, and
/// it closes in the background (NFR Battery).

abstract class _$LiveUpdates extends $Notifier<LiveStatus> {
  LiveStatus build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<LiveStatus, LiveStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LiveStatus, LiveStatus>,
              LiveStatus,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
