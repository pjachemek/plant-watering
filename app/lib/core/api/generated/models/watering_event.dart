// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'timestamp.dart';
import 'uuid.dart';
import 'watering_source.dart';

part 'watering_event.freezed.dart';
part 'watering_event.g.dart';

@Freezed()
abstract class WateringEvent with _$WateringEvent {
  const factory WateringEvent({
    @JsonKey(name: 'plant_id') required Uuid plantId,
    @JsonKey(name: 'watered_at') required Timestamp wateredAt,
    required WateringSource source,
    required Uuid id,
    @JsonKey(name: 'household_id') required Uuid householdId,
    @JsonKey(name: 'created_at') required Timestamp createdAt,

    /// Null after the author deleted their account.
    @JsonKey(name: 'user_id') Uuid? userId,

    /// Set when the watering was undone.
    @JsonKey(name: 'deleted_at') Timestamp? deletedAt,
  }) = _WateringEvent;

  factory WateringEvent.fromJson(Map<String, Object?> json) =>
      _$WateringEventFromJson(json);
}
