// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_fields.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TagFields _$TagFieldsFromJson(Map<String, dynamic> json) => _TagFields(
  token: json['token'] as TagToken?,
  plantId: json['plant_id'] as Uuid?,
  writtenAt: json['written_at'] == null
      ? null
      : DateTime.parse(json['written_at'] as String),
);

Map<String, dynamic> _$TagFieldsToJson(_TagFields instance) =>
    <String, dynamic>{
      'token': ?instance.token,
      'plant_id': ?instance.plantId,
      'written_at': ?instance.writtenAt?.toIso8601String(),
    };
