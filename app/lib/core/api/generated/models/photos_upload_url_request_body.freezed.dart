// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'photos_upload_url_request_body.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PhotosUploadUrlRequestBody {

@JsonKey(name: 'household_id') Uuid get householdId;@JsonKey(name: 'plant_id') Uuid get plantId;@JsonKey(name: 'content_type') ContentType get contentType;
/// Create a copy of PhotosUploadUrlRequestBody
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhotosUploadUrlRequestBodyCopyWith<PhotosUploadUrlRequestBody> get copyWith => _$PhotosUploadUrlRequestBodyCopyWithImpl<PhotosUploadUrlRequestBody>(this as PhotosUploadUrlRequestBody, _$identity);

  /// Serializes this PhotosUploadUrlRequestBody to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PhotosUploadUrlRequestBody;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhotosUploadUrlRequestBody&&(identical(other.householdId, _this.householdId) || other.householdId == _this.householdId)&&(identical(other.plantId, _this.plantId) || other.plantId == _this.plantId)&&(identical(other.contentType, _this.contentType) || other.contentType == _this.contentType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PhotosUploadUrlRequestBody;
  return Object.hash(runtimeType,_this.householdId,_this.plantId,_this.contentType);
}

@override
String toString() {
  final _this = this as PhotosUploadUrlRequestBody;
  return 'PhotosUploadUrlRequestBody(householdId: ${_this.householdId}, plantId: ${_this.plantId}, contentType: ${_this.contentType})';
}


}

/// @nodoc
abstract mixin class $PhotosUploadUrlRequestBodyCopyWith<$Res>  {
  factory $PhotosUploadUrlRequestBodyCopyWith(PhotosUploadUrlRequestBody value, $Res Function(PhotosUploadUrlRequestBody) _then) = _$PhotosUploadUrlRequestBodyCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'household_id') Uuid householdId,@JsonKey(name: 'plant_id') Uuid plantId,@JsonKey(name: 'content_type') ContentType contentType
});




}
/// @nodoc
class _$PhotosUploadUrlRequestBodyCopyWithImpl<$Res>
    implements $PhotosUploadUrlRequestBodyCopyWith<$Res> {
  _$PhotosUploadUrlRequestBodyCopyWithImpl(this._self, this._then);

  final PhotosUploadUrlRequestBody _self;
  final $Res Function(PhotosUploadUrlRequestBody) _then;

/// Create a copy of PhotosUploadUrlRequestBody
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? householdId = null,Object? plantId = null,Object? contentType = null,}) {
  return _then(PhotosUploadUrlRequestBody(
householdId: null == householdId ? _self.householdId : householdId // ignore: cast_nullable_to_non_nullable
as Uuid,plantId: null == plantId ? _self.plantId : plantId // ignore: cast_nullable_to_non_nullable
as Uuid,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as ContentType,
  ));
}

}


/// Adds pattern-matching-related methods to [PhotosUploadUrlRequestBody].
extension PhotosUploadUrlRequestBodyPatterns on PhotosUploadUrlRequestBody {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PhotosUploadUrlRequestBody value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PhotosUploadUrlRequestBody() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PhotosUploadUrlRequestBody value)  $default,){
final _that = this;
switch (_that) {
case _PhotosUploadUrlRequestBody():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PhotosUploadUrlRequestBody value)?  $default,){
final _that = this;
switch (_that) {
case _PhotosUploadUrlRequestBody() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'household_id')  Uuid householdId, @JsonKey(name: 'plant_id')  Uuid plantId, @JsonKey(name: 'content_type')  ContentType contentType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PhotosUploadUrlRequestBody() when $default != null:
return $default(_that.householdId,_that.plantId,_that.contentType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'household_id')  Uuid householdId, @JsonKey(name: 'plant_id')  Uuid plantId, @JsonKey(name: 'content_type')  ContentType contentType)  $default,) {final _that = this;
switch (_that) {
case _PhotosUploadUrlRequestBody():
return $default(_that.householdId,_that.plantId,_that.contentType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'household_id')  Uuid householdId, @JsonKey(name: 'plant_id')  Uuid plantId, @JsonKey(name: 'content_type')  ContentType contentType)?  $default,) {final _that = this;
switch (_that) {
case _PhotosUploadUrlRequestBody() when $default != null:
return $default(_that.householdId,_that.plantId,_that.contentType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PhotosUploadUrlRequestBody implements PhotosUploadUrlRequestBody {
  const _PhotosUploadUrlRequestBody({@JsonKey(name: 'household_id') required this.householdId, @JsonKey(name: 'plant_id') required this.plantId, @JsonKey(name: 'content_type') required this.contentType});
  factory _PhotosUploadUrlRequestBody.fromJson(Map<String, dynamic> json) => _$PhotosUploadUrlRequestBodyFromJson(json);

@override@JsonKey(name: 'household_id') final  Uuid householdId;
@override@JsonKey(name: 'plant_id') final  Uuid plantId;
@override@JsonKey(name: 'content_type') final  ContentType contentType;

/// Create a copy of PhotosUploadUrlRequestBody
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhotosUploadUrlRequestBodyCopyWith<_PhotosUploadUrlRequestBody> get copyWith => __$PhotosUploadUrlRequestBodyCopyWithImpl<_PhotosUploadUrlRequestBody>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PhotosUploadUrlRequestBodyToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhotosUploadUrlRequestBody&&(identical(other.householdId, householdId) || other.householdId == householdId)&&(identical(other.plantId, plantId) || other.plantId == plantId)&&(identical(other.contentType, contentType) || other.contentType == contentType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,householdId,plantId,contentType);
}

@override
String toString() {
    return 'PhotosUploadUrlRequestBody(householdId: $householdId, plantId: $plantId, contentType: $contentType)';
}


}

/// @nodoc
abstract mixin class _$PhotosUploadUrlRequestBodyCopyWith<$Res> implements $PhotosUploadUrlRequestBodyCopyWith<$Res> {
  factory _$PhotosUploadUrlRequestBodyCopyWith(_PhotosUploadUrlRequestBody value, $Res Function(_PhotosUploadUrlRequestBody) _then) = __$PhotosUploadUrlRequestBodyCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'household_id') Uuid householdId,@JsonKey(name: 'plant_id') Uuid plantId,@JsonKey(name: 'content_type') ContentType contentType
});




}
/// @nodoc
class __$PhotosUploadUrlRequestBodyCopyWithImpl<$Res>
    implements _$PhotosUploadUrlRequestBodyCopyWith<$Res> {
  __$PhotosUploadUrlRequestBodyCopyWithImpl(this._self, this._then);

  final _PhotosUploadUrlRequestBody _self;
  final $Res Function(_PhotosUploadUrlRequestBody) _then;

/// Create a copy of PhotosUploadUrlRequestBody
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? householdId = null,Object? plantId = null,Object? contentType = null,}) {
  return _then(_PhotosUploadUrlRequestBody(
householdId: null == householdId ? _self.householdId : householdId // ignore: cast_nullable_to_non_nullable
as Uuid,plantId: null == plantId ? _self.plantId : plantId // ignore: cast_nullable_to_non_nullable
as Uuid,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as ContentType,
  ));
}


}

// dart format on
