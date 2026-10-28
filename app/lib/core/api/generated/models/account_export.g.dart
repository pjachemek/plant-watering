// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_export.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountExport _$AccountExportFromJson(Map<String, dynamic> json) =>
    _AccountExport(
      exportedAt: DateTime.parse(json['exported_at'] as String),
      userId: json['user_id'] as Uuid,
      households: (json['households'] as List<dynamic>)
          .map((e) => Household.fromJson(e as Map<String, dynamic>))
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

Map<String, dynamic> _$AccountExportToJson(_AccountExport instance) =>
    <String, dynamic>{
      'exported_at': instance.exportedAt.toIso8601String(),
      'user_id': instance.userId,
      'households': instance.households,
      'plants': instance.plants,
      'tags': instance.tags,
      'watering_events': instance.wateringEvents,
    };
