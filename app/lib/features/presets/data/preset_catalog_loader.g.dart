// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preset_catalog_loader.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The bundled presets, loaded once.

@ProviderFor(presetCatalog)
final presetCatalogProvider = PresetCatalogProvider._();

/// The bundled presets, loaded once.

final class PresetCatalogProvider
    extends
        $FunctionalProvider<
          AsyncValue<PresetCatalog>,
          PresetCatalog,
          FutureOr<PresetCatalog>
        >
    with $FutureModifier<PresetCatalog>, $FutureProvider<PresetCatalog> {
  /// The bundled presets, loaded once.
  PresetCatalogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'presetCatalogProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$presetCatalogHash();

  @$internal
  @override
  $FutureProviderElement<PresetCatalog> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PresetCatalog> create(Ref ref) {
    return presetCatalog(ref);
  }
}

String _$presetCatalogHash() => r'85f697039013cc441304ddb2a96fc420d684199b';

/// Search over the bundled presets, built once.

@ProviderFor(presetSearch)
final presetSearchProvider = PresetSearchProvider._();

/// Search over the bundled presets, built once.

final class PresetSearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<PresetSearch>,
          PresetSearch,
          FutureOr<PresetSearch>
        >
    with $FutureModifier<PresetSearch>, $FutureProvider<PresetSearch> {
  /// Search over the bundled presets, built once.
  PresetSearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'presetSearchProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$presetSearchHash();

  @$internal
  @override
  $FutureProviderElement<PresetSearch> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PresetSearch> create(Ref ref) {
    return presetSearch(ref);
  }
}

String _$presetSearchHash() => r'5a76fbee6270c80f414dcb92109ce1c5b2cd3645';
