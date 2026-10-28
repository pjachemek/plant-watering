// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/create_household_request.dart';
import '../models/get_households_response.dart';
import '../models/household.dart';
import '../models/households_household_id_leave_request_body.dart';
import '../models/platform.dart';
import '../models/sem_ver.dart';
import '../models/uuid.dart';

part 'households_client.g.dart';

@RestApi()
abstract class HouseholdsClient {
  factory HouseholdsClient(Dio dio, {String? baseUrl}) = _HouseholdsClient;

  /// Households the caller belongs to (for example after a reinstall).
  @GET('/households')
  Future<GetHouseholdsResponse> listHouseholds({
    @Header('X-App-Version') required SemVer xAppVersion,
    @Header('X-Platform') required Platform xPlatform,
    @Header('X-API-Version') required String xApiVersion,
  });

  /// Create a household with the caller as its first member (FR-7).
  @POST('/households')
  Future<Household> createHousehold({
    @Header('X-App-Version') required SemVer xAppVersion,
    @Header('X-Platform') required Platform xPlatform,
    @Header('X-API-Version') required String xApiVersion,
    @Body() required CreateHouseholdRequest body,
  });

  /// Leave a household. The last member must confirm, and the household is deleted (FR-7).
  @POST('/households/{household_id}/leave')
  Future<void> leaveHousehold({
    @Header('X-App-Version') required SemVer xAppVersion,
    @Header('X-Platform') required Platform xPlatform,
    @Header('X-API-Version') required String xApiVersion,
    @Path('household_id') required Uuid householdId,
    @Body() required HouseholdsHouseholdIdLeaveRequestBody body,
  });
}
