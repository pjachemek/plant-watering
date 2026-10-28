// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plant_fields.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlantFields {

 String? get nickname;@JsonKey(name: 'preset_id') String? get presetId;@JsonKey(name: 'preset_version') int? get presetVersion; String? get room;@JsonKey(name: 'photo_path') PhotoPath? get photoPath;@JsonKey(name: 'interval_summer_days') int? get intervalSummerDays;@JsonKey(name: 'interval_winter_days') int? get intervalWinterDays; WateringAmount? get amount; WateringMethod? get method; String? get notes;
/// Create a copy of PlantFields
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlantFieldsCopyWith<PlantFields> get copyWith => _$PlantFieldsCopyWithImpl<PlantFields>(this as PlantFields, _$identity);

  /// Serializes this PlantFields to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PlantFields;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlantFields&&(identical(other.nickname, _this.nickname) || other.nickname == _this.nickname)&&(identical(other.presetId, _this.presetId) || other.presetId == _this.presetId)&&(identical(other.presetVersion, _this.presetVersion) || other.presetVersion == _this.presetVersion)&&(identical(other.room, _this.room) || other.room == _this.room)&&(identical(other.photoPath, _this.photoPath) || other.photoPath == _this.photoPath)&&(identical(other.intervalSummerDays, _this.intervalSummerDays) || other.intervalSummerDays == _this.intervalSummerDays)&&(identical(other.intervalWinterDays, _this.intervalWinterDays) || other.intervalWinterDays == _this.intervalWinterDays)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.method, _this.method) || other.method == _this.method)&&(identical(other.notes, _this.notes) || other.notes == _this.notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PlantFields;
  return Object.hash(runtimeType,_this.nickname,_this.presetId,_this.presetVersion,_this.room,_this.photoPath,_this.intervalSummerDays,_this.intervalWinterDays,_this.amount,_this.method,_this.notes);
}

@override
String toString() {
  final _this = this as PlantFields;
  return 'PlantFields(nickname: ${_this.nickname}, presetId: ${_this.presetId}, presetVersion: ${_this.presetVersion}, room: ${_this.room}, photoPath: ${_this.photoPath}, intervalSummerDays: ${_this.intervalSummerDays}, intervalWinterDays: ${_this.intervalWinterDays}, amount: ${_this.amount}, method: ${_this.method}, notes: ${_this.notes})';
}


}

/// @nodoc
abstract mixin class $PlantFieldsCopyWith<$Res>  {
  factory $PlantFieldsCopyWith(PlantFields value, $Res Function(PlantFields) _then) = _$PlantFieldsCopyWithImpl;
@useResult
$Res call({
 String? nickname,@JsonKey(name: 'preset_id') String? presetId,@JsonKey(name: 'preset_version') int? presetVersion, String? room,@JsonKey(name: 'photo_path') PhotoPath? photoPath,@JsonKey(name: 'interval_summer_days') int? intervalSummerDays,@JsonKey(name: 'interval_winter_days') int? intervalWinterDays, WateringAmount? amount, WateringMethod? method, String? notes
});




}
/// @nodoc
class _$PlantFieldsCopyWithImpl<$Res>
    implements $PlantFieldsCopyWith<$Res> {
  _$PlantFieldsCopyWithImpl(this._self, this._then);

  final PlantFields _self;
  final $Res Function(PlantFields) _then;

/// Create a copy of PlantFields
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nickname = freezed,Object? presetId = freezed,Object? presetVersion = freezed,Object? room = freezed,Object? photoPath = freezed,Object? intervalSummerDays = freezed,Object? intervalWinterDays = freezed,Object? amount = freezed,Object? method = freezed,Object? notes = freezed,}) {
  return _then(PlantFields(
nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,presetId: freezed == presetId ? _self.presetId : presetId // ignore: cast_nullable_to_non_nullable
as String?,presetVersion: freezed == presetVersion ? _self.presetVersion : presetVersion // ignore: cast_nullable_to_non_nullable
as int?,room: freezed == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as String?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as PhotoPath?,intervalSummerDays: freezed == intervalSummerDays ? _self.intervalSummerDays : intervalSummerDays // ignore: cast_nullable_to_non_nullable
as int?,intervalWinterDays: freezed == intervalWinterDays ? _self.intervalWinterDays : intervalWinterDays // ignore: cast_nullable_to_non_nullable
as int?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as WateringAmount?,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as WateringMethod?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PlantFields].
extension PlantFieldsPatterns on PlantFields {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlantFields value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlantFields() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlantFields value)  $default,){
final _that = this;
switch (_that) {
case _PlantFields():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlantFields value)?  $default,){
final _that = this;
switch (_that) {
case _PlantFields() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? nickname, @JsonKey(name: 'preset_id')  String? presetId, @JsonKey(name: 'preset_version')  int? presetVersion,  String? room, @JsonKey(name: 'photo_path')  PhotoPath? photoPath, @JsonKey(name: 'interval_summer_days')  int? intervalSummerDays, @JsonKey(name: 'interval_winter_days')  int? intervalWinterDays,  WateringAmount? amount,  WateringMethod? method,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlantFields() when $default != null:
return $default(_that.nickname,_that.presetId,_that.presetVersion,_that.room,_that.photoPath,_that.intervalSummerDays,_that.intervalWinterDays,_that.amount,_that.method,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? nickname, @JsonKey(name: 'preset_id')  String? presetId, @JsonKey(name: 'preset_version')  int? presetVersion,  String? room, @JsonKey(name: 'photo_path')  PhotoPath? photoPath, @JsonKey(name: 'interval_summer_days')  int? intervalSummerDays, @JsonKey(name: 'interval_winter_days')  int? intervalWinterDays,  WateringAmount? amount,  WateringMethod? method,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _PlantFields():
return $default(_that.nickname,_that.presetId,_that.presetVersion,_that.room,_that.photoPath,_that.intervalSummerDays,_that.intervalWinterDays,_that.amount,_that.method,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? nickname, @JsonKey(name: 'preset_id')  String? presetId, @JsonKey(name: 'preset_version')  int? presetVersion,  String? room, @JsonKey(name: 'photo_path')  PhotoPath? photoPath, @JsonKey(name: 'interval_summer_days')  int? intervalSummerDays, @JsonKey(name: 'interval_winter_days')  int? intervalWinterDays,  WateringAmount? amount,  WateringMethod? method,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _PlantFields() when $default != null:
return $default(_that.nickname,_that.presetId,_that.presetVersion,_that.room,_that.photoPath,_that.intervalSummerDays,_that.intervalWinterDays,_that.amount,_that.method,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlantFields implements PlantFields {
  const _PlantFields({this.nickname, @JsonKey(name: 'preset_id') this.presetId, @JsonKey(name: 'preset_version') this.presetVersion, this.room, @JsonKey(name: 'photo_path') this.photoPath, @JsonKey(name: 'interval_summer_days') this.intervalSummerDays, @JsonKey(name: 'interval_winter_days') this.intervalWinterDays, this.amount, this.method, this.notes});
  factory _PlantFields.fromJson(Map<String, dynamic> json) => _$PlantFieldsFromJson(json);

@override final  String? nickname;
@override@JsonKey(name: 'preset_id') final  String? presetId;
@override@JsonKey(name: 'preset_version') final  int? presetVersion;
@override final  String? room;
@override@JsonKey(name: 'photo_path') final  PhotoPath? photoPath;
@override@JsonKey(name: 'interval_summer_days') final  int? intervalSummerDays;
@override@JsonKey(name: 'interval_winter_days') final  int? intervalWinterDays;
@override final  WateringAmount? amount;
@override final  WateringMethod? method;
@override final  String? notes;

/// Create a copy of PlantFields
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlantFieldsCopyWith<_PlantFields> get copyWith => __$PlantFieldsCopyWithImpl<_PlantFields>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlantFieldsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlantFields&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.presetId, presetId) || other.presetId == presetId)&&(identical(other.presetVersion, presetVersion) || other.presetVersion == presetVersion)&&(identical(other.room, room) || other.room == room)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.intervalSummerDays, intervalSummerDays) || other.intervalSummerDays == intervalSummerDays)&&(identical(other.intervalWinterDays, intervalWinterDays) || other.intervalWinterDays == intervalWinterDays)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.method, method) || other.method == method)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,nickname,presetId,presetVersion,room,photoPath,intervalSummerDays,intervalWinterDays,amount,method,notes);
}

