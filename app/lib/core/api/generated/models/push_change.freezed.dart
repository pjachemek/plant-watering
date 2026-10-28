// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'push_change.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PushChange {

@JsonKey(name: 'change_id') Uuid get changeId; SyncEntity get entity; SyncOp get op;/// The row id (client-generated UUID v7 for new rows).
 Uuid get id; List<String>? get fields; HouseholdFields? get household; PlantFields? get plant; TagFields? get tag;@JsonKey(name: 'watering_event') WateringEventFields? get wateringEvent;
/// Create a copy of PushChange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PushChangeCopyWith<PushChange> get copyWith => _$PushChangeCopyWithImpl<PushChange>(this as PushChange, _$identity);

  /// Serializes this PushChange to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PushChange;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PushChange&&(identical(other.changeId, _this.changeId) || other.changeId == _this.changeId)&&(identical(other.entity, _this.entity) || other.entity == _this.entity)&&(identical(other.op, _this.op) || other.op == _this.op)&&(identical(other.id, _this.id) || other.id == _this.id)&&const DeepCollectionEquality().equals(other.fields, _this.fields)&&(identical(other.household, _this.household) || other.household == _this.household)&&(identical(other.plant, _this.plant) || other.plant == _this.plant)&&(identical(other.tag, _this.tag) || other.tag == _this.tag)&&(identical(other.wateringEvent, _this.wateringEvent) || other.wateringEvent == _this.wateringEvent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PushChange;
  return Object.hash(runtimeType,_this.changeId,_this.entity,_this.op,_this.id,const DeepCollectionEquality().hash(_this.fields),_this.household,_this.plant,_this.tag,_this.wateringEvent);
}

@override
String toString() {
  final _this = this as PushChange;
  return 'PushChange(changeId: ${_this.changeId}, entity: ${_this.entity}, op: ${_this.op}, id: ${_this.id}, fields: ${_this.fields}, household: ${_this.household}, plant: ${_this.plant}, tag: ${_this.tag}, wateringEvent: ${_this.wateringEvent})';
}


}

/// @nodoc
abstract mixin class $PushChangeCopyWith<$Res>  {
  factory $PushChangeCopyWith(PushChange value, $Res Function(PushChange) _then) = _$PushChangeCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'change_id') Uuid changeId, SyncEntity entity, SyncOp op, Uuid id, List<String>? fields, HouseholdFields? household, PlantFields? plant, TagFields? tag,@JsonKey(name: 'watering_event') WateringEventFields? wateringEvent
});


$HouseholdFieldsCopyWith<$Res>? get household;$PlantFieldsCopyWith<$Res>? get plant;$TagFieldsCopyWith<$Res>? get tag;$WateringEventFieldsCopyWith<$Res>? get wateringEvent;

}
/// @nodoc
class _$PushChangeCopyWithImpl<$Res>
    implements $PushChangeCopyWith<$Res> {
  _$PushChangeCopyWithImpl(this._self, this._then);

  final PushChange _self;
  final $Res Function(PushChange) _then;

/// Create a copy of PushChange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? changeId = null,Object? entity = null,Object? op = null,Object? id = null,Object? fields = freezed,Object? household = freezed,Object? plant = freezed,Object? tag = freezed,Object? wateringEvent = freezed,}) {
  return _then(PushChange(
changeId: null == changeId ? _self.changeId : changeId // ignore: cast_nullable_to_non_nullable
as Uuid,entity: null == entity ? _self.entity : entity // ignore: cast_nullable_to_non_nullable
as SyncEntity,op: null == op ? _self.op : op // ignore: cast_nullable_to_non_nullable
as SyncOp,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as Uuid,fields: freezed == fields ? _self.fields : fields // ignore: cast_nullable_to_non_nullable
as List<String>?,household: freezed == household ? _self.household : household // ignore: cast_nullable_to_non_nullable
as HouseholdFields?,plant: freezed == plant ? _self.plant : plant // ignore: cast_nullable_to_non_nullable
as PlantFields?,tag: freezed == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as TagFields?,wateringEvent: freezed == wateringEvent ? _self.wateringEvent : wateringEvent // ignore: cast_nullable_to_non_nullable
as WateringEventFields?,
  ));
}
/// Create a copy of PushChange
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HouseholdFieldsCopyWith<$Res>? get household {
    if (_self.household == null) {
    return null;
  }

  return $HouseholdFieldsCopyWith<$Res>(_self.household!, (value) {
    return _then(_self.copyWith(household: value));
  });
}/// Create a copy of PushChange
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlantFieldsCopyWith<$Res>? get plant {
    if (_self.plant == null) {
    return null;
  }

  return $PlantFieldsCopyWith<$Res>(_self.plant!, (value) {
    return _then(_self.copyWith(plant: value));
  });
}/// Create a copy of PushChange
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TagFieldsCopyWith<$Res>? get tag {
    if (_self.tag == null) {
    return null;
  }

  return $TagFieldsCopyWith<$Res>(_self.tag!, (value) {
    return _then(_self.copyWith(tag: value));
  });
}/// Create a copy of PushChange
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WateringEventFieldsCopyWith<$Res>? get wateringEvent {
    if (_self.wateringEvent == null) {
    return null;
  }

  return $WateringEventFieldsCopyWith<$Res>(_self.wateringEvent!, (value) {
    return _then(_self.copyWith(wateringEvent: value));
  });
}
}


