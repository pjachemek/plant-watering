// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Member _$MemberFromJson(Map<String, dynamic> json) => _Member(
  id: json['id'] as Uuid,
  householdId: json['household_id'] as Uuid,
  userId: json['user_id'] as Uuid,
  displayName: json['display_name'] as String,
  joinedAt: DateTime.parse(json['joined_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
);

Map<String, dynamic> _$MemberToJson(_Member instance) => <String, dynamic>{
  'id': instance.id,
  'household_id': instance.householdId,
  'user_id': instance.userId,
  'display_name': instance.displayName,
  'joined_at': instance.joinedAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'deleted_at': ?instance.deletedAt?.toIso8601String(),
};
