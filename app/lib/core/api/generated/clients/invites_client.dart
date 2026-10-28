// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/accept_invite_request.dart';
import '../models/household.dart';
import '../models/invite.dart';
import '../models/invites_request_body.dart';
import '../models/platform.dart';
import '../models/sem_ver.dart';

part 'invites_client.g.dart';

@RestApi()
abstract class InvitesClient {
  factory InvitesClient(Dio dio, {String? baseUrl}) = _InvitesClient;

  /// Create a single-use invite that expires in 7 days.
  @POST('/invites')
  Future<Invite> createInvite({
    @Header('X-App-Version') required SemVer xAppVersion,
    @Header('X-Platform') required Platform xPlatform,
    @Header('X-API-Version') required String xApiVersion,
    @Body() required InvitesRequestBody body,
  });

  /// Join a household with an invite code.
  @POST('/invites/accept')
  Future<Household> acceptInvite({
    @Header('X-App-Version') required SemVer xAppVersion,
    @Header('X-Platform') required Platform xPlatform,
    @Header('X-API-Version') required String xApiVersion,
    @Body() required AcceptInviteRequest body,
  });
}
