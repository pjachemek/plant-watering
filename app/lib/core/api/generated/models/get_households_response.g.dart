// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_households_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GetHouseholdsResponse _$GetHouseholdsResponseFromJson(
  Map<String, dynamic> json,
) => _GetHouseholdsResponse(
  households: (json['households'] as List<dynamic>)
      .map((e) => Household.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GetHouseholdsResponseToJson(
  _GetHouseholdsResponse instance,
) => <String, dynamic>{'households': instance.households};
