// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invites_request_body.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InvitesRequestBody {

@JsonKey(name: 'household_id') Uuid get householdId;
/// Create a copy of InvitesRequestBody
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvitesRequestBodyCopyWith<InvitesRequestBody> get copyWith => _$InvitesRequestBodyCopyWithImpl<InvitesRequestBody>(this as InvitesRequestBody, _$identity);

  /// Serializes this InvitesRequestBody to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as InvitesRequestBody;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvitesRequestBody&&(identical(other.householdId, _this.householdId) || other.householdId == _this.householdId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as InvitesRequestBody;
  return Object.hash(runtimeType,_this.householdId);
}

@override
String toString() {
  final _this = this as InvitesRequestBody;
  return 'InvitesRequestBody(householdId: ${_this.householdId})';
}


}

/// @nodoc
abstract mixin class $InvitesRequestBodyCopyWith<$Res>  {
  factory $InvitesRequestBodyCopyWith(InvitesRequestBody value, $Res Function(InvitesRequestBody) _then) = _$InvitesRequestBodyCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'household_id') Uuid householdId
});




}
/// @nodoc
class _$InvitesRequestBodyCopyWithImpl<$Res>
    implements $InvitesRequestBodyCopyWith<$Res> {
  _$InvitesRequestBodyCopyWithImpl(this._self, this._then);

  final InvitesRequestBody _self;
  final $Res Function(InvitesRequestBody) _then;

/// Create a copy of InvitesRequestBody
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? householdId = null,}) {
  return _then(InvitesRequestBody(
householdId: null == householdId ? _self.householdId : householdId // ignore: cast_nullable_to_non_nullable
as Uuid,
  ));
}

}


/// Adds pattern-matching-related methods to [InvitesRequestBody].
extension InvitesRequestBodyPatterns on InvitesRequestBody {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InvitesRequestBody value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InvitesRequestBody() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InvitesRequestBody value)  $default,){
final _that = this;
switch (_that) {
case _InvitesRequestBody():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InvitesRequestBody value)?  $default,){
final _that = this;
switch (_that) {
case _InvitesRequestBody() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'household_id')  Uuid householdId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InvitesRequestBody() when $default != null:
return $default(_that.householdId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'household_id')  Uuid householdId)  $default,) {final _that = this;
switch (_that) {
case _InvitesRequestBody():
return $default(_that.householdId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'household_id')  Uuid householdId)?  $default,) {final _that = this;
switch (_that) {
case _InvitesRequestBody() when $default != null:
return $default(_that.householdId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InvitesRequestBody implements InvitesRequestBody {
  const _InvitesRequestBody({@JsonKey(name: 'household_id') required this.householdId});
  factory _InvitesRequestBody.fromJson(Map<String, dynamic> json) => _$InvitesRequestBodyFromJson(json);

@override@JsonKey(name: 'household_id') final  Uuid householdId;

/// Create a copy of InvitesRequestBody
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvitesRequestBodyCopyWith<_InvitesRequestBody> get copyWith => __$InvitesRequestBodyCopyWithImpl<_InvitesRequestBody>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InvitesRequestBodyToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvitesRequestBody&&(identical(other.householdId, householdId) || other.householdId == householdId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,householdId);
}

@override
String toString() {
    return 'InvitesRequestBody(householdId: $householdId)';
}


}

/// @nodoc
abstract mixin class _$InvitesRequestBodyCopyWith<$Res> implements $InvitesRequestBodyCopyWith<$Res> {
  factory _$InvitesRequestBodyCopyWith(_InvitesRequestBody value, $Res Function(_InvitesRequestBody) _then) = __$InvitesRequestBodyCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'household_id') Uuid householdId
});




}
/// @nodoc
class __$InvitesRequestBodyCopyWithImpl<$Res>
    implements _$InvitesRequestBodyCopyWith<$Res> {
  __$InvitesRequestBodyCopyWithImpl(this._self, this._then);

  final _InvitesRequestBody _self;
  final $Res Function(_InvitesRequestBody) _then;

/// Create a copy of InvitesRequestBody
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? householdId = null,}) {
  return _then(_InvitesRequestBody(
householdId: null == householdId ? _self.householdId : householdId // ignore: cast_nullable_to_non_nullable
as Uuid,
  ));
}


}

// dart format on
