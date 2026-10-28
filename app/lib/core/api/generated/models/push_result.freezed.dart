// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'push_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PushResult {

@JsonKey(name: 'change_id') Uuid get changeId; PushResultStatus get status;/// Why the change was rejected.
 Problem? get problem;
/// Create a copy of PushResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PushResultCopyWith<PushResult> get copyWith => _$PushResultCopyWithImpl<PushResult>(this as PushResult, _$identity);

  /// Serializes this PushResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PushResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PushResult&&(identical(other.changeId, _this.changeId) || other.changeId == _this.changeId)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.problem, _this.problem) || other.problem == _this.problem));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PushResult;
  return Object.hash(runtimeType,_this.changeId,_this.status,_this.problem);
}

@override
String toString() {
  final _this = this as PushResult;
  return 'PushResult(changeId: ${_this.changeId}, status: ${_this.status}, problem: ${_this.problem})';
}


}

/// @nodoc
abstract mixin class $PushResultCopyWith<$Res>  {
  factory $PushResultCopyWith(PushResult value, $Res Function(PushResult) _then) = _$PushResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'change_id') Uuid changeId, PushResultStatus status, Problem? problem
});


$ProblemCopyWith<$Res>? get problem;

}
/// @nodoc
class _$PushResultCopyWithImpl<$Res>
    implements $PushResultCopyWith<$Res> {
  _$PushResultCopyWithImpl(this._self, this._then);

  final PushResult _self;
  final $Res Function(PushResult) _then;

/// Create a copy of PushResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? changeId = null,Object? status = null,Object? problem = freezed,}) {
  return _then(PushResult(
changeId: null == changeId ? _self.changeId : changeId // ignore: cast_nullable_to_non_nullable
as Uuid,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PushResultStatus,problem: freezed == problem ? _self.problem : problem // ignore: cast_nullable_to_non_nullable
as Problem?,
  ));
}
/// Create a copy of PushResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProblemCopyWith<$Res>? get problem {
    if (_self.problem == null) {
    return null;
  }

  return $ProblemCopyWith<$Res>(_self.problem!, (value) {
    return _then(_self.copyWith(problem: value));
  });
}
}


/// Adds pattern-matching-related methods to [PushResult].
extension PushResultPatterns on PushResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PushResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PushResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PushResult value)  $default,){
final _that = this;
switch (_that) {
case _PushResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PushResult value)?  $default,){
final _that = this;
switch (_that) {
case _PushResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'change_id')  Uuid changeId,  PushResultStatus status,  Problem? problem)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PushResult() when $default != null:
return $default(_that.changeId,_that.status,_that.problem);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'change_id')  Uuid changeId,  PushResultStatus status,  Problem? problem)  $default,) {final _that = this;
switch (_that) {
case _PushResult():
return $default(_that.changeId,_that.status,_that.problem);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'change_id')  Uuid changeId,  PushResultStatus status,  Problem? problem)?  $default,) {final _that = this;
switch (_that) {
case _PushResult() when $default != null:
return $default(_that.changeId,_that.status,_that.problem);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PushResult implements PushResult {
  const _PushResult({@JsonKey(name: 'change_id') required this.changeId, required this.status, this.problem});
  factory _PushResult.fromJson(Map<String, dynamic> json) => _$PushResultFromJson(json);

@override@JsonKey(name: 'change_id') final  Uuid changeId;
@override final  PushResultStatus status;
/// Why the change was rejected.
@override final  Problem? problem;

/// Create a copy of PushResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PushResultCopyWith<_PushResult> get copyWith => __$PushResultCopyWithImpl<_PushResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PushResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PushResult&&(identical(other.changeId, changeId) || other.changeId == changeId)&&(identical(other.status, status) || other.status == status)&&(identical(other.problem, problem) || other.problem == problem));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,changeId,status,problem);
}

@override
String toString() {
    return 'PushResult(changeId: $changeId, status: $status, problem: $problem)';
}


}

/// @nodoc
abstract mixin class _$PushResultCopyWith<$Res> implements $PushResultCopyWith<$Res> {
  factory _$PushResultCopyWith(_PushResult value, $Res Function(_PushResult) _then) = __$PushResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'change_id') Uuid changeId, PushResultStatus status, Problem? problem
});


@override $ProblemCopyWith<$Res>? get problem;

}
/// @nodoc
class __$PushResultCopyWithImpl<$Res>
    implements _$PushResultCopyWith<$Res> {
  __$PushResultCopyWithImpl(this._self, this._then);

  final _PushResult _self;
  final $Res Function(_PushResult) _then;

/// Create a copy of PushResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? changeId = null,Object? status = null,Object? problem = freezed,}) {
  return _then(_PushResult(
changeId: null == changeId ? _self.changeId : changeId // ignore: cast_nullable_to_non_nullable
as Uuid,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PushResultStatus,problem: freezed == problem ? _self.problem : problem // ignore: cast_nullable_to_non_nullable
as Problem?,
  ));
}

/// Create a copy of PushResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProblemCopyWith<$Res>? get problem {
    if (_self.problem == null) {
    return null;
  }

  return $ProblemCopyWith<$Res>(_self.problem!, (value) {
    return _then(_self.copyWith(problem: value));
  });
}
}

// dart format on
