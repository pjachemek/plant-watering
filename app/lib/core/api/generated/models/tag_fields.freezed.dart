// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tag_fields.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TagFields {

 TagToken? get token;@JsonKey(name: 'plant_id') Uuid? get plantId;@JsonKey(name: 'written_at') Timestamp? get writtenAt;
/// Create a copy of TagFields
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TagFieldsCopyWith<TagFields> get copyWith => _$TagFieldsCopyWithImpl<TagFields>(this as TagFields, _$identity);

  /// Serializes this TagFields to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TagFields;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TagFields&&(identical(other.token, _this.token) || other.token == _this.token)&&(identical(other.plantId, _this.plantId) || other.plantId == _this.plantId)&&(identical(other.writtenAt, _this.writtenAt) || other.writtenAt == _this.writtenAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TagFields;
  return Object.hash(runtimeType,_this.token,_this.plantId,_this.writtenAt);
}

@override
String toString() {
  final _this = this as TagFields;
  return 'TagFields(token: ${_this.token}, plantId: ${_this.plantId}, writtenAt: ${_this.writtenAt})';
}


}

/// @nodoc
abstract mixin class $TagFieldsCopyWith<$Res>  {
  factory $TagFieldsCopyWith(TagFields value, $Res Function(TagFields) _then) = _$TagFieldsCopyWithImpl;
@useResult
$Res call({
 TagToken? token,@JsonKey(name: 'plant_id') Uuid? plantId,@JsonKey(name: 'written_at') Timestamp? writtenAt
});




}
/// @nodoc
class _$TagFieldsCopyWithImpl<$Res>
    implements $TagFieldsCopyWith<$Res> {
  _$TagFieldsCopyWithImpl(this._self, this._then);

  final TagFields _self;
  final $Res Function(TagFields) _then;

/// Create a copy of TagFields
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? token = freezed,Object? plantId = freezed,Object? writtenAt = freezed,}) {
  return _then(TagFields(
token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as TagToken?,plantId: freezed == plantId ? _self.plantId : plantId // ignore: cast_nullable_to_non_nullable
as Uuid?,writtenAt: freezed == writtenAt ? _self.writtenAt : writtenAt // ignore: cast_nullable_to_non_nullable
as Timestamp?,
  ));
}

}


/// Adds pattern-matching-related methods to [TagFields].
extension TagFieldsPatterns on TagFields {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TagFields value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TagFields() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TagFields value)  $default,){
final _that = this;
switch (_that) {
case _TagFields():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TagFields value)?  $default,){
final _that = this;
switch (_that) {
case _TagFields() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TagToken? token, @JsonKey(name: 'plant_id')  Uuid? plantId, @JsonKey(name: 'written_at')  Timestamp? writtenAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TagFields() when $default != null:
return $default(_that.token,_that.plantId,_that.writtenAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TagToken? token, @JsonKey(name: 'plant_id')  Uuid? plantId, @JsonKey(name: 'written_at')  Timestamp? writtenAt)  $default,) {final _that = this;
switch (_that) {
case _TagFields():
return $default(_that.token,_that.plantId,_that.writtenAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TagToken? token, @JsonKey(name: 'plant_id')  Uuid? plantId, @JsonKey(name: 'written_at')  Timestamp? writtenAt)?  $default,) {final _that = this;
switch (_that) {
case _TagFields() when $default != null:
return $default(_that.token,_that.plantId,_that.writtenAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TagFields implements TagFields {
  const _TagFields({this.token, @JsonKey(name: 'plant_id') this.plantId, @JsonKey(name: 'written_at') this.writtenAt});
  factory _TagFields.fromJson(Map<String, dynamic> json) => _$TagFieldsFromJson(json);

@override final  TagToken? token;
@override@JsonKey(name: 'plant_id') final  Uuid? plantId;
@override@JsonKey(name: 'written_at') final  Timestamp? writtenAt;

/// Create a copy of TagFields
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TagFieldsCopyWith<_TagFields> get copyWith => __$TagFieldsCopyWithImpl<_TagFields>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TagFieldsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TagFields&&(identical(other.token, token) || other.token == token)&&(identical(other.plantId, plantId) || other.plantId == plantId)&&(identical(other.writtenAt, writtenAt) || other.writtenAt == writtenAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,token,plantId,writtenAt);
}

@override
String toString() {
    return 'TagFields(token: $token, plantId: $plantId, writtenAt: $writtenAt)';
}


}

/// @nodoc
abstract mixin class _$TagFieldsCopyWith<$Res> implements $TagFieldsCopyWith<$Res> {
  factory _$TagFieldsCopyWith(_TagFields value, $Res Function(_TagFields) _then) = __$TagFieldsCopyWithImpl;
@override @useResult
$Res call({
 TagToken? token,@JsonKey(name: 'plant_id') Uuid? plantId,@JsonKey(name: 'written_at') Timestamp? writtenAt
});




}
/// @nodoc
class __$TagFieldsCopyWithImpl<$Res>
    implements _$TagFieldsCopyWith<$Res> {
  __$TagFieldsCopyWithImpl(this._self, this._then);

  final _TagFields _self;
  final $Res Function(_TagFields) _then;

/// Create a copy of TagFields
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? token = freezed,Object? plantId = freezed,Object? writtenAt = freezed,}) {
  return _then(_TagFields(
token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as TagToken?,plantId: freezed == plantId ? _self.plantId : plantId // ignore: cast_nullable_to_non_nullable
as Uuid?,writtenAt: freezed == writtenAt ? _self.writtenAt : writtenAt // ignore: cast_nullable_to_non_nullable
as Timestamp?,
  ));
}


}

// dart format on
