// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Tag _$TagFromJson(Map<String, dynamic> json) => _Tag(
  id: json['id'] as Uuid,
  householdId: json['household_id'] as Uuid,
  updatedAt: DateTime.parse(json['updated_at'] as String),
  token: json['token'] as TagToken?,
  plantId: json['plant_id'] as Uuid?,
  writtenAt: json['written_at'] == null
      ? null
      : DateTime.parse(json['written_at'] as String),
  writtenBy: json['written_by'] as Uuid?,
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
);

Map<String, dynamic> _$TagToJson(_Tag instance) => <String, dynamic>{
  'id': instance.id,
  'household_id': instance.householdId,
  'updated_at': instance.updatedAt.toIso8601String(),
  'token': ?instance.token,
  'plant_id': ?instance.plantId,
  'written_at': ?instance.writtenAt?.toIso8601String(),
  'written_by': ?instance.writtenBy,
  'deleted_at': ?instance.deletedAt?.toIso8601String(),
};
