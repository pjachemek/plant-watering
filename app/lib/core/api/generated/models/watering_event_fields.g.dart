// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watering_event_fields.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WateringEventFields _$WateringEventFieldsFromJson(Map<String, dynamic> json) =>
    _WateringEventFields(
      plantId: json['plant_id'] as Uuid,
      wateredAt: DateTime.parse(json['watered_at'] as String),
      source: WateringSource.fromJson(json['source'] as String),
    );

Map<String, dynamic> _$WateringEventFieldsToJson(
  _WateringEventFields instance,
) => <String, dynamic>{
  'plant_id': instance.plantId,
  'watered_at': instance.wateredAt.toIso8601String(),
  'source': instance.source,
};
