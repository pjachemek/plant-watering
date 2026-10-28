// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/cursor.dart';
import '../models/platform.dart';
import '../models/pull_response.dart';
import '../models/push_request.dart';
import '../models/push_response.dart';
import '../models/sem_ver.dart';
import '../models/uuid.dart';

part 'sync_client.g.dart';

@RestApi()
abstract class SyncClient {
  factory SyncClient(Dio dio, {String? baseUrl}) = _SyncClient;

  /// Apply queued changes from the outbox. Safe to retry.
  ///
  /// Each change carries a client-generated UUID v7 id. A retried request.
  /// with the same `Idempotency-Key` returns the original results; a change.
  /// already applied reports `duplicate`. Plant and tag patches are applied.
  /// per field, last write wins in server arrival order (AGENTS.md section 5).
  @POST('/sync/push')
  Future<PushResponse> syncPush({
    @Header('X-App-Version') required SemVer xAppVersion,
    @Header('X-Platform') required Platform xPlatform,
    @Header('X-API-Version') required String xApiVersion,
    @Header('Idempotency-Key') required Uuid idempotencyKey,
    @Body() required PushRequest body,
  });

  /// Everything in a household that changed since the cursor.
  ///
  /// Without a cursor, returns the whole household. The returned cursor is.
  /// opaque; send it back unchanged next time (ADR-0014). Rows may repeat.
  /// across pulls, so clients apply them idempotently.
  @GET('/sync/pull')
  Future<PullResponse> syncPull({
    @Header('X-App-Version') required SemVer xAppVersion,
    @Header('X-Platform') required Platform xPlatform,
    @Header('X-API-Version') required String xApiVersion,
    @Query('household_id') required Uuid householdId,
    @Query('cursor') Cursor? cursor,
  });
}
