// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PushRequest _$PushRequestFromJson(Map<String, dynamic> json) => _PushRequest(
  householdId: json['household_id'] as Uuid,
  changes: (json['changes'] as List<dynamic>)
      .map((e) => PushChange.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PushRequestToJson(_PushRequest instance) =>
    <String, dynamic>{
      'household_id': instance.householdId,
      'changes': instance.changes,
    };
