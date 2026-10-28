// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tag.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Tag {

 Uuid get id;@JsonKey(name: 'household_id') Uuid get householdId;@JsonKey(name: 'updated_at') Timestamp get updatedAt; TagToken? get token;@JsonKey(name: 'plant_id') Uuid? get plantId;@JsonKey(name: 'written_at') Timestamp? get writtenAt;@JsonKey(name: 'written_by') Uuid? get writtenBy;@JsonKey(name: 'deleted_at') Timestamp? get deletedAt;
/// Create a copy of Tag
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TagCopyWith<Tag> get copyWith => _$TagCopyWithImpl<Tag>(this as Tag, _$identity);

  /// Serializes this Tag to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Tag;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Tag&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.householdId, _this.householdId) || other.householdId == _this.householdId)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.token, _this.token) || other.token == _this.token)&&(identical(other.plantId, _this.plantId) || other.plantId == _this.plantId)&&(identical(other.writtenAt, _this.writtenAt) || other.writtenAt == _this.writtenAt)&&(identical(other.writtenBy, _this.writtenBy) || other.writtenBy == _this.writtenBy)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Tag;
  return Object.hash(runtimeType,_this.id,_this.householdId,_this.updatedAt,_this.token,_this.plantId,_this.writtenAt,_this.writtenBy,_this.deletedAt);
}

@override
String toString() {
  final _this = this as Tag;
  return 'Tag(id: ${_this.id}, householdId: ${_this.householdId}, updatedAt: ${_this.updatedAt}, token: ${_this.token}, plantId: ${_this.plantId}, writtenAt: ${_this.writtenAt}, writtenBy: ${_this.writtenBy}, deletedAt: ${_this.deletedAt})';
}


}

/// @nodoc
abstract mixin class $TagCopyWith<$Res>  {
  factory $TagCopyWith(Tag value, $Res Function(Tag) _then) = _$TagCopyWithImpl;
@useResult
$Res call({
 Uuid id,@JsonKey(name: 'household_id') Uuid householdId,@JsonKey(name: 'updated_at') Timestamp updatedAt, TagToken? token,@JsonKey(name: 'plant_id') Uuid? plantId,@JsonKey(name: 'written_at') Timestamp? writtenAt,@JsonKey(name: 'written_by') Uuid? writtenBy,@JsonKey(name: 'deleted_at') Timestamp? deletedAt
});




}
/// @nodoc
class _$TagCopyWithImpl<$Res>
    implements $TagCopyWith<$Res> {
  _$TagCopyWithImpl(this._self, this._then);

  final Tag _self;
  final $Res Function(Tag) _then;

/// Create a copy of Tag
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? householdId = null,Object? updatedAt = null,Object? token = freezed,Object? plantId = freezed,Object? writtenAt = freezed,Object? writtenBy = freezed,Object? deletedAt = freezed,}) {
  return _then(Tag(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as Uuid,householdId: null == householdId ? _self.householdId : householdId // ignore: cast_nullable_to_non_nullable
as Uuid,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as Timestamp,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as TagToken?,plantId: freezed == plantId ? _self.plantId : plantId // ignore: cast_nullable_to_non_nullable
as Uuid?,writtenAt: freezed == writtenAt ? _self.writtenAt : writtenAt // ignore: cast_nullable_to_non_nullable
as Timestamp?,writtenBy: freezed == writtenBy ? _self.writtenBy : writtenBy // ignore: cast_nullable_to_non_nullable
as Uuid?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as Timestamp?,
  ));
}

}


