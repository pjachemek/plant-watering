// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'households_household_id_leave_request_body.freezed.dart';
part 'households_household_id_leave_request_body.g.dart';

@Freezed()
abstract class HouseholdsHouseholdIdLeaveRequestBody
    with _$HouseholdsHouseholdIdLeaveRequestBody {
  const factory HouseholdsHouseholdIdLeaveRequestBody({
    /// Must be true when the caller is the last member.
    @JsonKey(name: 'confirm_delete_household')
    required bool confirmDeleteHousehold,
  }) = _HouseholdsHouseholdIdLeaveRequestBody;

  factory HouseholdsHouseholdIdLeaveRequestBody.fromJson(
    Map<String, Object?> json,
  ) => _$HouseholdsHouseholdIdLeaveRequestBodyFromJson(json);
}
