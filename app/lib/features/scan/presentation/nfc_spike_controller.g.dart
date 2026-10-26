// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nfc_spike_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Drives the M1 spike screen: write a fresh test link to a sticker, or read
/// one. All tag logic lives in [NfcService]; this only tracks UI state.

@ProviderFor(NfcSpikeController)
final nfcSpikeControllerProvider = NfcSpikeControllerProvider._();

/// Drives the M1 spike screen: write a fresh test link to a sticker, or read
/// one. All tag logic lives in [NfcService]; this only tracks UI state.
final class NfcSpikeControllerProvider
    extends $NotifierProvider<NfcSpikeController, NfcSpikeState> {
  /// Drives the M1 spike screen: write a fresh test link to a sticker, or read
  /// one. All tag logic lives in [NfcService]; this only tracks UI state.
  NfcSpikeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nfcSpikeControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nfcSpikeControllerHash();

  @$internal
  @override
  NfcSpikeController create() => NfcSpikeController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NfcSpikeState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NfcSpikeState>(value),
    );
  }
}

String _$nfcSpikeControllerHash() =>
    r'83c3542a9f41bfab372dc217c0944d10320b83c6';

/// Drives the M1 spike screen: write a fresh test link to a sticker, or read
/// one. All tag logic lives in [NfcService]; this only tracks UI state.

abstract class _$NfcSpikeController extends $Notifier<NfcSpikeState> {
  NfcSpikeState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<NfcSpikeState, NfcSpikeState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NfcSpikeState, NfcSpikeState>,
              NfcSpikeState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