/// Adds pattern-matching-related methods to [Tag].
extension TagPatterns on Tag {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Tag value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Tag() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Tag value)  $default,){
final _that = this;
switch (_that) {
case _Tag():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Tag value)?  $default,){
final _that = this;
switch (_that) {
case _Tag() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Uuid id, @JsonKey(name: 'household_id')  Uuid householdId, @JsonKey(name: 'updated_at')  Timestamp updatedAt,  TagToken? token, @JsonKey(name: 'plant_id')  Uuid? plantId, @JsonKey(name: 'written_at')  Timestamp? writtenAt, @JsonKey(name: 'written_by')  Uuid? writtenBy, @JsonKey(name: 'deleted_at')  Timestamp? deletedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Tag() when $default != null:
return $default(_that.id,_that.householdId,_that.updatedAt,_that.token,_that.plantId,_that.writtenAt,_that.writtenBy,_that.deletedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Uuid id, @JsonKey(name: 'household_id')  Uuid householdId, @JsonKey(name: 'updated_at')  Timestamp updatedAt,  TagToken? token, @JsonKey(name: 'plant_id')  Uuid? plantId, @JsonKey(name: 'written_at')  Timestamp? writtenAt, @JsonKey(name: 'written_by')  Uuid? writtenBy, @JsonKey(name: 'deleted_at')  Timestamp? deletedAt)  $default,) {final _that = this;
switch (_that) {
case _Tag():
return $default(_that.id,_that.householdId,_that.updatedAt,_that.token,_that.plantId,_that.writtenAt,_that.writtenBy,_that.deletedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Uuid id, @JsonKey(name: 'household_id')  Uuid householdId, @JsonKey(name: 'updated_at')  Timestamp updatedAt,  TagToken? token, @JsonKey(name: 'plant_id')  Uuid? plantId, @JsonKey(name: 'written_at')  Timestamp? writtenAt, @JsonKey(name: 'written_by')  Uuid? writtenBy, @JsonKey(name: 'deleted_at')  Timestamp? deletedAt)?  $default,) {final _that = this;
switch (_that) {
case _Tag() when $default != null:
return $default(_that.id,_that.householdId,_that.updatedAt,_that.token,_that.plantId,_that.writtenAt,_that.writtenBy,_that.deletedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Tag implements Tag {
  const _Tag({required this.id, @JsonKey(name: 'household_id') required this.householdId, @JsonKey(name: 'updated_at') required this.updatedAt, this.token, @JsonKey(name: 'plant_id') this.plantId, @JsonKey(name: 'written_at') this.writtenAt, @JsonKey(name: 'written_by') this.writtenBy, @JsonKey(name: 'deleted_at') this.deletedAt});
  factory _Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

@override final  Uuid id;
@override@JsonKey(name: 'household_id') final  Uuid householdId;
@override@JsonKey(name: 'updated_at') final  Timestamp updatedAt;
@override final  TagToken? token;
@override@JsonKey(name: 'plant_id') final  Uuid? plantId;
@override@JsonKey(name: 'written_at') final  Timestamp? writtenAt;
@override@JsonKey(name: 'written_by') final  Uuid? writtenBy;
@override@JsonKey(name: 'deleted_at') final  Timestamp? deletedAt;

/// Create a copy of Tag
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TagCopyWith<_Tag> get copyWith => __$TagCopyWithImpl<_Tag>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TagToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Tag&&(identical(other.id, id) || other.id == id)&&(identical(other.householdId, householdId) || other.householdId == householdId)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.token, token) || other.token == token)&&(identical(other.plantId, plantId) || other.plantId == plantId)&&(identical(other.writtenAt, writtenAt) || other.writtenAt == writtenAt)&&(identical(other.writtenBy, writtenBy) || other.writtenBy == writtenBy)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,householdId,updatedAt,token,plantId,writtenAt,writtenBy,deletedAt);
}

@override
String toString() {
    return 'Tag(id: $id, householdId: $householdId, updatedAt: $updatedAt, token: $token, plantId: $plantId, writtenAt: $writtenAt, writtenBy: $writtenBy, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class _$TagCopyWith<$Res> implements $TagCopyWith<$Res> {
  factory _$TagCopyWith(_Tag value, $Res Function(_Tag) _then) = __$TagCopyWithImpl;
@override @useResult
$Res call({
 Uuid id,@JsonKey(name: 'household_id') Uuid householdId,@JsonKey(name: 'updated_at') Timestamp updatedAt, TagToken? token,@JsonKey(name: 'plant_id') Uuid? plantId,@JsonKey(name: 'written_at') Timestamp? writtenAt,@JsonKey(name: 'written_by') Uuid? writtenBy,@JsonKey(name: 'deleted_at') Timestamp? deletedAt
});




}
/// @nodoc
class __$TagCopyWithImpl<$Res>
    implements _$TagCopyWith<$Res> {
  __$TagCopyWithImpl(this._self, this._then);

  final _Tag _self;
  final $Res Function(_Tag) _then;

/// Create a copy of Tag
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? householdId = null,Object? updatedAt = null,Object? token = freezed,Object? plantId = freezed,Object? writtenAt = freezed,Object? writtenBy = freezed,Object? deletedAt = freezed,}) {
  return _then(_Tag(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as Uuid,householdId: null == householdId ? _self.householdId : householdId // ignore: cast_nullable_to_non_nullable
as Uuid,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as Timestamp,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as TagToken?,plantId: freezed == plantId ? _self.plantId : plantId // ignore: cast_nullable_to_non_nullable
as Uuid?,writtenAt: freezed == writtenAt ? _self.writtenAt : writtenAt // ignore: cast_nullable_to_non_nullable
as Timestamp?,writtenBy: freezed == writtenBy ? _self.writtenBy : writtenBy // ignore: cast_nullable_to_non_nullable
as Uuid?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as Timestamp?,
  ));
}


}

// dart format on
