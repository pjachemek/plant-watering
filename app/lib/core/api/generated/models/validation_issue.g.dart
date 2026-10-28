// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validation_issue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ValidationIssue _$ValidationIssueFromJson(Map<String, dynamic> json) =>
    _ValidationIssue(
      location: ValidationIssueLocation.fromJson(json['location'] as String),
      pointer: json['pointer'] as String,
      code: json['code'] as String,
    );

Map<String, dynamic> _$ValidationIssueToJson(_ValidationIssue instance) =>
    <String, dynamic>{
      'location': instance.location,
      'pointer': instance.pointer,
      'code': instance.code,
    };
