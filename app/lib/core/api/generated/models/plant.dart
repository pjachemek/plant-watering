// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'photo_path.dart';
import 'timestamp.dart';
import 'uuid.dart';
import 'watering_amount.dart';
import 'watering_method.dart';

part 'plant.freezed.dart';
part 'plant.g.dart';

@Freezed()
abstract class Plant with _$Plant {
  const factory Plant({
    required Uuid id,
    @JsonKey(name: 'household_id') required Uuid householdId,
    @JsonKey(name: 'created_at') required Timestamp createdAt,
    @JsonKey(name: 'updated_at') required Timestamp updatedAt,
    String? nickname,
    @JsonKey(name: 'preset_id') String? presetId,
    @JsonKey(name: 'preset_version') int? presetVersion,
    String? room,
    @JsonKey(name: 'photo_path') PhotoPath? photoPath,
    @JsonKey(name: 'interval_summer_days') int? intervalSummerDays,
    @JsonKey(name: 'interval_winter_days') int? intervalWinterDays,
    WateringAmount? amount,
    WateringMethod? method,
    String? notes,
    @JsonKey(name: 'deleted_at') Timestamp? deletedAt,
  }) = _Plant;

  factory Plant.fromJson(Map<String, Object?> json) => _$PlantFromJson(json);
}
