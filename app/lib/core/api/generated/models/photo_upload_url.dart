// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'photo_path.dart';
import 'timestamp.dart';

part 'photo_upload_url.freezed.dart';
part 'photo_upload_url.g.dart';

@Freezed()
abstract class PhotoUploadUrl with _$PhotoUploadUrl {
  const factory PhotoUploadUrl({
    @JsonKey(name: 'upload_url') required String uploadUrl,
    @JsonKey(name: 'photo_path') required PhotoPath photoPath,
    @JsonKey(name: 'expires_at') required Timestamp expiresAt,
  }) = _PhotoUploadUrl;

  factory PhotoUploadUrl.fromJson(Map<String, Object?> json) =>
      _$PhotoUploadUrlFromJson(json);
}
