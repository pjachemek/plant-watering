// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'household_fields.dart';
import 'plant_fields.dart';
import 'sync_entity.dart';
import 'sync_op.dart';
import 'tag_fields.dart';
import 'uuid.dart';
import 'watering_event_fields.dart';

part 'push_change.freezed.dart';
part 'push_change.g.dart';

/// One change. Exactly the patch matching `entity` must be present.
/// (`plant`, `tag`, `watering_event` or `household`); it is omitted for.
/// `delete`.
///
/// For `upsert` of a household, plant or tag, `fields` lists the field.
/// names this change sets. Listed fields take the value in the patch, or.
/// null when absent; fields not listed are left unchanged. This keeps.
/// "clear this field" distinct from "don't touch it" for typed clients.
/// that omit nulls. Watering events are created whole and ignore `fields`.
///
@Freezed()
abstract class PushChange with _$PushChange {
  const factory PushChange({
    @JsonKey(name: 'change_id') required Uuid changeId,
    required SyncEntity entity,
    required SyncOp op,

    /// The row id (client-generated UUID v7 for new rows).
    required Uuid id,
    List<String>? fields,
    HouseholdFields? household,
    PlantFields? plant,
    TagFields? tag,
    @JsonKey(name: 'watering_event') WateringEventFields? wateringEvent,
  }) = _PushChange;

  factory PushChange.fromJson(Map<String, Object?> json) =>
      _$PushChangeFromJson(json);
}
