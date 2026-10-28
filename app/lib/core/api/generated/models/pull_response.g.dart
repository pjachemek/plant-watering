// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pull_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PullResponse _$PullResponseFromJson(Map<String, dynamic> json) =>
    _PullResponse(
      cursor: json['cursor'] as Cursor,
      household: Household.fromJson(json['household'] as Map<String, dynamic>),
      members: (json['members'] as List<dynamic>)
          .map((e) => Member.fromJson(e as Map<String, dynamic>))
          .toList(),
      plants: (json['plants'] as List<dynamic>)
          .map((e) => Plant.fromJson(e as Map<String, dynamic>))
          .toList(),
      tags: (json['tags'] as List<dynamic>)
          .map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList(),
      wateringEvents: (json['watering_events'] as List<dynamic>)
          .map((e) => WateringEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PullResponseToJson(_PullResponse instance) =>
    <String, dynamic>{
      'cursor': instance.cursor,
      'household': instance.household,
      'members': instance.members,
      'plants': instance.plants,
      'tags': instance.tags,
      'watering_events': instance.wateringEvents,
    };
