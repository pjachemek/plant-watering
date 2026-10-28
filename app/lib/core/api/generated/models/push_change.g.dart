// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_change.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PushChange _$PushChangeFromJson(Map<String, dynamic> json) => _PushChange(
  changeId: json['change_id'] as Uuid,
  entity: SyncEntity.fromJson(json['entity'] as String),
  op: SyncOp.fromJson(json['op'] as String),
  id: json['id'] as Uuid,
  fields: (json['fields'] as List<dynamic>?)?.map((e) => e as String).toList(),
  household: json['household'] == null
      ? null
      : HouseholdFields.fromJson(json['household'] as Map<String, dynamic>),
  plant: json['plant'] == null
      ? null
      : PlantFields.fromJson(json['plant'] as Map<String, dynamic>),
  tag: json['tag'] == null
      ? null
      : TagFields.fromJson(json['tag'] as Map<String, dynamic>),
  wateringEvent: json['watering_event'] == null
      ? null
      : WateringEventFields.fromJson(
          json['watering_event'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$PushChangeToJson(_PushChange instance) =>
    <String, dynamic>{
      'change_id': instance.changeId,
      'entity': instance.entity,
      'op': instance.op,
      'id': instance.id,
      'fields': ?instance.fields,
      'household': ?instance.household,
      'plant': ?instance.plant,
      'tag': ?instance.tag,
      'watering_event': ?instance.wateringEvent,
    };
