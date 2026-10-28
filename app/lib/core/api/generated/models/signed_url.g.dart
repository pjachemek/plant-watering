// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signed_url.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SignedUrl _$SignedUrlFromJson(Map<String, dynamic> json) => _SignedUrl(
  url: json['url'] as String,
  expiresAt: DateTime.parse(json['expires_at'] as String),
);

Map<String, dynamic> _$SignedUrlToJson(_SignedUrl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'expires_at': instance.expiresAt.toIso8601String(),
    };
