// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Config _$ConfigFromJson(Map<String, dynamic> json) => _Config(
  platform: Platform.fromJson(json['platform'] as String),
  minVersion: json['min_version'] as SemVer,
  recommendedVersion: json['recommended_version'] as SemVer,
  apiVersion: json['api_version'] as String,
  features: (json['features'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as bool),
  ),
);

Map<String, dynamic> _$ConfigToJson(_Config instance) => <String, dynamic>{
  'platform': instance.platform,
  'min_version': instance.minVersion,
  'recommended_version': instance.recommendedVersion,
  'api_version': instance.apiVersion,
  'features': ?instance.features,
};
