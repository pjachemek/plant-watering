// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'uuid.dart';

part 'invites_request_body.freezed.dart';
part 'invites_request_body.g.dart';

@Freezed()
abstract class InvitesRequestBody with _$InvitesRequestBody {
  const factory InvitesRequestBody({
    @JsonKey(name: 'household_id') required Uuid householdId,
  }) = _InvitesRequestBody;

  factory InvitesRequestBody.fromJson(Map<String, Object?> json) =>
      _$InvitesRequestBodyFromJson(json);
}
