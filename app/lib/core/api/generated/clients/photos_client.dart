// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/photo_path.dart';
import '../models/photo_upload_url.dart';
import '../models/photos_upload_url_request_body.dart';
import '../models/platform.dart';
import '../models/sem_ver.dart';
import '../models/signed_url.dart';

part 'photos_client.g.dart';

@RestApi()
abstract class PhotosClient {
  factory PhotosClient(Dio dio, {String? baseUrl}) = _PhotosClient;

  /// A short-lived signed URL for uploading one plant photo.
  @POST('/photos/upload-url')
  Future<PhotoUploadUrl> createPhotoUploadUrl({
    @Header('X-App-Version') required SemVer xAppVersion,
    @Header('X-Platform') required Platform xPlatform,
    @Header('X-API-Version') required String xApiVersion,
    @Body() required PhotosUploadUrlRequestBody body,
  });

  /// A short-lived signed URL for one plant photo.
  @GET('/photos/download-url')
  Future<SignedUrl> getPhotoDownloadUrl({
    @Header('X-App-Version') required SemVer xAppVersion,
    @Header('X-Platform') required Platform xPlatform,
    @Header('X-API-Version') required String xApiVersion,
    @Query('photo_path') required PhotoPath photoPath,
  });
}
