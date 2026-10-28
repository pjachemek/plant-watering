// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'photo_upload_url.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PhotoUploadUrl {

@JsonKey(name: 'upload_url') String get uploadUrl;@JsonKey(name: 'photo_path') PhotoPath get photoPath;@JsonKey(name: 'expires_at') Timestamp get expiresAt;
/// Create a copy of PhotoUploadUrl
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhotoUploadUrlCopyWith<PhotoUploadUrl> get copyWith => _$PhotoUploadUrlCopyWithImpl<PhotoUploadUrl>(this as PhotoUploadUrl, _$identity);

  /// Serializes this PhotoUploadUrl to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PhotoUploadUrl;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhotoUploadUrl&&(identical(other.uploadUrl, _this.uploadUrl) || other.uploadUrl == _this.uploadUrl)&&(identical(other.photoPath, _this.photoPath) || other.photoPath == _this.photoPath)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PhotoUploadUrl;
  return Object.hash(runtimeType,_this.uploadUrl,_this.photoPath,_this.expiresAt);
}

@override
String toString() {
  final _this = this as PhotoUploadUrl;
  return 'PhotoUploadUrl(uploadUrl: ${_this.uploadUrl}, photoPath: ${_this.photoPath}, expiresAt: ${_this.expiresAt})';
}


}

/// @nodoc
abstract mixin class $PhotoUploadUrlCopyWith<$Res>  {
  factory $PhotoUploadUrlCopyWith(PhotoUploadUrl value, $Res Function(PhotoUploadUrl) _then) = _$PhotoUploadUrlCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'upload_url') String uploadUrl,@JsonKey(name: 'photo_path') PhotoPath photoPath,@JsonKey(name: 'expires_at') Timestamp expiresAt
});




}
/// @nodoc
class _$PhotoUploadUrlCopyWithImpl<$Res>
    implements $PhotoUploadUrlCopyWith<$Res> {
  _$PhotoUploadUrlCopyWithImpl(this._self, this._then);

  final PhotoUploadUrl _self;
  final $Res Function(PhotoUploadUrl) _then;

/// Create a copy of PhotoUploadUrl
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uploadUrl = null,Object? photoPath = null,Object? expiresAt = null,}) {
  return _then(PhotoUploadUrl(
uploadUrl: null == uploadUrl ? _self.uploadUrl : uploadUrl // ignore: cast_nullable_to_non_nullable
as String,photoPath: null == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as PhotoPath,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as Timestamp,
  ));
}

}


/// Adds pattern-matching-related methods to [PhotoUploadUrl].
extension PhotoUploadUrlPatterns on PhotoUploadUrl {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PhotoUploadUrl value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PhotoUploadUrl() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PhotoUploadUrl value)  $default,){
final _that = this;
switch (_that) {
case _PhotoUploadUrl():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PhotoUploadUrl value)?  $default,){
final _that = this;
switch (_that) {
case _PhotoUploadUrl() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'upload_url')  String uploadUrl, @JsonKey(name: 'photo_path')  PhotoPath photoPath, @JsonKey(name: 'expires_at')  Timestamp expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PhotoUploadUrl() when $default != null:
return $default(_that.uploadUrl,_that.photoPath,_that.expiresAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'upload_url')  String uploadUrl, @JsonKey(name: 'photo_path')  PhotoPath photoPath, @JsonKey(name: 'expires_at')  Timestamp expiresAt)  $default,) {final _that = this;
switch (_that) {
case _PhotoUploadUrl():
return $default(_that.uploadUrl,_that.photoPath,_that.expiresAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'upload_url')  String uploadUrl, @JsonKey(name: 'photo_path')  PhotoPath photoPath, @JsonKey(name: 'expires_at')  Timestamp expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _PhotoUploadUrl() when $default != null:
return $default(_that.uploadUrl,_that.photoPath,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PhotoUploadUrl implements PhotoUploadUrl {
  const _PhotoUploadUrl({@JsonKey(name: 'upload_url') required this.uploadUrl, @JsonKey(name: 'photo_path') required this.photoPath, @JsonKey(name: 'expires_at') required this.expiresAt});
  factory _PhotoUploadUrl.fromJson(Map<String, dynamic> json) => _$PhotoUploadUrlFromJson(json);

@override@JsonKey(name: 'upload_url') final  String uploadUrl;
@override@JsonKey(name: 'photo_path') final  PhotoPath photoPath;
@override@JsonKey(name: 'expires_at') final  Timestamp expiresAt;

/// Create a copy of PhotoUploadUrl
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhotoUploadUrlCopyWith<_PhotoUploadUrl> get copyWith => __$PhotoUploadUrlCopyWithImpl<_PhotoUploadUrl>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PhotoUploadUrlToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhotoUploadUrl&&(identical(other.uploadUrl, uploadUrl) || other.uploadUrl == uploadUrl)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,uploadUrl,photoPath,expiresAt);
}

@override
String toString() {
    return 'PhotoUploadUrl(uploadUrl: $uploadUrl, photoPath: $photoPath, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$PhotoUploadUrlCopyWith<$Res> implements $PhotoUploadUrlCopyWith<$Res> {
  factory _$PhotoUploadUrlCopyWith(_PhotoUploadUrl value, $Res Function(_PhotoUploadUrl) _then) = __$PhotoUploadUrlCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'upload_url') String uploadUrl,@JsonKey(name: 'photo_path') PhotoPath photoPath,@JsonKey(name: 'expires_at') Timestamp expiresAt
});




}
/// @nodoc
class __$PhotoUploadUrlCopyWithImpl<$Res>
    implements _$PhotoUploadUrlCopyWith<$Res> {
  __$PhotoUploadUrlCopyWithImpl(this._self, this._then);

  final _PhotoUploadUrl _self;
  final $Res Function(_PhotoUploadUrl) _then;

/// Create a copy of PhotoUploadUrl
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uploadUrl = null,Object? photoPath = null,Object? expiresAt = null,}) {
  return _then(_PhotoUploadUrl(
uploadUrl: null == uploadUrl ? _self.uploadUrl : uploadUrl // ignore: cast_nullable_to_non_nullable
as String,photoPath: null == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as PhotoPath,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as Timestamp,
  ));
}


}

// dart format on
