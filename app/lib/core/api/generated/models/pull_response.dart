// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'cursor.dart';
import 'household.dart';
import 'member.dart';
import 'plant.dart';
import 'tag.dart';
import 'watering_event.dart';

part 'pull_response.freezed.dart';
part 'pull_response.g.dart';

@Freezed()
abstract class PullResponse with _$PullResponse {
  const factory PullResponse({
    required Cursor cursor,
    required Household household,
    required List<Member> members,
    required List<Plant> plants,
    required List<Tag> tags,
    @JsonKey(name: 'watering_events')
    required List<WateringEvent> wateringEvents,
  }) = _PullResponse;

  factory PullResponse.fromJson(Map<String, Object?> json) =>
      _$PullResponseFromJson(json);
}
