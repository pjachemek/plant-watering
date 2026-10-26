// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nfc_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The platform NFC service. Tests override this with a fake.

@ProviderFor(nfcService)
final nfcServiceProvider = NfcServiceProvider._();

/// The platform NFC service. Tests override this with a fake.

final class NfcServiceProvider
    extends $FunctionalProvider<NfcService, NfcService, NfcService>
    with $Provider<NfcService> {
  /// The platform NFC service. Tests override this with a fake.
  NfcServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nfcServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nfcServiceHash();

  @$internal
  @override
  $ProviderElement<NfcService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NfcService create(Ref ref) {
    return nfcService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NfcService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NfcService>(value),
    );
  }
}

String _$nfcServiceHash() => r'5c265f1e4768da7e6fd9585f4674fad41b4dd983';

/// Whether NFC is usable right now. Refresh it when the app resumes, because
/// the user may have turned NFC on in settings.

@ProviderFor(nfcAvailability)
final nfcAvailabilityProvider = NfcAvailabilityProvider._();

/// Whether NFC is usable right now. Refresh it when the app resumes, because
/// the user may have turned NFC on in settings.

final class NfcAvailabilityProvider
    extends
        $FunctionalProvider<
          AsyncValue<NfcAvailability>,
          NfcAvailability,
          FutureOr<NfcAvailability>
        >
    with $FutureModifier<NfcAvailability>, $FutureProvider<NfcAvailability> {
  /// Whether NFC is usable right now. Refresh it when the app resumes, because
  /// the user may have turned NFC on in settings.
  NfcAvailabilityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nfcAvailabilityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nfcAvailabilityHash();

  @$internal
  @override
  $FutureProviderElement<NfcAvailability> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<NfcAvailability> create(Ref ref) {
    return nfcAvailability(ref);
  }
}

String _$nfcAvailabilityHash() => r'5c678e2b26529399acd8752e91e33709f4777fdc';
