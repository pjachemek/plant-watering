// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pull_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PullResponse {

 Cursor get cursor; Household get household; List<Member> get members; List<Plant> get plants; List<Tag> get tags;@JsonKey(name: 'watering_events') List<WateringEvent> get wateringEvents;
/// Create a copy of PullResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PullResponseCopyWith<PullResponse> get copyWith => _$PullResponseCopyWithImpl<PullResponse>(this as PullResponse, _$identity);

  /// Serializes this PullResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PullResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PullResponse&&(identical(other.cursor, _this.cursor) || other.cursor == _this.cursor)&&(identical(other.household, _this.household) || other.household == _this.household)&&const DeepCollectionEquality().equals(other.members, _this.members)&&const DeepCollectionEquality().equals(other.plants, _this.plants)&&const DeepCollectionEquality().equals(other.tags, _this.tags)&&const DeepCollectionEquality().equals(other.wateringEvents, _this.wateringEvents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PullResponse;
  return Object.hash(runtimeType,_this.cursor,_this.household,const DeepCollectionEquality().hash(_this.members),const DeepCollectionEquality().hash(_this.plants),const DeepCollectionEquality().hash(_this.tags),const DeepCollectionEquality().hash(_this.wateringEvents));
}

@override
String toString() {
  final _this = this as PullResponse;
  return 'PullResponse(cursor: ${_this.cursor}, household: ${_this.household}, members: ${_this.members}, plants: ${_this.plants}, tags: ${_this.tags}, wateringEvents: ${_this.wateringEvents})';
}


}

/// @nodoc
abstract mixin class $PullResponseCopyWith<$Res>  {
  factory $PullResponseCopyWith(PullResponse value, $Res Function(PullResponse) _then) = _$PullResponseCopyWithImpl;
@useResult
$Res call({
 Cursor cursor, Household household, List<Member> members, List<Plant> plants, List<Tag> tags,@JsonKey(name: 'watering_events') List<WateringEvent> wateringEvents
});


$HouseholdCopyWith<$Res> get household;

}
/// @nodoc
class _$PullResponseCopyWithImpl<$Res>
    implements $PullResponseCopyWith<$Res> {
  _$PullResponseCopyWithImpl(this._self, this._then);

  final PullResponse _self;
  final $Res Function(PullResponse) _then;

/// Create a copy of PullResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cursor = null,Object? household = null,Object? members = null,Object? plants = null,Object? tags = null,Object? wateringEvents = null,}) {
  return _then(PullResponse(
cursor: null == cursor ? _self.cursor : cursor // ignore: cast_nullable_to_non_nullable
as Cursor,household: null == household ? _self.household : household // ignore: cast_nullable_to_non_nullable
as Household,members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<Member>,plants: null == plants ? _self.plants : plants // ignore: cast_nullable_to_non_nullable
as List<Plant>,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<Tag>,wateringEvents: null == wateringEvents ? _self.wateringEvents : wateringEvents // ignore: cast_nullable_to_non_nullable
as List<WateringEvent>,
  ));
}
/// Create a copy of PullResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HouseholdCopyWith<$Res> get household {
  
  return $HouseholdCopyWith<$Res>(_self.household, (value) {
    return _then(_self.copyWith(household: value));
  });
}
}


