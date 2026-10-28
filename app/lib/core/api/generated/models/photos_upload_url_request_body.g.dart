// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photos_upload_url_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PhotosUploadUrlRequestBody _$PhotosUploadUrlRequestBodyFromJson(
  Map<String, dynamic> json,
) => _PhotosUploadUrlRequestBody(
  householdId: json['household_id'] as Uuid,
  plantId: json['plant_id'] as Uuid,
  contentType: ContentType.fromJson(json['content_type'] as String),
);

Map<String, dynamic> _$PhotosUploadUrlRequestBodyToJson(
  _PhotosUploadUrlRequestBody instance,
) => <String, dynamic>{
  'household_id': instance.householdId,
  'plant_id': instance.plantId,
  'content_type': instance.contentType,
};
