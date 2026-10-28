// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'photo_path.dart';
import 'watering_amount.dart';
import 'watering_method.dart';

part 'plant_fields.freezed.dart';
part 'plant_fields.g.dart';

/// Plant fields a client may set. In a patch, only present fields change.
@Freezed()
abstract class PlantFields with _$PlantFields {
  const factory PlantFields({
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
  }) = _PlantFields;

  factory PlantFields.fromJson(Map<String, Object?> json) =>
      _$PlantFieldsFromJson(json);
}
