// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/config.dart';
import '../models/platform.dart';
import '../models/sem_ver.dart';

part 'config_client.g.dart';

@RestApi()
abstract class ConfigClient {
  factory ConfigClient(Dio dio, {String? baseUrl}) = _ConfigClient;

  /// App version policy and feature flags. Callable before sign-in.
  @GET('/config')
  Future<Config> getConfig({
    @Header('X-App-Version') required SemVer xAppVersion,
    @Header('X-Platform') required Platform xPlatform,
    @Header('X-API-Version') required String xApiVersion,
  });
}
