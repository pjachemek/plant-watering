// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'tag_token.dart';
import 'timestamp.dart';
import 'uuid.dart';

part 'tag_fields.freezed.dart';
part 'tag_fields.g.dart';

@Freezed()
abstract class TagFields with _$TagFields {
  const factory TagFields({
    TagToken? token,
    @JsonKey(name: 'plant_id') Uuid? plantId,
    @JsonKey(name: 'written_at') Timestamp? writtenAt,
  }) = _TagFields;

  factory TagFields.fromJson(Map<String, Object?> json) =>
      _$TagFieldsFromJson(json);
}
