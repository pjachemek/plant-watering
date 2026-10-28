// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_households_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetHouseholdsResponse {

 List<Household> get households;
/// Create a copy of GetHouseholdsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetHouseholdsResponseCopyWith<GetHouseholdsResponse> get copyWith => _$GetHouseholdsResponseCopyWithImpl<GetHouseholdsResponse>(this as GetHouseholdsResponse, _$identity);

  /// Serializes this GetHouseholdsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GetHouseholdsResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetHouseholdsResponse&&const DeepCollectionEquality().equals(other.households, _this.households));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GetHouseholdsResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.households));
}

@override
String toString() {
  final _this = this as GetHouseholdsResponse;
  return 'GetHouseholdsResponse(households: ${_this.households})';
}


}

/// @nodoc
abstract mixin class $GetHouseholdsResponseCopyWith<$Res>  {
  factory $GetHouseholdsResponseCopyWith(GetHouseholdsResponse value, $Res Function(GetHouseholdsResponse) _then) = _$GetHouseholdsResponseCopyWithImpl;
@useResult
$Res call({
 List<Household> households
});




}
/// @nodoc
class _$GetHouseholdsResponseCopyWithImpl<$Res>
    implements $GetHouseholdsResponseCopyWith<$Res> {
  _$GetHouseholdsResponseCopyWithImpl(this._self, this._then);

  final GetHouseholdsResponse _self;
  final $Res Function(GetHouseholdsResponse) _then;

/// Create a copy of GetHouseholdsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? households = null,}) {
  return _then(GetHouseholdsResponse(
households: null == households ? _self.households : households // ignore: cast_nullable_to_non_nullable
as List<Household>,
  ));
}

}


/// Adds pattern-matching-related methods to [GetHouseholdsResponse].
extension GetHouseholdsResponsePatterns on GetHouseholdsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetHouseholdsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetHouseholdsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetHouseholdsResponse value)  $default,){
final _that = this;
switch (_that) {
case _GetHouseholdsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetHouseholdsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _GetHouseholdsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Household> households)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetHouseholdsResponse() when $default != null:
return $default(_that.households);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Household> households)  $default,) {final _that = this;
switch (_that) {
case _GetHouseholdsResponse():
return $default(_that.households);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Household> households)?  $default,) {final _that = this;
switch (_that) {
case _GetHouseholdsResponse() when $default != null:
return $default(_that.households);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GetHouseholdsResponse implements GetHouseholdsResponse {
  const _GetHouseholdsResponse({required  List<Household> households}): _households = households;
  factory _GetHouseholdsResponse.fromJson(Map<String, dynamic> json) => _$GetHouseholdsResponseFromJson(json);

 final  List<Household> _households;
@override List<Household> get households {
  if (_households is EqualUnmodifiableListView) return _households;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_households);
}


/// Create a copy of GetHouseholdsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetHouseholdsResponseCopyWith<_GetHouseholdsResponse> get copyWith => __$GetHouseholdsResponseCopyWithImpl<_GetHouseholdsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GetHouseholdsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetHouseholdsResponse&&const DeepCollectionEquality().equals(other.households, _households));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_households));
}

@override
String toString() {
    return 'GetHouseholdsResponse(households: $households)';
}


}

/// @nodoc
abstract mixin class _$GetHouseholdsResponseCopyWith<$Res> implements $GetHouseholdsResponseCopyWith<$Res> {
  factory _$GetHouseholdsResponseCopyWith(_GetHouseholdsResponse value, $Res Function(_GetHouseholdsResponse) _then) = __$GetHouseholdsResponseCopyWithImpl;
@override @useResult
$Res call({
 List<Household> households
});




}
/// @nodoc
class __$GetHouseholdsResponseCopyWithImpl<$Res>
    implements _$GetHouseholdsResponseCopyWith<$Res> {
  __$GetHouseholdsResponseCopyWithImpl(this._self, this._then);

  final _GetHouseholdsResponse _self;
  final $Res Function(_GetHouseholdsResponse) _then;

/// Create a copy of GetHouseholdsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? households = null,}) {
  return _then(_GetHouseholdsResponse(
households: null == households ? _self._households : households // ignore: cast_nullable_to_non_nullable
as List<Household>,
  ));
}


}

// dart format on
