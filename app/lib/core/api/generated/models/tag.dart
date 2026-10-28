// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'tag_token.dart';
import 'timestamp.dart';
import 'uuid.dart';

part 'tag.freezed.dart';
part 'tag.g.dart';

@Freezed()
abstract class Tag with _$Tag {
  const factory Tag({
    required Uuid id,
    @JsonKey(name: 'household_id') required Uuid householdId,
    @JsonKey(name: 'updated_at') required Timestamp updatedAt,
    TagToken? token,
    @JsonKey(name: 'plant_id') Uuid? plantId,
    @JsonKey(name: 'written_at') Timestamp? writtenAt,
    @JsonKey(name: 'written_by') Uuid? writtenBy,
    @JsonKey(name: 'deleted_at') Timestamp? deletedAt,
  }) = _Tag;

  factory Tag.fromJson(Map<String, Object?> json) => _$TagFromJson(json);
}
