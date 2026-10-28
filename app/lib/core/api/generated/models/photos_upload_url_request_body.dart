// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'uuid.dart';
import 'content_type.dart';

part 'photos_upload_url_request_body.freezed.dart';
part 'photos_upload_url_request_body.g.dart';

@Freezed()
abstract class PhotosUploadUrlRequestBody with _$PhotosUploadUrlRequestBody {
  const factory PhotosUploadUrlRequestBody({
    @JsonKey(name: 'household_id') required Uuid householdId,
    @JsonKey(name: 'plant_id') required Uuid plantId,
    @JsonKey(name: 'content_type') required ContentType contentType,
  }) = _PhotosUploadUrlRequestBody;

  factory PhotosUploadUrlRequestBody.fromJson(Map<String, Object?> json) =>
      _$PhotosUploadUrlRequestBodyFromJson(json);
}
