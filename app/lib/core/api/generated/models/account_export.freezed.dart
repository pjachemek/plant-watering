// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_export.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccountExport {

@JsonKey(name: 'exported_at') Timestamp get exportedAt;@JsonKey(name: 'user_id') Uuid get userId; List<Household> get households; List<Plant> get plants; List<Tag> get tags;@JsonKey(name: 'watering_events') List<WateringEvent> get wateringEvents;
/// Create a copy of AccountExport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountExportCopyWith<AccountExport> get copyWith => _$AccountExportCopyWithImpl<AccountExport>(this as AccountExport, _$identity);

  /// Serializes this AccountExport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AccountExport;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountExport&&(identical(other.exportedAt, _this.exportedAt) || other.exportedAt == _this.exportedAt)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&const DeepCollectionEquality().equals(other.households, _this.households)&&const DeepCollectionEquality().equals(other.plants, _this.plants)&&const DeepCollectionEquality().equals(other.tags, _this.tags)&&const DeepCollectionEquality().equals(other.wateringEvents, _this.wateringEvents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AccountExport;
  return Object.hash(runtimeType,_this.exportedAt,_this.userId,const DeepCollectionEquality().hash(_this.households),const DeepCollectionEquality().hash(_this.plants),const DeepCollectionEquality().hash(_this.tags),const DeepCollectionEquality().hash(_this.wateringEvents));
}

@override
String toString() {
  final _this = this as AccountExport;
  return 'AccountExport(exportedAt: ${_this.exportedAt}, userId: ${_this.userId}, households: ${_this.households}, plants: ${_this.plants}, tags: ${_this.tags}, wateringEvents: ${_this.wateringEvents})';
}


}

