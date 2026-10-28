// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_upload_url.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PhotoUploadUrl _$PhotoUploadUrlFromJson(Map<String, dynamic> json) =>
    _PhotoUploadUrl(
      uploadUrl: json['upload_url'] as String,
      photoPath: json['photo_path'] as PhotoPath,
      expiresAt: DateTime.parse(json['expires_at'] as String),
    );

Map<String, dynamic> _$PhotoUploadUrlToJson(_PhotoUploadUrl instance) =>
    <String, dynamic>{
      'upload_url': instance.uploadUrl,
      'photo_path': instance.photoPath,
      'expires_at': instance.expiresAt.toIso8601String(),
    };
