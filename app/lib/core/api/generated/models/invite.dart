// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'timestamp.dart';

part 'invite.freezed.dart';
part 'invite.g.dart';

@Freezed()
abstract class Invite with _$Invite {
  const factory Invite({
    required String code,
    required String url,
    @JsonKey(name: 'expires_at') required Timestamp expiresAt,
  }) = _Invite;

  factory Invite.fromJson(Map<String, Object?> json) => _$InviteFromJson(json);
}
