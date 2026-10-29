// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_version_policy_source.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Tests override this with a fake.

@ProviderFor(versionPolicySource)
final versionPolicySourceProvider = VersionPolicySourceProvider._();

/// Tests override this with a fake.

final class VersionPolicySourceProvider
    extends
        $FunctionalProvider<
          VersionPolicySource,
          VersionPolicySource,
          VersionPolicySource
        >
    with $Provider<VersionPolicySource> {
  /// Tests override this with a fake.
  VersionPolicySourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'versionPolicySourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$versionPolicySourceHash();

  @$internal
  @override
  $ProviderElement<VersionPolicySource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  VersionPolicySource create(Ref ref) {
    return versionPolicySource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VersionPolicySource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VersionPolicySource>(value),
    );
  }
}

String _$versionPolicySourceHash() =>
    r'81edd3b9afa75cd30a06ce2a28a68a5fa7de8d78';
