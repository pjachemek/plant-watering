// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'household.dart';
import 'plant.dart';
import 'tag.dart';
import 'timestamp.dart';
import 'uuid.dart';
import 'watering_event.dart';

part 'account_export.freezed.dart';
part 'account_export.g.dart';

@Freezed()
abstract class AccountExport with _$AccountExport {
  const factory AccountExport({
    @JsonKey(name: 'exported_at') required Timestamp exportedAt,
    @JsonKey(name: 'user_id') required Uuid userId,
    required List<Household> households,
    required List<Plant> plants,
    required List<Tag> tags,
    @JsonKey(name: 'watering_events')
    required List<WateringEvent> wateringEvents,
  }) = _AccountExport;

  factory AccountExport.fromJson(Map<String, Object?> json) =>
      _$AccountExportFromJson(json);
}
