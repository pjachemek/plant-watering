// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'household_fields.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HouseholdFields _$HouseholdFieldsFromJson(Map<String, dynamic> json) =>
    _HouseholdFields(
      name: json['name'] as String?,
      publicCardsEnabled: json['public_cards_enabled'] as bool?,
      hemisphere: json['hemisphere'] == null
          ? null
          : Hemisphere.fromJson(json['hemisphere'] as String),
    );

Map<String, dynamic> _$HouseholdFieldsToJson(_HouseholdFields instance) =>
    <String, dynamic>{
      'name': ?instance.name,
      'public_cards_enabled': ?instance.publicCardsEnabled,
      'hemisphere': ?instance.hemisphere,
    };
