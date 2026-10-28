// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'accept_invite_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AcceptInviteRequest {

 String get code;@JsonKey(name: 'display_name') String get displayName;
/// Create a copy of AcceptInviteRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AcceptInviteRequestCopyWith<AcceptInviteRequest> get copyWith => _$AcceptInviteRequestCopyWithImpl<AcceptInviteRequest>(this as AcceptInviteRequest, _$identity);

  /// Serializes this AcceptInviteRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AcceptInviteRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AcceptInviteRequest&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AcceptInviteRequest;
  return Object.hash(runtimeType,_this.code,_this.displayName);
}

@override
String toString() {
  final _this = this as AcceptInviteRequest;
  return 'AcceptInviteRequest(code: ${_this.code}, displayName: ${_this.displayName})';
}


}

/// @nodoc
abstract mixin class $AcceptInviteRequestCopyWith<$Res>  {
  factory $AcceptInviteRequestCopyWith(AcceptInviteRequest value, $Res Function(AcceptInviteRequest) _then) = _$AcceptInviteRequestCopyWithImpl;
@useResult
$Res call({
 String code,@JsonKey(name: 'display_name') String displayName
});




}
/// @nodoc
class _$AcceptInviteRequestCopyWithImpl<$Res>
    implements $AcceptInviteRequestCopyWith<$Res> {
  _$AcceptInviteRequestCopyWithImpl(this._self, this._then);

  final AcceptInviteRequest _self;
  final $Res Function(AcceptInviteRequest) _then;

/// Create a copy of AcceptInviteRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? displayName = null,}) {
  return _then(AcceptInviteRequest(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AcceptInviteRequest].
extension AcceptInviteRequestPatterns on AcceptInviteRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AcceptInviteRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AcceptInviteRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AcceptInviteRequest value)  $default,){
final _that = this;
switch (_that) {
case _AcceptInviteRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AcceptInviteRequest value)?  $default,){
final _that = this;
switch (_that) {
case _AcceptInviteRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code, @JsonKey(name: 'display_name')  String displayName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AcceptInviteRequest() when $default != null:
return $default(_that.code,_that.displayName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code, @JsonKey(name: 'display_name')  String displayName)  $default,) {final _that = this;
switch (_that) {
case _AcceptInviteRequest():
return $default(_that.code,_that.displayName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code, @JsonKey(name: 'display_name')  String displayName)?  $default,) {final _that = this;
switch (_that) {
case _AcceptInviteRequest() when $default != null:
return $default(_that.code,_that.displayName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AcceptInviteRequest implements AcceptInviteRequest {
  const _AcceptInviteRequest({required this.code, @JsonKey(name: 'display_name') required this.displayName});
  factory _AcceptInviteRequest.fromJson(Map<String, dynamic> json) => _$AcceptInviteRequestFromJson(json);

@override final  String code;
@override@JsonKey(name: 'display_name') final  String displayName;

/// Create a copy of AcceptInviteRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AcceptInviteRequestCopyWith<_AcceptInviteRequest> get copyWith => __$AcceptInviteRequestCopyWithImpl<_AcceptInviteRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AcceptInviteRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AcceptInviteRequest&&(identical(other.code, code) || other.code == code)&&(identical(other.displayName, displayName) || other.displayName == displayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,code,displayName);
}

@override
String toString() {
    return 'AcceptInviteRequest(code: $code, displayName: $displayName)';
}


}

/// @nodoc
abstract mixin class _$AcceptInviteRequestCopyWith<$Res> implements $AcceptInviteRequestCopyWith<$Res> {
  factory _$AcceptInviteRequestCopyWith(_AcceptInviteRequest value, $Res Function(_AcceptInviteRequest) _then) = __$AcceptInviteRequestCopyWithImpl;
@override @useResult
$Res call({
 String code,@JsonKey(name: 'display_name') String displayName
});




}
/// @nodoc
class __$AcceptInviteRequestCopyWithImpl<$Res>
    implements _$AcceptInviteRequestCopyWith<$Res> {
  __$AcceptInviteRequestCopyWithImpl(this._self, this._then);

  final _AcceptInviteRequest _self;
  final $Res Function(_AcceptInviteRequest) _then;

/// Create a copy of AcceptInviteRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? displayName = null,}) {
  return _then(_AcceptInviteRequest(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