/// Adds pattern-matching-related methods to [PullResponse].
extension PullResponsePatterns on PullResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PullResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PullResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PullResponse value)  $default,){
final _that = this;
switch (_that) {
case _PullResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PullResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PullResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Cursor cursor,  Household household,  List<Member> members,  List<Plant> plants,  List<Tag> tags, @JsonKey(name: 'watering_events')  List<WateringEvent> wateringEvents)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PullResponse() when $default != null:
return $default(_that.cursor,_that.household,_that.members,_that.plants,_that.tags,_that.wateringEvents);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Cursor cursor,  Household household,  List<Member> members,  List<Plant> plants,  List<Tag> tags, @JsonKey(name: 'watering_events')  List<WateringEvent> wateringEvents)  $default,) {final _that = this;
switch (_that) {
case _PullResponse():
return $default(_that.cursor,_that.household,_that.members,_that.plants,_that.tags,_that.wateringEvents);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Cursor cursor,  Household household,  List<Member> members,  List<Plant> plants,  List<Tag> tags, @JsonKey(name: 'watering_events')  List<WateringEvent> wateringEvents)?  $default,) {final _that = this;
switch (_that) {
case _PullResponse() when $default != null:
return $default(_that.cursor,_that.household,_that.members,_that.plants,_that.tags,_that.wateringEvents);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PullResponse implements PullResponse {
  const _PullResponse({required this.cursor, required this.household, required  List<Member> members, required  List<Plant> plants, required  List<Tag> tags, @JsonKey(name: 'watering_events') required  List<WateringEvent> wateringEvents}): _members = members,_plants = plants,_tags = tags,_wateringEvents = wateringEvents;
  factory _PullResponse.fromJson(Map<String, dynamic> json) => _$PullResponseFromJson(json);

@override final  Cursor cursor;
@override final  Household household;
 final  List<Member> _members;
@override List<Member> get members {
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_members);
}

 final  List<Plant> _plants;
@override List<Plant> get plants {
  if (_plants is EqualUnmodifiableListView) return _plants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_plants);
}

 final  List<Tag> _tags;
@override List<Tag> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

 final  List<WateringEvent> _wateringEvents;
@override@JsonKey(name: 'watering_events') List<WateringEvent> get wateringEvents {
  if (_wateringEvents is EqualUnmodifiableListView) return _wateringEvents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_wateringEvents);
}


/// Create a copy of PullResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PullResponseCopyWith<_PullResponse> get copyWith => __$PullResponseCopyWithImpl<_PullResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PullResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PullResponse&&(identical(other.cursor, cursor) || other.cursor == cursor)&&(identical(other.household, household) || other.household == household)&&const DeepCollectionEquality().equals(other.members, _members)&&const DeepCollectionEquality().equals(other.plants, _plants)&&const DeepCollectionEquality().equals(other.tags, _tags)&&const DeepCollectionEquality().equals(other.wateringEvents, _wateringEvents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,cursor,household,const DeepCollectionEquality().hash(_members),const DeepCollectionEquality().hash(_plants),const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_wateringEvents));
}

@override
String toString() {
    return 'PullResponse(cursor: $cursor, household: $household, members: $members, plants: $plants, tags: $tags, wateringEvents: $wateringEvents)';
}


}

/// @nodoc
abstract mixin class _$PullResponseCopyWith<$Res> implements $PullResponseCopyWith<$Res> {
  factory _$PullResponseCopyWith(_PullResponse value, $Res Function(_PullResponse) _then) = __$PullResponseCopyWithImpl;
@override @useResult
$Res call({
 Cursor cursor, Household household, List<Member> members, List<Plant> plants, List<Tag> tags,@JsonKey(name: 'watering_events') List<WateringEvent> wateringEvents
});


@override $HouseholdCopyWith<$Res> get household;

}
/// @nodoc
class __$PullResponseCopyWithImpl<$Res>
    implements _$PullResponseCopyWith<$Res> {
  __$PullResponseCopyWithImpl(this._self, this._then);

  final _PullResponse _self;
  final $Res Function(_PullResponse) _then;

/// Create a copy of PullResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cursor = null,Object? household = null,Object? members = null,Object? plants = null,Object? tags = null,Object? wateringEvents = null,}) {
  return _then(_PullResponse(
cursor: null == cursor ? _self.cursor : cursor // ignore: cast_nullable_to_non_nullable
as Cursor,household: null == household ? _self.household : household // ignore: cast_nullable_to_non_nullable
as Household,members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<Member>,plants: null == plants ? _self._plants : plants // ignore: cast_nullable_to_non_nullable
as List<Plant>,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<Tag>,wateringEvents: null == wateringEvents ? _self._wateringEvents : wateringEvents // ignore: cast_nullable_to_non_nullable
as List<WateringEvent>,
  ));
}

/// Create a copy of PullResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HouseholdCopyWith<$Res> get household {
  
  return $HouseholdCopyWith<$Res>(_self.household, (value) {
    return _then(_self.copyWith(household: value));
  });
}
}

// dart format on
