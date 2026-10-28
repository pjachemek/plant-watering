// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';

import 'clients/config_client.dart';
import 'clients/sync_client.dart';
import 'clients/households_client.dart';
import 'clients/invites_client.dart';
import 'clients/tags_client.dart';
import 'clients/photos_client.dart';
import 'clients/account_client.dart';

/// Plant NFC API `v1.0.0`.
///
/// The only backend the Plant NFC app talks to (AGENTS.md section 6, ADR-0012).
///
/// Versioning: the major version is in the URL. Changes within v1 are additive.
/// only; CI blocks breaking changes (ADR-0015). Clients must ignore unknown.
/// fields and unknown enum values.
///
/// Every request sends `X-App-Version`, `X-Platform` and `X-API-Version`.
/// Requests from app versions below the minimum get `426 Upgrade Required`.
///
/// Errors use RFC 9457 problem details (`application/problem+json`). `type` is.
/// a stable code clients can switch on; error bodies never contain user data.
///
class PlantApiClient {
  PlantApiClient(Dio dio, {String? baseUrl}) : _dio = dio, _baseUrl = baseUrl;

  final Dio _dio;
  final String? _baseUrl;

  static String get version => '1.0.0';

  ConfigClient? _config;
  SyncClient? _sync;
  HouseholdsClient? _households;
  InvitesClient? _invites;
  TagsClient? _tags;
  PhotosClient? _photos;
  AccountClient? _account;

  ConfigClient get config => _config ??= ConfigClient(_dio, baseUrl: _baseUrl);

  SyncClient get sync => _sync ??= SyncClient(_dio, baseUrl: _baseUrl);

  HouseholdsClient get households =>
      _households ??= HouseholdsClient(_dio, baseUrl: _baseUrl);

  InvitesClient get invites =>
      _invites ??= InvitesClient(_dio, baseUrl: _baseUrl);

  TagsClient get tags => _tags ??= TagsClient(_dio, baseUrl: _baseUrl);

  PhotosClient get photos => _photos ??= PhotosClient(_dio, baseUrl: _baseUrl);

  AccountClient get account =>
      _account ??= AccountClient(_dio, baseUrl: _baseUrl);
}