@override
String toString() {
    return 'PlantFields(nickname: $nickname, presetId: $presetId, presetVersion: $presetVersion, room: $room, photoPath: $photoPath, intervalSummerDays: $intervalSummerDays, intervalWinterDays: $intervalWinterDays, amount: $amount, method: $method, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$PlantFieldsCopyWith<$Res> implements $PlantFieldsCopyWith<$Res> {
  factory _$PlantFieldsCopyWith(_PlantFields value, $Res Function(_PlantFields) _then) = __$PlantFieldsCopyWithImpl;
@override @useResult
$Res call({
 String? nickname,@JsonKey(name: 'preset_id') String? presetId,@JsonKey(name: 'preset_version') int? presetVersion, String? room,@JsonKey(name: 'photo_path') PhotoPath? photoPath,@JsonKey(name: 'interval_summer_days') int? intervalSummerDays,@JsonKey(name: 'interval_winter_days') int? intervalWinterDays, WateringAmount? amount, WateringMethod? method, String? notes
});




}
/// @nodoc
class __$PlantFieldsCopyWithImpl<$Res>
    implements _$PlantFieldsCopyWith<$Res> {
  __$PlantFieldsCopyWithImpl(this._self, this._then);

  final _PlantFields _self;
  final $Res Function(_PlantFields) _then;

/// Create a copy of PlantFields
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nickname = freezed,Object? presetId = freezed,Object? presetVersion = freezed,Object? room = freezed,Object? photoPath = freezed,Object? intervalSummerDays = freezed,Object? intervalWinterDays = freezed,Object? amount = freezed,Object? method = freezed,Object? notes = freezed,}) {
  return _then(_PlantFields(
nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,presetId: freezed == presetId ? _self.presetId : presetId // ignore: cast_nullable_to_non_nullable
as String?,presetVersion: freezed == presetVersion ? _self.presetVersion : presetVersion // ignore: cast_nullable_to_non_nullable
as int?,room: freezed == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as String?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as PhotoPath?,intervalSummerDays: freezed == intervalSummerDays ? _self.intervalSummerDays : intervalSummerDays // ignore: cast_nullable_to_non_nullable
as int?,intervalWinterDays: freezed == intervalWinterDays ? _self.intervalWinterDays : intervalWinterDays // ignore: cast_nullable_to_non_nullable
as int?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as WateringAmount?,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as WateringMethod?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
