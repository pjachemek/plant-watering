// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'hemisphere.dart';

part 'create_household_request.freezed.dart';
part 'create_household_request.g.dart';

@Freezed()
abstract class CreateHouseholdRequest with _$CreateHouseholdRequest {
  const factory CreateHouseholdRequest({
    required String name,
    @JsonKey(name: 'display_name') required String displayName,
    Hemisphere? hemisphere,
  }) = _CreateHouseholdRequest;

  factory CreateHouseholdRequest.fromJson(Map<String, Object?> json) =>
      _$CreateHouseholdRequestFromJson(json);
}
