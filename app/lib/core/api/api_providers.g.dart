// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The HTTP client for the versioned API, the app's only backend (ADR-0012).
/// Every request carries the version headers and, when signed in, the
/// access token; a 426 switches the app to its update screen (FR-10).

@ProviderFor(apiDio)
final apiDioProvider = ApiDioProvider._();

/// The HTTP client for the versioned API, the app's only backend (ADR-0012).
/// Every request carries the version headers and, when signed in, the
/// access token; a 426 switches the app to its update screen (FR-10).

final class ApiDioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// The HTTP client for the versioned API, the app's only backend (ADR-0012).
  /// Every request carries the version headers and, when signed in, the
  /// access token; a 426 switches the app to its update screen (FR-10).
  ApiDioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiDioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiDioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return apiDio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$apiDioHash() => r'7d976329a8898dbb17f9888181335e1769857e2f';

/// The generated client (ADR-0015) on [apiDio].

@ProviderFor(plantApi)
final plantApiProvider = PlantApiProvider._();

/// The generated client (ADR-0015) on [apiDio].

final class PlantApiProvider
    extends $FunctionalProvider<PlantApiClient, PlantApiClient, PlantApiClient>
    with $Provider<PlantApiClient> {
  /// The generated client (ADR-0015) on [apiDio].
  PlantApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'plantApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plantApiHash();

  @$internal
  @override
  $ProviderElement<PlantApiClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PlantApiClient create(Ref ref) {
    return plantApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlantApiClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlantApiClient>(value),
    );
  }
}

String _$plantApiHash() => r'75c3f1d70a3e6c22473401ac2af09fa4b5bd74c5';
