// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_fields.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlantFields _$PlantFieldsFromJson(Map<String, dynamic> json) => _PlantFields(
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
);

Map<String, dynamic> _$PlantFieldsToJson(_PlantFields instance) =>
    <String, dynamic>{
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
    };
