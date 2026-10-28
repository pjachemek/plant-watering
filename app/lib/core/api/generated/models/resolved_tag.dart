// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'plant.dart';
import 'tag.dart';

part 'resolved_tag.freezed.dart';
part 'resolved_tag.g.dart';

@Freezed()
abstract class ResolvedTag with _$ResolvedTag {
  const factory ResolvedTag({
    required Tag tag,

    /// The linked plant; absent when the tag is unlinked.
    Plant? plant,
  }) = _ResolvedTag;

  factory ResolvedTag.fromJson(Map<String, Object?> json) =>
      _$ResolvedTagFromJson(json);
}
