// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'timestamp.dart';

part 'signed_url.freezed.dart';
part 'signed_url.g.dart';

@Freezed()
abstract class SignedUrl with _$SignedUrl {
  const factory SignedUrl({
    required String url,
    @JsonKey(name: 'expires_at') required Timestamp expiresAt,
  }) = _SignedUrl;

  factory SignedUrl.fromJson(Map<String, Object?> json) =>
      _$SignedUrlFromJson(json);
}
