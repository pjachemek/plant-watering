// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'household.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Household _$HouseholdFromJson(Map<String, dynamic> json) => _Household(
  id: json['id'] as Uuid,
  name: json['name'] as String,
  publicCardsEnabled: json['public_cards_enabled'] as bool,
  hemisphere: Hemisphere.fromJson(json['hemisphere'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
);

Map<String, dynamic> _$HouseholdToJson(_Household instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'public_cards_enabled': instance.publicCardsEnabled,
      'hemisphere': instance.hemisphere,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'deleted_at': ?instance.deletedAt?.toIso8601String(),
    };
