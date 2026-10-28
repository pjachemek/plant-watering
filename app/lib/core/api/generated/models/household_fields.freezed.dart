// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'household_fields.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HouseholdFields {

 String? get name;@JsonKey(name: 'public_cards_enabled') bool? get publicCardsEnabled; Hemisphere? get hemisphere;
/// Create a copy of HouseholdFields
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HouseholdFieldsCopyWith<HouseholdFields> get copyWith => _$HouseholdFieldsCopyWithImpl<HouseholdFields>(this as HouseholdFields, _$identity);

  /// Serializes this HouseholdFields to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as HouseholdFields;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HouseholdFields&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.publicCardsEnabled, _this.publicCardsEnabled) || other.publicCardsEnabled == _this.publicCardsEnabled)&&(identical(other.hemisphere, _this.hemisphere) || other.hemisphere == _this.hemisphere));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as HouseholdFields;
  return Object.hash(runtimeType,_this.name,_this.publicCardsEnabled,_this.hemisphere);
}

@override
String toString() {
  final _this = this as HouseholdFields;
  return 'HouseholdFields(name: ${_this.name}, publicCardsEnabled: ${_this.publicCardsEnabled}, hemisphere: ${_this.hemisphere})';
}


}

/// @nodoc
abstract mixin class $HouseholdFieldsCopyWith<$Res>  {
  factory $HouseholdFieldsCopyWith(HouseholdFields value, $Res Function(HouseholdFields) _then) = _$HouseholdFieldsCopyWithImpl;
@useResult
$Res call({
 String? name,@JsonKey(name: 'public_cards_enabled') bool? publicCardsEnabled, Hemisphere? hemisphere
});




}
/// @nodoc
class _$HouseholdFieldsCopyWithImpl<$Res>
    implements $HouseholdFieldsCopyWith<$Res> {
  _$HouseholdFieldsCopyWithImpl(this._self, this._then);

  final HouseholdFields _self;
  final $Res Function(HouseholdFields) _then;

/// Create a copy of HouseholdFields
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? publicCardsEnabled = freezed,Object? hemisphere = freezed,}) {
  return _then(HouseholdFields(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,publicCardsEnabled: freezed == publicCardsEnabled ? _self.publicCardsEnabled : publicCardsEnabled // ignore: cast_nullable_to_non_nullable
as bool?,hemisphere: freezed == hemisphere ? _self.hemisphere : hemisphere // ignore: cast_nullable_to_non_nullable
as Hemisphere?,
  ));
}

}


/// Adds pattern-matching-related methods to [HouseholdFields].
extension HouseholdFieldsPatterns on HouseholdFields {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HouseholdFields value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HouseholdFields() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HouseholdFields value)  $default,){
final _that = this;
switch (_that) {
case _HouseholdFields():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HouseholdFields value)?  $default,){
final _that = this;
switch (_that) {
case _HouseholdFields() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name, @JsonKey(name: 'public_cards_enabled')  bool? publicCardsEnabled,  Hemisphere? hemisphere)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HouseholdFields() when $default != null:
return $default(_that.name,_that.publicCardsEnabled,_that.hemisphere);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name, @JsonKey(name: 'public_cards_enabled')  bool? publicCardsEnabled,  Hemisphere? hemisphere)  $default,) {final _that = this;
switch (_that) {
case _HouseholdFields():
return $default(_that.name,_that.publicCardsEnabled,_that.hemisphere);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name, @JsonKey(name: 'public_cards_enabled')  bool? publicCardsEnabled,  Hemisphere? hemisphere)?  $default,) {final _that = this;
switch (_that) {
case _HouseholdFields() when $default != null:
return $default(_that.name,_that.publicCardsEnabled,_that.hemisphere);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HouseholdFields implements HouseholdFields {
  const _HouseholdFields({this.name, @JsonKey(name: 'public_cards_enabled') this.publicCardsEnabled, this.hemisphere});
  factory _HouseholdFields.fromJson(Map<String, dynamic> json) => _$HouseholdFieldsFromJson(json);

@override final  String? name;
@override@JsonKey(name: 'public_cards_enabled') final  bool? publicCardsEnabled;
@override final  Hemisphere? hemisphere;

/// Create a copy of HouseholdFields
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HouseholdFieldsCopyWith<_HouseholdFields> get copyWith => __$HouseholdFieldsCopyWithImpl<_HouseholdFields>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HouseholdFieldsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HouseholdFields&&(identical(other.name, name) || other.name == name)&&(identical(other.publicCardsEnabled, publicCardsEnabled) || other.publicCardsEnabled == publicCardsEnabled)&&(identical(other.hemisphere, hemisphere) || other.hemisphere == hemisphere));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,publicCardsEnabled,hemisphere);
}

@override
String toString() {
    return 'HouseholdFields(name: $name, publicCardsEnabled: $publicCardsEnabled, hemisphere: $hemisphere)';
}


}

/// @nodoc
abstract mixin class _$HouseholdFieldsCopyWith<$Res> implements $HouseholdFieldsCopyWith<$Res> {
  factory _$HouseholdFieldsCopyWith(_HouseholdFields value, $Res Function(_HouseholdFields) _then) = __$HouseholdFieldsCopyWithImpl;
@override @useResult
$Res call({
 String? name,@JsonKey(name: 'public_cards_enabled') bool? publicCardsEnabled, Hemisphere? hemisphere
});




}
/// @nodoc
class __$HouseholdFieldsCopyWithImpl<$Res>
    implements _$HouseholdFieldsCopyWith<$Res> {
  __$HouseholdFieldsCopyWithImpl(this._self, this._then);

  final _HouseholdFields _self;
  final $Res Function(_HouseholdFields) _then;

/// Create a copy of HouseholdFields
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? publicCardsEnabled = freezed,Object? hemisphere = freezed,}) {
  return _then(_HouseholdFields(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,publicCardsEnabled: freezed == publicCardsEnabled ? _self.publicCardsEnabled : publicCardsEnabled // ignore: cast_nullable_to_non_nullable
as bool?,hemisphere: freezed == hemisphere ? _self.hemisphere : hemisphere // ignore: cast_nullable_to_non_nullable
as Hemisphere?,
  ));
}


}

// dart format on
