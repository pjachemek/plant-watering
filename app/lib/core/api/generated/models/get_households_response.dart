// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'household.dart';

part 'get_households_response.freezed.dart';
part 'get_households_response.g.dart';

@Freezed()
abstract class GetHouseholdsResponse with _$GetHouseholdsResponse {
  const factory GetHouseholdsResponse({required List<Household> households}) =
      _GetHouseholdsResponse;

  factory GetHouseholdsResponse.fromJson(Map<String, Object?> json) =>
      _$GetHouseholdsResponseFromJson(json);
}
