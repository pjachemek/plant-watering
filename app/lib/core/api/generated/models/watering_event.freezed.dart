// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'watering_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WateringEvent {

@JsonKey(name: 'plant_id') Uuid get plantId;@JsonKey(name: 'watered_at') Timestamp get wateredAt; WateringSource get source; Uuid get id;@JsonKey(name: 'household_id') Uuid get householdId;@JsonKey(name: 'created_at') Timestamp get createdAt;/// Null after the author deleted their account.
@JsonKey(name: 'user_id') Uuid? get userId;/// Set when the watering was undone.
@JsonKey(name: 'deleted_at') Timestamp? get deletedAt;
/// Create a copy of WateringEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WateringEventCopyWith<WateringEvent> get copyWith => _$WateringEventCopyWithImpl<WateringEvent>(this as WateringEvent, _$identity);

  /// Serializes this WateringEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WateringEvent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WateringEvent&&(identical(other.plantId, _this.plantId) || other.plantId == _this.plantId)&&(identical(other.wateredAt, _this.wateredAt) || other.wateredAt == _this.wateredAt)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.householdId, _this.householdId) || other.householdId == _this.householdId)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WateringEvent;
  return Object.hash(runtimeType,_this.plantId,_this.wateredAt,_this.source,_this.id,_this.householdId,_this.createdAt,_this.userId,_this.deletedAt);
}

@override
String toString() {
  final _this = this as WateringEvent;
  return 'WateringEvent(plantId: ${_this.plantId}, wateredAt: ${_this.wateredAt}, source: ${_this.source}, id: ${_this.id}, householdId: ${_this.householdId}, createdAt: ${_this.createdAt}, userId: ${_this.userId}, deletedAt: ${_this.deletedAt})';
}


}

/// @nodoc
abstract mixin class $WateringEventCopyWith<$Res>  {
  factory $WateringEventCopyWith(WateringEvent value, $Res Function(WateringEvent) _then) = _$WateringEventCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'plant_id') Uuid plantId,@JsonKey(name: 'watered_at') Timestamp wateredAt, WateringSource source, Uuid id,@JsonKey(name: 'household_id') Uuid householdId,@JsonKey(name: 'created_at') Timestamp createdAt,@JsonKey(name: 'user_id') Uuid? userId,@JsonKey(name: 'deleted_at') Timestamp? deletedAt
});




}
/// @nodoc
class _$WateringEventCopyWithImpl<$Res>
    implements $WateringEventCopyWith<$Res> {
  _$WateringEventCopyWithImpl(this._self, this._then);

  final WateringEvent _self;
  final $Res Function(WateringEvent) _then;

/// Create a copy of WateringEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? plantId = null,Object? wateredAt = null,Object? source = null,Object? id = null,Object? householdId = null,Object? createdAt = null,Object? userId = freezed,Object? deletedAt = freezed,}) {
  return _then(WateringEvent(
plantId: null == plantId ? _self.plantId : plantId // ignore: cast_nullable_to_non_nullable
as Uuid,wateredAt: null == wateredAt ? _self.wateredAt : wateredAt // ignore: cast_nullable_to_non_nullable
as Timestamp,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as WateringSource,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as Uuid,householdId: null == householdId ? _self.householdId : householdId // ignore: cast_nullable_to_non_nullable
as Uuid,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as Timestamp,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as Uuid?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as Timestamp?,
  ));
}

}


