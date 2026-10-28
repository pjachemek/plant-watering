// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PushResponse _$PushResponseFromJson(Map<String, dynamic> json) =>
    _PushResponse(
      results: (json['results'] as List<dynamic>)
          .map((e) => PushResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PushResponseToJson(_PushResponse instance) =>
    <String, dynamic>{'results': instance.results};
