// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resolved_tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ResolvedTag _$ResolvedTagFromJson(Map<String, dynamic> json) => _ResolvedTag(
  tag: Tag.fromJson(json['tag'] as Map<String, dynamic>),
  plant: json['plant'] == null
      ? null
      : Plant.fromJson(json['plant'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ResolvedTagToJson(_ResolvedTag instance) =>
    <String, dynamic>{'tag': instance.tag, 'plant': ?instance.plant};
