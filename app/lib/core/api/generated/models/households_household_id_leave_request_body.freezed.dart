// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'households_household_id_leave_request_body.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HouseholdsHouseholdIdLeaveRequestBody {

/// Must be true when the caller is the last member.
@JsonKey(name: 'confirm_delete_household') bool get confirmDeleteHousehold;
/// Create a copy of HouseholdsHouseholdIdLeaveRequestBody
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HouseholdsHouseholdIdLeaveRequestBodyCopyWith<HouseholdsHouseholdIdLeaveRequestBody> get copyWith => _$HouseholdsHouseholdIdLeaveRequestBodyCopyWithImpl<HouseholdsHouseholdIdLeaveRequestBody>(this as HouseholdsHouseholdIdLeaveRequestBody, _$identity);

  /// Serializes this HouseholdsHouseholdIdLeaveRequestBody to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as HouseholdsHouseholdIdLeaveRequestBody;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HouseholdsHouseholdIdLeaveRequestBody&&(identical(other.confirmDeleteHousehold, _this.confirmDeleteHousehold) || other.confirmDeleteHousehold == _this.confirmDeleteHousehold));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as HouseholdsHouseholdIdLeaveRequestBody;
  return Object.hash(runtimeType,_this.confirmDeleteHousehold);
}

@override
String toString() {
  final _this = this as HouseholdsHouseholdIdLeaveRequestBody;
  return 'HouseholdsHouseholdIdLeaveRequestBody(confirmDeleteHousehold: ${_this.confirmDeleteHousehold})';
}


}

/// @nodoc
abstract mixin class $HouseholdsHouseholdIdLeaveRequestBodyCopyWith<$Res>  {
  factory $HouseholdsHouseholdIdLeaveRequestBodyCopyWith(HouseholdsHouseholdIdLeaveRequestBody value, $Res Function(HouseholdsHouseholdIdLeaveRequestBody) _then) = _$HouseholdsHouseholdIdLeaveRequestBodyCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'confirm_delete_household') bool confirmDeleteHousehold
});




}
/// @nodoc
class _$HouseholdsHouseholdIdLeaveRequestBodyCopyWithImpl<$Res>
    implements $HouseholdsHouseholdIdLeaveRequestBodyCopyWith<$Res> {
  _$HouseholdsHouseholdIdLeaveRequestBodyCopyWithImpl(this._self, this._then);

  final HouseholdsHouseholdIdLeaveRequestBody _self;
  final $Res Function(HouseholdsHouseholdIdLeaveRequestBody) _then;

/// Create a copy of HouseholdsHouseholdIdLeaveRequestBody
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? confirmDeleteHousehold = null,}) {
  return _then(HouseholdsHouseholdIdLeaveRequestBody(
confirmDeleteHousehold: null == confirmDeleteHousehold ? _self.confirmDeleteHousehold : confirmDeleteHousehold // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [HouseholdsHouseholdIdLeaveRequestBody].
extension HouseholdsHouseholdIdLeaveRequestBodyPatterns on HouseholdsHouseholdIdLeaveRequestBody {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HouseholdsHouseholdIdLeaveRequestBody value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HouseholdsHouseholdIdLeaveRequestBody() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HouseholdsHouseholdIdLeaveRequestBody value)  $default,){
final _that = this;
switch (_that) {
case _HouseholdsHouseholdIdLeaveRequestBody():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HouseholdsHouseholdIdLeaveRequestBody value)?  $default,){
final _that = this;
switch (_that) {
case _HouseholdsHouseholdIdLeaveRequestBody() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'confirm_delete_household')  bool confirmDeleteHousehold)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HouseholdsHouseholdIdLeaveRequestBody() when $default != null:
return $default(_that.confirmDeleteHousehold);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'confirm_delete_household')  bool confirmDeleteHousehold)  $default,) {final _that = this;
switch (_that) {
case _HouseholdsHouseholdIdLeaveRequestBody():
return $default(_that.confirmDeleteHousehold);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'confirm_delete_household')  bool confirmDeleteHousehold)?  $default,) {final _that = this;
switch (_that) {
case _HouseholdsHouseholdIdLeaveRequestBody() when $default != null:
return $default(_that.confirmDeleteHousehold);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HouseholdsHouseholdIdLeaveRequestBody implements HouseholdsHouseholdIdLeaveRequestBody {
  const _HouseholdsHouseholdIdLeaveRequestBody({@JsonKey(name: 'confirm_delete_household') required this.confirmDeleteHousehold});
  factory _HouseholdsHouseholdIdLeaveRequestBody.fromJson(Map<String, dynamic> json) => _$HouseholdsHouseholdIdLeaveRequestBodyFromJson(json);

/// Must be true when the caller is the last member.
@override@JsonKey(name: 'confirm_delete_household') final  bool confirmDeleteHousehold;

/// Create a copy of HouseholdsHouseholdIdLeaveRequestBody
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HouseholdsHouseholdIdLeaveRequestBodyCopyWith<_HouseholdsHouseholdIdLeaveRequestBody> get copyWith => __$HouseholdsHouseholdIdLeaveRequestBodyCopyWithImpl<_HouseholdsHouseholdIdLeaveRequestBody>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HouseholdsHouseholdIdLeaveRequestBodyToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HouseholdsHouseholdIdLeaveRequestBody&&(identical(other.confirmDeleteHousehold, confirmDeleteHousehold) || other.confirmDeleteHousehold == confirmDeleteHousehold));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,confirmDeleteHousehold);
}

@override
String toString() {
    return 'HouseholdsHouseholdIdLeaveRequestBody(confirmDeleteHousehold: $confirmDeleteHousehold)';
}


}

/// @nodoc
abstract mixin class _$HouseholdsHouseholdIdLeaveRequestBodyCopyWith<$Res> implements $HouseholdsHouseholdIdLeaveRequestBodyCopyWith<$Res> {
  factory _$HouseholdsHouseholdIdLeaveRequestBodyCopyWith(_HouseholdsHouseholdIdLeaveRequestBody value, $Res Function(_HouseholdsHouseholdIdLeaveRequestBody) _then) = __$HouseholdsHouseholdIdLeaveRequestBodyCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'confirm_delete_household') bool confirmDeleteHousehold
});




}
/// @nodoc
class __$HouseholdsHouseholdIdLeaveRequestBodyCopyWithImpl<$Res>
    implements _$HouseholdsHouseholdIdLeaveRequestBodyCopyWith<$Res> {
  __$HouseholdsHouseholdIdLeaveRequestBodyCopyWithImpl(this._self, this._then);

  final _HouseholdsHouseholdIdLeaveRequestBody _self;
  final $Res Function(_HouseholdsHouseholdIdLeaveRequestBody) _then;

/// Create a copy of HouseholdsHouseholdIdLeaveRequestBody
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? confirmDeleteHousehold = null,}) {
  return _then(_HouseholdsHouseholdIdLeaveRequestBody(
confirmDeleteHousehold: null == confirmDeleteHousehold ? _self.confirmDeleteHousehold : confirmDeleteHousehold // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
