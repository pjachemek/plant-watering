// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watering_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WateringEvent _$WateringEventFromJson(Map<String, dynamic> json) =>
    _WateringEvent(
      plantId: json['plant_id'] as Uuid,
      wateredAt: DateTime.parse(json['watered_at'] as String),
      source: WateringSource.fromJson(json['source'] as String),
      id: json['id'] as Uuid,
      householdId: json['household_id'] as Uuid,
      createdAt: DateTime.parse(json['created_at'] as String),
      userId: json['user_id'] as Uuid?,
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
    );

Map<String, dynamic> _$WateringEventToJson(_WateringEvent instance) =>
    <String, dynamic>{
      'plant_id': instance.plantId,
      'watered_at': instance.wateredAt.toIso8601String(),
      'source': instance.source,
      'id': instance.id,
      'household_id': instance.householdId,
      'created_at': instance.createdAt.toIso8601String(),
      'user_id': ?instance.userId,
      'deleted_at': ?instance.deletedAt?.toIso8601String(),
    };
