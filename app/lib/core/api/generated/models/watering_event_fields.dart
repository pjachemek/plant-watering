// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'timestamp.dart';
import 'uuid.dart';
import 'watering_source.dart';

part 'watering_event_fields.freezed.dart';
part 'watering_event_fields.g.dart';

@Freezed()
abstract class WateringEventFields with _$WateringEventFields {
  const factory WateringEventFields({
    @JsonKey(name: 'plant_id') required Uuid plantId,
    @JsonKey(name: 'watered_at') required Timestamp wateredAt,
    required WateringSource source,
  }) = _WateringEventFields;

  factory WateringEventFields.fromJson(Map<String, Object?> json) =>
      _$WateringEventFieldsFromJson(json);
}
