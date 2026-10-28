// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'watering_event_fields.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WateringEventFields {

@JsonKey(name: 'plant_id') Uuid get plantId;@JsonKey(name: 'watered_at') Timestamp get wateredAt; WateringSource get source;
/// Create a copy of WateringEventFields
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WateringEventFieldsCopyWith<WateringEventFields> get copyWith => _$WateringEventFieldsCopyWithImpl<WateringEventFields>(this as WateringEventFields, _$identity);

  /// Serializes this WateringEventFields to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WateringEventFields;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WateringEventFields&&(identical(other.plantId, _this.plantId) || other.plantId == _this.plantId)&&(identical(other.wateredAt, _this.wateredAt) || other.wateredAt == _this.wateredAt)&&(identical(other.source, _this.source) || other.source == _this.source));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WateringEventFields;
  return Object.hash(runtimeType,_this.plantId,_this.wateredAt,_this.source);
}

@override
String toString() {
  final _this = this as WateringEventFields;
  return 'WateringEventFields(plantId: ${_this.plantId}, wateredAt: ${_this.wateredAt}, source: ${_this.source})';
}


}

/// @nodoc
abstract mixin class $WateringEventFieldsCopyWith<$Res>  {
  factory $WateringEventFieldsCopyWith(WateringEventFields value, $Res Function(WateringEventFields) _then) = _$WateringEventFieldsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'plant_id') Uuid plantId,@JsonKey(name: 'watered_at') Timestamp wateredAt, WateringSource source
});




}
/// @nodoc
class _$WateringEventFieldsCopyWithImpl<$Res>
    implements $WateringEventFieldsCopyWith<$Res> {
  _$WateringEventFieldsCopyWithImpl(this._self, this._then);

  final WateringEventFields _self;
  final $Res Function(WateringEventFields) _then;

/// Create a copy of WateringEventFields
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? plantId = null,Object? wateredAt = null,Object? source = null,}) {
  return _then(WateringEventFields(
plantId: null == plantId ? _self.plantId : plantId // ignore: cast_nullable_to_non_nullable
as Uuid,wateredAt: null == wateredAt ? _self.wateredAt : wateredAt // ignore: cast_nullable_to_non_nullable
as Timestamp,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as WateringSource,
  ));
}

}


/// Adds pattern-matching-related methods to [WateringEventFields].
extension WateringEventFieldsPatterns on WateringEventFields {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WateringEventFields value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WateringEventFields() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WateringEventFields value)  $default,){
final _that = this;
switch (_that) {
case _WateringEventFields():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WateringEventFields value)?  $default,){
final _that = this;
switch (_that) {
case _WateringEventFields() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'plant_id')  Uuid plantId, @JsonKey(name: 'watered_at')  Timestamp wateredAt,  WateringSource source)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WateringEventFields() when $default != null:
return $default(_that.plantId,_that.wateredAt,_that.source);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'plant_id')  Uuid plantId, @JsonKey(name: 'watered_at')  Timestamp wateredAt,  WateringSource source)  $default,) {final _that = this;
switch (_that) {
case _WateringEventFields():
return $default(_that.plantId,_that.wateredAt,_that.source);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'plant_id')  Uuid plantId, @JsonKey(name: 'watered_at')  Timestamp wateredAt,  WateringSource source)?  $default,) {final _that = this;
switch (_that) {
case _WateringEventFields() when $default != null:
return $default(_that.plantId,_that.wateredAt,_that.source);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WateringEventFields implements WateringEventFields {
  const _WateringEventFields({@JsonKey(name: 'plant_id') required this.plantId, @JsonKey(name: 'watered_at') required this.wateredAt, required this.source});
  factory _WateringEventFields.fromJson(Map<String, dynamic> json) => _$WateringEventFieldsFromJson(json);

@override@JsonKey(name: 'plant_id') final  Uuid plantId;
@override@JsonKey(name: 'watered_at') final  Timestamp wateredAt;
@override final  WateringSource source;

/// Create a copy of WateringEventFields
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WateringEventFieldsCopyWith<_WateringEventFields> get copyWith => __$WateringEventFieldsCopyWithImpl<_WateringEventFields>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WateringEventFieldsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WateringEventFields&&(identical(other.plantId, plantId) || other.plantId == plantId)&&(identical(other.wateredAt, wateredAt) || other.wateredAt == wateredAt)&&(identical(other.source, source) || other.source == source));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,plantId,wateredAt,source);
}

@override
String toString() {
    return 'WateringEventFields(plantId: $plantId, wateredAt: $wateredAt, source: $source)';
}


}

/// @nodoc
abstract mixin class _$WateringEventFieldsCopyWith<$Res> implements $WateringEventFieldsCopyWith<$Res> {
  factory _$WateringEventFieldsCopyWith(_WateringEventFields value, $Res Function(_WateringEventFields) _then) = __$WateringEventFieldsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'plant_id') Uuid plantId,@JsonKey(name: 'watered_at') Timestamp wateredAt, WateringSource source
});




}
/// @nodoc
class __$WateringEventFieldsCopyWithImpl<$Res>
    implements _$WateringEventFieldsCopyWith<$Res> {
  __$WateringEventFieldsCopyWithImpl(this._self, this._then);

  final _WateringEventFields _self;
  final $Res Function(_WateringEventFields) _then;

/// Create a copy of WateringEventFields
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? plantId = null,Object? wateredAt = null,Object? source = null,}) {
  return _then(_WateringEventFields(
plantId: null == plantId ? _self.plantId : plantId // ignore: cast_nullable_to_non_nullable
as Uuid,wateredAt: null == wateredAt ? _self.wateredAt : wateredAt // ignore: cast_nullable_to_non_nullable
as Timestamp,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as WateringSource,
  ));
}


}

// dart format on
