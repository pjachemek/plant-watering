// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'accept_invite_request.freezed.dart';
part 'accept_invite_request.g.dart';

@Freezed()
abstract class AcceptInviteRequest with _$AcceptInviteRequest {
  const factory AcceptInviteRequest({
    required String code,
    @JsonKey(name: 'display_name') required String displayName,
  }) = _AcceptInviteRequest;

  factory AcceptInviteRequest.fromJson(Map<String, Object?> json) =>
      _$AcceptInviteRequestFromJson(json);
}
