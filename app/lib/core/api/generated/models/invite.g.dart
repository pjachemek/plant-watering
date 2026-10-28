// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Invite _$InviteFromJson(Map<String, dynamic> json) => _Invite(
  code: json['code'] as String,
  url: json['url'] as String,
  expiresAt: DateTime.parse(json['expires_at'] as String),
);

Map<String, dynamic> _$InviteToJson(_Invite instance) => <String, dynamic>{
  'code': instance.code,
  'url': instance.url,
  'expires_at': instance.expiresAt.toIso8601String(),
};
