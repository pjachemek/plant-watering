// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PushResult _$PushResultFromJson(Map<String, dynamic> json) => _PushResult(
  changeId: json['change_id'] as Uuid,
  status: PushResultStatus.fromJson(json['status'] as String),
  problem: json['problem'] == null
      ? null
      : Problem.fromJson(json['problem'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PushResultToJson(_PushResult instance) =>
    <String, dynamic>{
      'change_id': instance.changeId,
      'status': instance.status,
      'problem': ?instance.problem,
    };
