// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'push_result.dart';

part 'push_response.freezed.dart';
part 'push_response.g.dart';

@Freezed()
abstract class PushResponse with _$PushResponse {
  const factory PushResponse({required List<PushResult> results}) =
      _PushResponse;

  factory PushResponse.fromJson(Map<String, Object?> json) =>
      _$PushResponseFromJson(json);
}
