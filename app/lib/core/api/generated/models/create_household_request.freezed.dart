// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_household_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateHouseholdRequest {

 String get name;@JsonKey(name: 'display_name') String get displayName; Hemisphere? get hemisphere;
/// Create a copy of CreateHouseholdRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateHouseholdRequestCopyWith<CreateHouseholdRequest> get copyWith => _$CreateHouseholdRequestCopyWithImpl<CreateHouseholdRequest>(this as CreateHouseholdRequest, _$identity);

  /// Serializes this CreateHouseholdRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CreateHouseholdRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateHouseholdRequest&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.hemisphere, _this.hemisphere) || other.hemisphere == _this.hemisphere));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CreateHouseholdRequest;
  return Object.hash(runtimeType,_this.name,_this.displayName,_this.hemisphere);
}

@override
String toString() {
  final _this = this as CreateHouseholdRequest;
  return 'CreateHouseholdRequest(name: ${_this.name}, displayName: ${_this.displayName}, hemisphere: ${_this.hemisphere})';
}


}

/// @nodoc
abstract mixin class $CreateHouseholdRequestCopyWith<$Res>  {
  factory $CreateHouseholdRequestCopyWith(CreateHouseholdRequest value, $Res Function(CreateHouseholdRequest) _then) = _$CreateHouseholdRequestCopyWithImpl;
@useResult
$Res call({
 String name,@JsonKey(name: 'display_name') String displayName, Hemisphere? hemisphere
});




}
/// @nodoc
class _$CreateHouseholdRequestCopyWithImpl<$Res>
    implements $CreateHouseholdRequestCopyWith<$Res> {
  _$CreateHouseholdRequestCopyWithImpl(this._self, this._then);

  final CreateHouseholdRequest _self;
  final $Res Function(CreateHouseholdRequest) _then;

/// Create a copy of CreateHouseholdRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? displayName = null,Object? hemisphere = freezed,}) {
  return _then(CreateHouseholdRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,hemisphere: freezed == hemisphere ? _self.hemisphere : hemisphere // ignore: cast_nullable_to_non_nullable
as Hemisphere?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateHouseholdRequest].
extension CreateHouseholdRequestPatterns on CreateHouseholdRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateHouseholdRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateHouseholdRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateHouseholdRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateHouseholdRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateHouseholdRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateHouseholdRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name, @JsonKey(name: 'display_name')  String displayName,  Hemisphere? hemisphere)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateHouseholdRequest() when $default != null:
return $default(_that.name,_that.displayName,_that.hemisphere);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name, @JsonKey(name: 'display_name')  String displayName,  Hemisphere? hemisphere)  $default,) {final _that = this;
switch (_that) {
case _CreateHouseholdRequest():
return $default(_that.name,_that.displayName,_that.hemisphere);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name, @JsonKey(name: 'display_name')  String displayName,  Hemisphere? hemisphere)?  $default,) {final _that = this;
switch (_that) {
case _CreateHouseholdRequest() when $default != null:
return $default(_that.name,_that.displayName,_that.hemisphere);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateHouseholdRequest implements CreateHouseholdRequest {
  const _CreateHouseholdRequest({required this.name, @JsonKey(name: 'display_name') required this.displayName, this.hemisphere});
  factory _CreateHouseholdRequest.fromJson(Map<String, dynamic> json) => _$CreateHouseholdRequestFromJson(json);

@override final  String name;
@override@JsonKey(name: 'display_name') final  String displayName;
@override final  Hemisphere? hemisphere;

/// Create a copy of CreateHouseholdRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateHouseholdRequestCopyWith<_CreateHouseholdRequest> get copyWith => __$CreateHouseholdRequestCopyWithImpl<_CreateHouseholdRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateHouseholdRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateHouseholdRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.hemisphere, hemisphere) || other.hemisphere == hemisphere));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,displayName,hemisphere);
}

@override
String toString() {
    return 'CreateHouseholdRequest(name: $name, displayName: $displayName, hemisphere: $hemisphere)';
}


}

/// @nodoc
abstract mixin class _$CreateHouseholdRequestCopyWith<$Res> implements $CreateHouseholdRequestCopyWith<$Res> {
  factory _$CreateHouseholdRequestCopyWith(_CreateHouseholdRequest value, $Res Function(_CreateHouseholdRequest) _then) = __$CreateHouseholdRequestCopyWithImpl;
@override @useResult
$Res call({
 String name,@JsonKey(name: 'display_name') String displayName, Hemisphere? hemisphere
});




}
/// @nodoc
class __$CreateHouseholdRequestCopyWithImpl<$Res>
    implements _$CreateHouseholdRequestCopyWith<$Res> {
  __$CreateHouseholdRequestCopyWithImpl(this._self, this._then);

  final _CreateHouseholdRequest _self;
  final $Res Function(_CreateHouseholdRequest) _then;

/// Create a copy of CreateHouseholdRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? displayName = null,Object? hemisphere = freezed,}) {
  return _then(_CreateHouseholdRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,hemisphere: freezed == hemisphere ? _self.hemisphere : hemisphere // ignore: cast_nullable_to_non_nullable
as Hemisphere?,
  ));
}


}

// dart format on