/// Adds pattern-matching-related methods to [PushChange].
extension PushChangePatterns on PushChange {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PushChange value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PushChange() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PushChange value)  $default,){
final _that = this;
switch (_that) {
case _PushChange():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PushChange value)?  $default,){
final _that = this;
switch (_that) {
case _PushChange() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'change_id')  Uuid changeId,  SyncEntity entity,  SyncOp op,  Uuid id,  List<String>? fields,  HouseholdFields? household,  PlantFields? plant,  TagFields? tag, @JsonKey(name: 'watering_event')  WateringEventFields? wateringEvent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PushChange() when $default != null:
return $default(_that.changeId,_that.entity,_that.op,_that.id,_that.fields,_that.household,_that.plant,_that.tag,_that.wateringEvent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'change_id')  Uuid changeId,  SyncEntity entity,  SyncOp op,  Uuid id,  List<String>? fields,  HouseholdFields? household,  PlantFields? plant,  TagFields? tag, @JsonKey(name: 'watering_event')  WateringEventFields? wateringEvent)  $default,) {final _that = this;
switch (_that) {
case _PushChange():
return $default(_that.changeId,_that.entity,_that.op,_that.id,_that.fields,_that.household,_that.plant,_that.tag,_that.wateringEvent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'change_id')  Uuid changeId,  SyncEntity entity,  SyncOp op,  Uuid id,  List<String>? fields,  HouseholdFields? household,  PlantFields? plant,  TagFields? tag, @JsonKey(name: 'watering_event')  WateringEventFields? wateringEvent)?  $default,) {final _that = this;
switch (_that) {
case _PushChange() when $default != null:
return $default(_that.changeId,_that.entity,_that.op,_that.id,_that.fields,_that.household,_that.plant,_that.tag,_that.wateringEvent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PushChange implements PushChange {
  const _PushChange({@JsonKey(name: 'change_id') required this.changeId, required this.entity, required this.op, required this.id,  List<String>? fields, this.household, this.plant, this.tag, @JsonKey(name: 'watering_event') this.wateringEvent}): _fields = fields;
  factory _PushChange.fromJson(Map<String, dynamic> json) => _$PushChangeFromJson(json);

@override@JsonKey(name: 'change_id') final  Uuid changeId;
@override final  SyncEntity entity;
@override final  SyncOp op;
/// The row id (client-generated UUID v7 for new rows).
@override final  Uuid id;
 final  List<String>? _fields;
@override List<String>? get fields {
  final value = _fields;
  if (value == null) return null;
  if (_fields is EqualUnmodifiableListView) return _fields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  HouseholdFields? household;
@override final  PlantFields? plant;
@override final  TagFields? tag;
@override@JsonKey(name: 'watering_event') final  WateringEventFields? wateringEvent;

/// Create a copy of PushChange
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PushChangeCopyWith<_PushChange> get copyWith => __$PushChangeCopyWithImpl<_PushChange>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PushChangeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PushChange&&(identical(other.changeId, changeId) || other.changeId == changeId)&&(identical(other.entity, entity) || other.entity == entity)&&(identical(other.op, op) || other.op == op)&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.fields, _fields)&&(identical(other.household, household) || other.household == household)&&(identical(other.plant, plant) || other.plant == plant)&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.wateringEvent, wateringEvent) || other.wateringEvent == wateringEvent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,changeId,entity,op,id,const DeepCollectionEquality().hash(_fields),household,plant,tag,wateringEvent);
}

@override
String toString() {
    return 'PushChange(changeId: $changeId, entity: $entity, op: $op, id: $id, fields: $fields, household: $household, plant: $plant, tag: $tag, wateringEvent: $wateringEvent)';
}


}