/// @nodoc
abstract mixin class $AccountExportCopyWith<$Res>  {
  factory $AccountExportCopyWith(AccountExport value, $Res Function(AccountExport) _then) = _$AccountExportCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'exported_at') Timestamp exportedAt,@JsonKey(name: 'user_id') Uuid userId, List<Household> households, List<Plant> plants, List<Tag> tags,@JsonKey(name: 'watering_events') List<WateringEvent> wateringEvents
});




}
/// @nodoc
class _$AccountExportCopyWithImpl<$Res>
    implements $AccountExportCopyWith<$Res> {
  _$AccountExportCopyWithImpl(this._self, this._then);

  final AccountExport _self;
  final $Res Function(AccountExport) _then;

/// Create a copy of AccountExport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? exportedAt = null,Object? userId = null,Object? households = null,Object? plants = null,Object? tags = null,Object? wateringEvents = null,}) {
  return _then(AccountExport(
exportedAt: null == exportedAt ? _self.exportedAt : exportedAt // ignore: cast_nullable_to_non_nullable
as Timestamp,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as Uuid,households: null == households ? _self.households : households // ignore: cast_nullable_to_non_nullable
as List<Household>,plants: null == plants ? _self.plants : plants // ignore: cast_nullable_to_non_nullable
as List<Plant>,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<Tag>,wateringEvents: null == wateringEvents ? _self.wateringEvents : wateringEvents // ignore: cast_nullable_to_non_nullable
as List<WateringEvent>,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountExport].
extension AccountExportPatterns on AccountExport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountExport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountExport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountExport value)  $default,){
final _that = this;
switch (_that) {
case _AccountExport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountExport value)?  $default,){
final _that = this;
switch (_that) {
case _AccountExport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'exported_at')  Timestamp exportedAt, @JsonKey(name: 'user_id')  Uuid userId,  List<Household> households,  List<Plant> plants,  List<Tag> tags, @JsonKey(name: 'watering_events')  List<WateringEvent> wateringEvents)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountExport() when $default != null:
return $default(_that.exportedAt,_that.userId,_that.households,_that.plants,_that.tags,_that.wateringEvents);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'exported_at')  Timestamp exportedAt, @JsonKey(name: 'user_id')  Uuid userId,  List<Household> households,  List<Plant> plants,  List<Tag> tags, @JsonKey(name: 'watering_events')  List<WateringEvent> wateringEvents)  $default,) {final _that = this;
switch (_that) {
case _AccountExport():
return $default(_that.exportedAt,_that.userId,_that.households,_that.plants,_that.tags,_that.wateringEvents);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'exported_at')  Timestamp exportedAt, @JsonKey(name: 'user_id')  Uuid userId,  List<Household> households,  List<Plant> plants,  List<Tag> tags, @JsonKey(name: 'watering_events')  List<WateringEvent> wateringEvents)?  $default,) {final _that = this;
switch (_that) {
case _AccountExport() when $default != null:
return $default(_that.exportedAt,_that.userId,_that.households,_that.plants,_that.tags,_that.wateringEvents);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AccountExport implements AccountExport {
  const _AccountExport({@JsonKey(name: 'exported_at') required this.exportedAt, @JsonKey(name: 'user_id') required this.userId, required  List<Household> households, required  List<Plant> plants, required  List<Tag> tags, @JsonKey(name: 'watering_events') required  List<WateringEvent> wateringEvents}): _households = households,_plants = plants,_tags = tags,_wateringEvents = wateringEvents;
  factory _AccountExport.fromJson(Map<String, dynamic> json) => _$AccountExportFromJson(json);

@override@JsonKey(name: 'exported_at') final  Timestamp exportedAt;
@override@JsonKey(name: 'user_id') final  Uuid userId;
 final  List<Household> _households;
@override List<Household> get households {
  if (_households is EqualUnmodifiableListView) return _households;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_households);
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


/// Create a copy of AccountExport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountExportCopyWith<_AccountExport> get copyWith => __$AccountExportCopyWithImpl<_AccountExport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountExportToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountExport&&(identical(other.exportedAt, exportedAt) || other.exportedAt == exportedAt)&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other.households, _households)&&const DeepCollectionEquality().equals(other.plants, _plants)&&const DeepCollectionEquality().equals(other.tags, _tags)&&const DeepCollectionEquality().equals(other.wateringEvents, _wateringEvents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,exportedAt,userId,const DeepCollectionEquality().hash(_households),const DeepCollectionEquality().hash(_plants),const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_wateringEvents));
}

@override
String toString() {
    return 'AccountExport(exportedAt: $exportedAt, userId: $userId, households: $households, plants: $plants, tags: $tags, wateringEvents: $wateringEvents)';
}


}

/// @nodoc
abstract mixin class _$AccountExportCopyWith<$Res> implements $AccountExportCopyWith<$Res> {
  factory _$AccountExportCopyWith(_AccountExport value, $Res Function(_AccountExport) _then) = __$AccountExportCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'exported_at') Timestamp exportedAt,@JsonKey(name: 'user_id') Uuid userId, List<Household> households, List<Plant> plants, List<Tag> tags,@JsonKey(name: 'watering_events') List<WateringEvent> wateringEvents
});




}
/// @nodoc
class __$AccountExportCopyWithImpl<$Res>
    implements _$AccountExportCopyWith<$Res> {
  __$AccountExportCopyWithImpl(this._self, this._then);

  final _AccountExport _self;
  final $Res Function(_AccountExport) _then;

/// Create a copy of AccountExport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? exportedAt = null,Object? userId = null,Object? households = null,Object? plants = null,Object? tags = null,Object? wateringEvents = null,}) {
  return _then(_AccountExport(
exportedAt: null == exportedAt ? _self.exportedAt : exportedAt // ignore: cast_nullable_to_non_nullable
as Timestamp,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as Uuid,households: null == households ? _self._households : households // ignore: cast_nullable_to_non_nullable
as List<Household>,plants: null == plants ? _self._plants : plants // ignore: cast_nullable_to_non_nullable
as List<Plant>,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<Tag>,wateringEvents: null == wateringEvents ? _self._wateringEvents : wateringEvents // ignore: cast_nullable_to_non_nullable
as List<WateringEvent>,
  ));
}


}

// dart format on
