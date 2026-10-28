// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'hemisphere.dart';

part 'household_fields.freezed.dart';
part 'household_fields.g.dart';

@Freezed()
abstract class HouseholdFields with _$HouseholdFields {
  const factory HouseholdFields({
    String? name,
    @JsonKey(name: 'public_cards_enabled') bool? publicCardsEnabled,
    Hemisphere? hemisphere,
  }) = _HouseholdFields;

  factory HouseholdFields.fromJson(Map<String, Object?> json) =>
      _$HouseholdFieldsFromJson(json);
}