/// @nodoc
abstract mixin class _$PushChangeCopyWith<$Res> implements $PushChangeCopyWith<$Res> {
  factory _$PushChangeCopyWith(_PushChange value, $Res Function(_PushChange) _then) = __$PushChangeCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'change_id') Uuid changeId, SyncEntity entity, SyncOp op, Uuid id, List<String>? fields, HouseholdFields? household, PlantFields? plant, TagFields? tag,@JsonKey(name: 'watering_event') WateringEventFields? wateringEvent
});


@override $HouseholdFieldsCopyWith<$Res>? get household;@override $PlantFieldsCopyWith<$Res>? get plant;@override $TagFieldsCopyWith<$Res>? get tag;@override $WateringEventFieldsCopyWith<$Res>? get wateringEvent;

}
/// @nodoc
class __$PushChangeCopyWithImpl<$Res>
    implements _$PushChangeCopyWith<$Res> {
  __$PushChangeCopyWithImpl(this._self, this._then);

  final _PushChange _self;
  final $Res Function(_PushChange) _then;

/// Create a copy of PushChange
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? changeId = null,Object? entity = null,Object? op = null,Object? id = null,Object? fields = freezed,Object? household = freezed,Object? plant = freezed,Object? tag = freezed,Object? wateringEvent = freezed,}) {
  return _then(_PushChange(
changeId: null == changeId ? _self.changeId : changeId // ignore: cast_nullable_to_non_nullable
as Uuid,entity: null == entity ? _self.entity : entity // ignore: cast_nullable_to_non_nullable
as SyncEntity,op: null == op ? _self.op : op // ignore: cast_nullable_to_non_nullable
as SyncOp,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as Uuid,fields: freezed == fields ? _self._fields : fields // ignore: cast_nullable_to_non_nullable
as List<String>?,household: freezed == household ? _self.household : household // ignore: cast_nullable_to_non_nullable
as HouseholdFields?,plant: freezed == plant ? _self.plant : plant // ignore: cast_nullable_to_non_nullable
as PlantFields?,tag: freezed == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as TagFields?,wateringEvent: freezed == wateringEvent ? _self.wateringEvent : wateringEvent // ignore: cast_nullable_to_non_nullable
as WateringEventFields?,
  ));
}

/// Create a copy of PushChange
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HouseholdFieldsCopyWith<$Res>? get household {
    if (_self.household == null) {
    return null;
  }

  return $HouseholdFieldsCopyWith<$Res>(_self.household!, (value) {
    return _then(_self.copyWith(household: value));
  });
}/// Create a copy of PushChange
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlantFieldsCopyWith<$Res>? get plant {
    if (_self.plant == null) {
    return null;
  }

  return $PlantFieldsCopyWith<$Res>(_self.plant!, (value) {
    return _then(_self.copyWith(plant: value));
  });
}/// Create a copy of PushChange
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TagFieldsCopyWith<$Res>? get tag {
    if (_self.tag == null) {
    return null;
  }

  return $TagFieldsCopyWith<$Res>(_self.tag!, (value) {
    return _then(_self.copyWith(tag: value));
  });
}/// Create a copy of PushChange
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WateringEventFieldsCopyWith<$Res>? get wateringEvent {
    if (_self.wateringEvent == null) {
    return null;
  }

  return $WateringEventFieldsCopyWith<$Res>(_self.wateringEvent!, (value) {
    return _then(_self.copyWith(wateringEvent: value));
  });
}
}

// dart format on
