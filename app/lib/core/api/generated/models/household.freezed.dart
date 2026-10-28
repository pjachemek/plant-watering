// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'household.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Household {

 Uuid get id; String get name;@JsonKey(name: 'public_cards_enabled') bool get publicCardsEnabled; Hemisphere get hemisphere;@JsonKey(name: 'created_at') Timestamp get createdAt;@JsonKey(name: 'updated_at') Timestamp get updatedAt;@JsonKey(name: 'deleted_at') Timestamp? get deletedAt;
/// Create a copy of Household
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HouseholdCopyWith<Household> get copyWith => _$HouseholdCopyWithImpl<Household>(this as Household, _$identity);

  /// Serializes this Household to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Household;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Household&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.publicCardsEnabled, _this.publicCardsEnabled) || other.publicCardsEnabled == _this.publicCardsEnabled)&&(identical(other.hemisphere, _this.hemisphere) || other.hemisphere == _this.hemisphere)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Household;
  return Object.hash(runtimeType,_this.id,_this.name,_this.publicCardsEnabled,_this.hemisphere,_this.createdAt,_this.updatedAt,_this.deletedAt);
}

@override
String toString() {
  final _this = this as Household;
  return 'Household(id: ${_this.id}, name: ${_this.name}, publicCardsEnabled: ${_this.publicCardsEnabled}, hemisphere: ${_this.hemisphere}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, deletedAt: ${_this.deletedAt})';
}


}

/// @nodoc
abstract mixin class $HouseholdCopyWith<$Res>  {
  factory $HouseholdCopyWith(Household value, $Res Function(Household) _then) = _$HouseholdCopyWithImpl;
@useResult
$Res call({
 Uuid id, String name,@JsonKey(name: 'public_cards_enabled') bool publicCardsEnabled, Hemisphere hemisphere,@JsonKey(name: 'created_at') Timestamp createdAt,@JsonKey(name: 'updated_at') Timestamp updatedAt,@JsonKey(name: 'deleted_at') Timestamp? deletedAt
});




}
/// @nodoc
class _$HouseholdCopyWithImpl<$Res>
    implements $HouseholdCopyWith<$Res> {
  _$HouseholdCopyWithImpl(this._self, this._then);

  final Household _self;
  final $Res Function(Household) _then;

/// Create a copy of Household
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? publicCardsEnabled = null,Object? hemisphere = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,}) {
  return _then(Household(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as Uuid,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,publicCardsEnabled: null == publicCardsEnabled ? _self.publicCardsEnabled : publicCardsEnabled // ignore: cast_nullable_to_non_nullable
as bool,hemisphere: null == hemisphere ? _self.hemisphere : hemisphere // ignore: cast_nullable_to_non_nullable
as Hemisphere,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as Timestamp,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as Timestamp,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as Timestamp?,
  ));
}

}


/// Adds pattern-matching-related methods to [Household].
extension HouseholdPatterns on Household {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Household value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Household() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Household value)  $default,){
final _that = this;
switch (_that) {
case _Household():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Household value)?  $default,){
final _that = this;
switch (_that) {
case _Household() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Uuid id,  String name, @JsonKey(name: 'public_cards_enabled')  bool publicCardsEnabled,  Hemisphere hemisphere, @JsonKey(name: 'created_at')  Timestamp createdAt, @JsonKey(name: 'updated_at')  Timestamp updatedAt, @JsonKey(name: 'deleted_at')  Timestamp? deletedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Household() when $default != null:
return $default(_that.id,_that.name,_that.publicCardsEnabled,_that.hemisphere,_that.createdAt,_that.updatedAt,_that.deletedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Uuid id,  String name, @JsonKey(name: 'public_cards_enabled')  bool publicCardsEnabled,  Hemisphere hemisphere, @JsonKey(name: 'created_at')  Timestamp createdAt, @JsonKey(name: 'updated_at')  Timestamp updatedAt, @JsonKey(name: 'deleted_at')  Timestamp? deletedAt)  $default,) {final _that = this;
switch (_that) {
case _Household():
return $default(_that.id,_that.name,_that.publicCardsEnabled,_that.hemisphere,_that.createdAt,_that.updatedAt,_that.deletedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Uuid id,  String name, @JsonKey(name: 'public_cards_enabled')  bool publicCardsEnabled,  Hemisphere hemisphere, @JsonKey(name: 'created_at')  Timestamp createdAt, @JsonKey(name: 'updated_at')  Timestamp updatedAt, @JsonKey(name: 'deleted_at')  Timestamp? deletedAt)?  $default,) {final _that = this;
switch (_that) {
case _Household() when $default != null:
return $default(_that.id,_that.name,_that.publicCardsEnabled,_that.hemisphere,_that.createdAt,_that.updatedAt,_that.deletedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Household implements Household {
  const _Household({required this.id, required this.name, @JsonKey(name: 'public_cards_enabled') required this.publicCardsEnabled, required this.hemisphere, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt, @JsonKey(name: 'deleted_at') this.deletedAt});
  factory _Household.fromJson(Map<String, dynamic> json) => _$HouseholdFromJson(json);

@override final  Uuid id;
@override final  String name;
@override@JsonKey(name: 'public_cards_enabled') final  bool publicCardsEnabled;
@override final  Hemisphere hemisphere;
@override@JsonKey(name: 'created_at') final  Timestamp createdAt;
@override@JsonKey(name: 'updated_at') final  Timestamp updatedAt;
@override@JsonKey(name: 'deleted_at') final  Timestamp? deletedAt;

/// Create a copy of Household
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HouseholdCopyWith<_Household> get copyWith => __$HouseholdCopyWithImpl<_Household>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HouseholdToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Household&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.publicCardsEnabled, publicCardsEnabled) || other.publicCardsEnabled == publicCardsEnabled)&&(identical(other.hemisphere, hemisphere) || other.hemisphere == hemisphere)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,publicCardsEnabled,hemisphere,createdAt,updatedAt,deletedAt);
}

@override
String toString() {
    return 'Household(id: $id, name: $name, publicCardsEnabled: $publicCardsEnabled, hemisphere: $hemisphere, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class _$HouseholdCopyWith<$Res> implements $HouseholdCopyWith<$Res> {
  factory _$HouseholdCopyWith(_Household value, $Res Function(_Household) _then) = __$HouseholdCopyWithImpl;
@override @useResult
$Res call({
 Uuid id, String name,@JsonKey(name: 'public_cards_enabled') bool publicCardsEnabled, Hemisphere hemisphere,@JsonKey(name: 'created_at') Timestamp createdAt,@JsonKey(name: 'updated_at') Timestamp updatedAt,@JsonKey(name: 'deleted_at') Timestamp? deletedAt
});




}
/// @nodoc
class __$HouseholdCopyWithImpl<$Res>
    implements _$HouseholdCopyWith<$Res> {
  __$HouseholdCopyWithImpl(this._self, this._then);

  final _Household _self;
  final $Res Function(_Household) _then;

/// Create a copy of Household
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? publicCardsEnabled = null,Object? hemisphere = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,}) {
  return _then(_Household(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as Uuid,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,publicCardsEnabled: null == publicCardsEnabled ? _self.publicCardsEnabled : publicCardsEnabled // ignore: cast_nullable_to_non_nullable
as bool,hemisphere: null == hemisphere ? _self.hemisphere : hemisphere // ignore: cast_nullable_to_non_nullable
as Hemisphere,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as Timestamp,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as Timestamp,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as Timestamp?,
  ));
}


}

// dart format on
