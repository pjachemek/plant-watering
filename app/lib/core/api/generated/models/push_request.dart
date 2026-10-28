// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'push_change.dart';
import 'uuid.dart';

part 'push_request.freezed.dart';
part 'push_request.g.dart';

@Freezed()
abstract class PushRequest with _$PushRequest {
  const factory PushRequest({
    @JsonKey(name: 'household_id') required Uuid householdId,
    required List<PushChange> changes,
  }) = _PushRequest;

  factory PushRequest.fromJson(Map<String, Object?> json) =>
      _$PushRequestFromJson(json);
}
