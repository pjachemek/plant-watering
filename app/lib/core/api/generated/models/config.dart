// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'platform.dart';
import 'sem_ver.dart';

part 'config.freezed.dart';
part 'config.g.dart';

@Freezed()
abstract class Config with _$Config {
  const factory Config({
    required Platform platform,
    @JsonKey(name: 'min_version') required SemVer minVersion,
    @JsonKey(name: 'recommended_version') required SemVer recommendedVersion,

    /// The newest API major version, for example "1".
    @JsonKey(name: 'api_version') required String apiVersion,

    /// Feature flags (AGENTS.md section 10).
    Map<String, bool>? features,
  }) = _Config;

  factory Config.fromJson(Map<String, Object?> json) => _$ConfigFromJson(json);
}