/// Adds pattern-matching-related methods to [WateringEvent].
extension WateringEventPatterns on WateringEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WateringEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WateringEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WateringEvent value)  $default,){
final _that = this;
switch (_that) {
case _WateringEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WateringEvent value)?  $default,){
final _that = this;
switch (_that) {
case _WateringEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'plant_id')  Uuid plantId, @JsonKey(name: 'watered_at')  Timestamp wateredAt,  WateringSource source,  Uuid id, @JsonKey(name: 'household_id')  Uuid householdId, @JsonKey(name: 'created_at')  Timestamp createdAt, @JsonKey(name: 'user_id')  Uuid? userId, @JsonKey(name: 'deleted_at')  Timestamp? deletedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WateringEvent() when $default != null:
return $default(_that.plantId,_that.wateredAt,_that.source,_that.id,_that.householdId,_that.createdAt,_that.userId,_that.deletedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'plant_id')  Uuid plantId, @JsonKey(name: 'watered_at')  Timestamp wateredAt,  WateringSource source,  Uuid id, @JsonKey(name: 'household_id')  Uuid householdId, @JsonKey(name: 'created_at')  Timestamp createdAt, @JsonKey(name: 'user_id')  Uuid? userId, @JsonKey(name: 'deleted_at')  Timestamp? deletedAt)  $default,) {final _that = this;
switch (_that) {
case _WateringEvent():
return $default(_that.plantId,_that.wateredAt,_that.source,_that.id,_that.householdId,_that.createdAt,_that.userId,_that.deletedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'plant_id')  Uuid plantId, @JsonKey(name: 'watered_at')  Timestamp wateredAt,  WateringSource source,  Uuid id, @JsonKey(name: 'household_id')  Uuid householdId, @JsonKey(name: 'created_at')  Timestamp createdAt, @JsonKey(name: 'user_id')  Uuid? userId, @JsonKey(name: 'deleted_at')  Timestamp? deletedAt)?  $default,) {final _that = this;
switch (_that) {
case _WateringEvent() when $default != null:
return $default(_that.plantId,_that.wateredAt,_that.source,_that.id,_that.householdId,_that.createdAt,_that.userId,_that.deletedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WateringEvent implements WateringEvent {
  const _WateringEvent({@JsonKey(name: 'plant_id') required this.plantId, @JsonKey(name: 'watered_at') required this.wateredAt, required this.source, required this.id, @JsonKey(name: 'household_id') required this.householdId, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'user_id') this.userId, @JsonKey(name: 'deleted_at') this.deletedAt});
  factory _WateringEvent.fromJson(Map<String, dynamic> json) => _$WateringEventFromJson(json);

@override@JsonKey(name: 'plant_id') final  Uuid plantId;
@override@JsonKey(name: 'watered_at') final  Timestamp wateredAt;
@override final  WateringSource source;
@override final  Uuid id;
@override@JsonKey(name: 'household_id') final  Uuid householdId;
@override@JsonKey(name: 'created_at') final  Timestamp createdAt;
/// Null after the author deleted their account.
@override@JsonKey(name: 'user_id') final  Uuid? userId;
/// Set when the watering was undone.
@override@JsonKey(name: 'deleted_at') final  Timestamp? deletedAt;

/// Create a copy of WateringEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WateringEventCopyWith<_WateringEvent> get copyWith => __$WateringEventCopyWithImpl<_WateringEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WateringEventToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WateringEvent&&(identical(other.plantId, plantId) || other.plantId == plantId)&&(identical(other.wateredAt, wateredAt) || other.wateredAt == wateredAt)&&(identical(other.source, source) || other.source == source)&&(identical(other.id, id) || other.id == id)&&(identical(other.householdId, householdId) || other.householdId == householdId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,plantId,wateredAt,source,id,householdId,createdAt,userId,deletedAt);
}

@override
String toString() {
    return 'WateringEvent(plantId: $plantId, wateredAt: $wateredAt, source: $source, id: $id, householdId: $householdId, createdAt: $createdAt, userId: $userId, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class _$WateringEventCopyWith<$Res> implements $WateringEventCopyWith<$Res> {
  factory _$WateringEventCopyWith(_WateringEvent value, $Res Function(_WateringEvent) _then) = __$WateringEventCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'plant_id') Uuid plantId,@JsonKey(name: 'watered_at') Timestamp wateredAt, WateringSource source, Uuid id,@JsonKey(name: 'household_id') Uuid householdId,@JsonKey(name: 'created_at') Timestamp createdAt,@JsonKey(name: 'user_id') Uuid? userId,@JsonKey(name: 'deleted_at') Timestamp? deletedAt
});




}
/// @nodoc
class __$WateringEventCopyWithImpl<$Res>
    implements _$WateringEventCopyWith<$Res> {
  __$WateringEventCopyWithImpl(this._self, this._then);

  final _WateringEvent _self;
  final $Res Function(_WateringEvent) _then;

/// Create a copy of WateringEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? plantId = null,Object? wateredAt = null,Object? source = null,Object? id = null,Object? householdId = null,Object? createdAt = null,Object? userId = freezed,Object? deletedAt = freezed,}) {
  return _then(_WateringEvent(
plantId: null == plantId ? _self.plantId : plantId // ignore: cast_nullable_to_non_nullable
as Uuid,wateredAt: null == wateredAt ? _self.wateredAt : wateredAt // ignore: cast_nullable_to_non_nullable
as Timestamp,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as WateringSource,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as Uuid,householdId: null == householdId ? _self.householdId : householdId // ignore: cast_nullable_to_non_nullable
as Uuid,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as Timestamp,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as Uuid?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as Timestamp?,
  ));
}


}

// dart format on
