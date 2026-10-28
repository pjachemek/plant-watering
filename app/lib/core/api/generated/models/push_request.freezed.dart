// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'push_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PushRequest {

@JsonKey(name: 'household_id') Uuid get householdId; List<PushChange> get changes;
/// Create a copy of PushRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PushRequestCopyWith<PushRequest> get copyWith => _$PushRequestCopyWithImpl<PushRequest>(this as PushRequest, _$identity);

  /// Serializes this PushRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PushRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PushRequest&&(identical(other.householdId, _this.householdId) || other.householdId == _this.householdId)&&const DeepCollectionEquality().equals(other.changes, _this.changes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PushRequest;
  return Object.hash(runtimeType,_this.householdId,const DeepCollectionEquality().hash(_this.changes));
}

@override
String toString() {
  final _this = this as PushRequest;
  return 'PushRequest(householdId: ${_this.householdId}, changes: ${_this.changes})';
}


}

/// @nodoc
abstract mixin class $PushRequestCopyWith<$Res>  {
  factory $PushRequestCopyWith(PushRequest value, $Res Function(PushRequest) _then) = _$PushRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'household_id') Uuid householdId, List<PushChange> changes
});




}
/// @nodoc
class _$PushRequestCopyWithImpl<$Res>
    implements $PushRequestCopyWith<$Res> {
  _$PushRequestCopyWithImpl(this._self, this._then);

  final PushRequest _self;
  final $Res Function(PushRequest) _then;

/// Create a copy of PushRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? householdId = null,Object? changes = null,}) {
  return _then(PushRequest(
householdId: null == householdId ? _self.householdId : householdId // ignore: cast_nullable_to_non_nullable
as Uuid,changes: null == changes ? _self.changes : changes // ignore: cast_nullable_to_non_nullable
as List<PushChange>,
  ));
}

}


/// Adds pattern-matching-related methods to [PushRequest].
extension PushRequestPatterns on PushRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PushRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PushRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PushRequest value)  $default,){
final _that = this;
switch (_that) {
case _PushRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PushRequest value)?  $default,){
final _that = this;
switch (_that) {
case _PushRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'household_id')  Uuid householdId,  List<PushChange> changes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PushRequest() when $default != null:
return $default(_that.householdId,_that.changes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'household_id')  Uuid householdId,  List<PushChange> changes)  $default,) {final _that = this;
switch (_that) {
case _PushRequest():
return $default(_that.householdId,_that.changes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'household_id')  Uuid householdId,  List<PushChange> changes)?  $default,) {final _that = this;
switch (_that) {
case _PushRequest() when $default != null:
return $default(_that.householdId,_that.changes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PushRequest implements PushRequest {
  const _PushRequest({@JsonKey(name: 'household_id') required this.householdId, required  List<PushChange> changes}): _changes = changes;
  factory _PushRequest.fromJson(Map<String, dynamic> json) => _$PushRequestFromJson(json);

@override@JsonKey(name: 'household_id') final  Uuid householdId;
 final  List<PushChange> _changes;
@override List<PushChange> get changes {
  if (_changes is EqualUnmodifiableListView) return _changes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_changes);
}


/// Create a copy of PushRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PushRequestCopyWith<_PushRequest> get copyWith => __$PushRequestCopyWithImpl<_PushRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PushRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PushRequest&&(identical(other.householdId, householdId) || other.householdId == householdId)&&const DeepCollectionEquality().equals(other.changes, _changes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,householdId,const DeepCollectionEquality().hash(_changes));
}

@override
String toString() {
    return 'PushRequest(householdId: $householdId, changes: $changes)';
}


}

/// @nodoc
abstract mixin class _$PushRequestCopyWith<$Res> implements $PushRequestCopyWith<$Res> {
  factory _$PushRequestCopyWith(_PushRequest value, $Res Function(_PushRequest) _then) = __$PushRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'household_id') Uuid householdId, List<PushChange> changes
});




}
/// @nodoc
class __$PushRequestCopyWithImpl<$Res>
    implements _$PushRequestCopyWith<$Res> {
  __$PushRequestCopyWithImpl(this._self, this._then);

  final _PushRequest _self;
  final $Res Function(_PushRequest) _then;

/// Create a copy of PushRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? householdId = null,Object? changes = null,}) {
  return _then(_PushRequest(
householdId: null == householdId ? _self.householdId : householdId // ignore: cast_nullable_to_non_nullable
as Uuid,changes: null == changes ? _self._changes : changes // ignore: cast_nullable_to_non_nullable
as List<PushChange>,
  ));
}


}

// dart format on
