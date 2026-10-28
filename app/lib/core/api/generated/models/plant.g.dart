// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Plant _$PlantFromJson(Map<String, dynamic> json) => _Plant(
  id: json['id'] as Uuid,
  householdId: json['household_id'] as Uuid,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  nickname: json['nickname'] as String?,
  presetId: json['preset_id'] as String?,
  presetVersion: (json['preset_version'] as num?)?.toInt(),
  room: json['room'] as String?,
  photoPath: json['photo_path'] as PhotoPath?,
  intervalSummerDays: (json['interval_summer_days'] as num?)?.toInt(),
  intervalWinterDays: (json['interval_winter_days'] as num?)?.toInt(),
  amount: json['amount'] == null
      ? null
      : WateringAmount.fromJson(json['amount'] as String),
  method: json['method'] == null
      ? null
      : WateringMethod.fromJson(json['method'] as String),
  notes: json['notes'] as String?,
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
);

Map<String, dynamic> _$PlantToJson(_Plant instance) => <String, dynamic>{
  'id': instance.id,
  'household_id': instance.householdId,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'nickname': ?instance.nickname,
  'preset_id': ?instance.presetId,
  'preset_version': ?instance.presetVersion,
  'room': ?instance.room,
  'photo_path': ?instance.photoPath,
  'interval_summer_days': ?instance.intervalSummerDays,
  'interval_winter_days': ?instance.intervalWinterDays,
  'amount': ?instance.amount,
  'method': ?instance.method,
  'notes': ?instance.notes,
  'deleted_at': ?instance.deletedAt?.toIso8601String(),
};
