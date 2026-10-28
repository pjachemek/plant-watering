// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'problem.dart';
import 'push_result_status.dart';
import 'uuid.dart';

part 'push_result.freezed.dart';
part 'push_result.g.dart';

@Freezed()
abstract class PushResult with _$PushResult {
  const factory PushResult({
    @JsonKey(name: 'change_id') required Uuid changeId,
    required PushResultStatus status,

    /// Why the change was rejected.
    Problem? problem,
  }) = _PushResult;

  factory PushResult.fromJson(Map<String, Object?> json) =>
      _$PushResultFromJson(json);
}
