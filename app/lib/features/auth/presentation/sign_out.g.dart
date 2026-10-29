// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_out.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Signs out and removes this account's household data from the phone, so
/// the next person to sign in here never sees it (ADR-0024, ADR-0026).
/// Tests override it.

@ProviderFor(signOutAndClear)
final signOutAndClearProvider = SignOutAndClearProvider._();

/// Signs out and removes this account's household data from the phone, so
/// the next person to sign in here never sees it (ADR-0024, ADR-0026).
/// Tests override it.

final class SignOutAndClearProvider
    extends
        $FunctionalProvider<
          Future<void> Function(),
          Future<void> Function(),
          Future<void> Function()
        >
    with $Provider<Future<void> Function()> {
  /// Signs out and removes this account's household data from the phone, so
  /// the next person to sign in here never sees it (ADR-0024, ADR-0026).
  /// Tests override it.
  SignOutAndClearProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signOutAndClearProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signOutAndClearHash();

  @$internal
  @override
  $ProviderElement<Future<void> Function()> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Future<void> Function() create(Ref ref) {
    return signOutAndClear(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Future<void> Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Future<void> Function()>(value),
    );
  }
}

String _$signOutAndClearHash() => r'ec0cd35749c496169c1f5a38cd1d8913c037f43b';
