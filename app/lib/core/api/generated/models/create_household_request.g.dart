// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_household_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateHouseholdRequest _$CreateHouseholdRequestFromJson(
  Map<String, dynamic> json,
) => _CreateHouseholdRequest(
  name: json['name'] as String,
  displayName: json['display_name'] as String,
  hemisphere: json['hemisphere'] == null
      ? null
      : Hemisphere.fromJson(json['hemisphere'] as String),
);

Map<String, dynamic> _$CreateHouseholdRequestToJson(
  _CreateHouseholdRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'display_name': instance.displayName,
  'hemisphere': ?instance.hemisphere,
};
