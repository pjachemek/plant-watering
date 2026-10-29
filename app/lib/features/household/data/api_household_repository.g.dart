// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_household_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Tests override this with a fake.

@ProviderFor(householdRepository)
final householdRepositoryProvider = HouseholdRepositoryProvider._();

/// Tests override this with a fake.

final class HouseholdRepositoryProvider
    extends
        $FunctionalProvider<
          HouseholdRepository,
          HouseholdRepository,
          HouseholdRepository
        >
    with $Provider<HouseholdRepository> {
  /// Tests override this with a fake.
  HouseholdRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'householdRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$householdRepositoryHash();

  @$internal
  @override
  $ProviderElement<HouseholdRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HouseholdRepository create(Ref ref) {
    return householdRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HouseholdRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HouseholdRepository>(value),
    );
  }
}

String _$householdRepositoryHash() =>
    r'04c17d4939df5b1f4eacc685712c6dce9252eee5';

/// The household on this phone, live.

@ProviderFor(currentHousehold)
final currentHouseholdProvider = CurrentHouseholdProvider._();

/// The household on this phone, live.

final class CurrentHouseholdProvider
    extends
        $FunctionalProvider<
          AsyncValue<HouseholdSummary?>,
          HouseholdSummary?,
          Stream<HouseholdSummary?>
        >
    with
        $FutureModifier<HouseholdSummary?>,
        $StreamProvider<HouseholdSummary?> {
  /// The household on this phone, live.
  CurrentHouseholdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentHouseholdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentHouseholdHash();

  @$internal
  @override
  $StreamProviderElement<HouseholdSummary?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<HouseholdSummary?> create(Ref ref) {
    return currentHousehold(ref);
  }
}

String _$currentHouseholdHash() => r'6e66a28cbf12edb3151a44da62145f3d3e55361b';
