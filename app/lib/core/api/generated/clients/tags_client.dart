// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/platform.dart';
import '../models/resolved_tag.dart';
import '../models/sem_ver.dart';
import '../models/tag_token.dart';

part 'tags_client.g.dart';

@RestApi()
abstract class TagsClient {
  factory TagsClient(Dio dio, {String? baseUrl}) = _TagsClient;

  /// Resolve a scanned tag token within the caller's households (FR-1).
  ///
  /// 404 for unknown tokens and for tokens of other households alike, so a.
  /// tag never reveals another household's data.
  @GET('/tags/{token}')
  Future<ResolvedTag> resolveTag({
    @Header('X-App-Version') required SemVer xAppVersion,
    @Header('X-Platform') required Platform xPlatform,
    @Header('X-API-Version') required String xApiVersion,
    @Path('token') required TagToken token,
  });
}
