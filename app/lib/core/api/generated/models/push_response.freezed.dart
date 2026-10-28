// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'push_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PushResponse {

 List<PushResult> get results;
/// Create a copy of PushResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PushResponseCopyWith<PushResponse> get copyWith => _$PushResponseCopyWithImpl<PushResponse>(this as PushResponse, _$identity);

  /// Serializes this PushResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PushResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PushResponse&&const DeepCollectionEquality().equals(other.results, _this.results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PushResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.results));
}

@override
String toString() {
  final _this = this as PushResponse;
  return 'PushResponse(results: ${_this.results})';
}


}

/// @nodoc
abstract mixin class $PushResponseCopyWith<$Res>  {
  factory $PushResponseCopyWith(PushResponse value, $Res Function(PushResponse) _then) = _$PushResponseCopyWithImpl;
@useResult
$Res call({
 List<PushResult> results
});




}
/// @nodoc
class _$PushResponseCopyWithImpl<$Res>
    implements $PushResponseCopyWith<$Res> {
  _$PushResponseCopyWithImpl(this._self, this._then);

  final PushResponse _self;
  final $Res Function(PushResponse) _then;

/// Create a copy of PushResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? results = null,}) {
  return _then(PushResponse(
results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<PushResult>,
  ));
}

}


/// Adds pattern-matching-related methods to [PushResponse].
extension PushResponsePatterns on PushResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PushResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PushResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PushResponse value)  $default,){
final _that = this;
switch (_that) {
case _PushResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PushResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PushResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<PushResult> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PushResponse() when $default != null:
return $default(_that.results);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<PushResult> results)  $default,) {final _that = this;
switch (_that) {
case _PushResponse():
return $default(_that.results);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<PushResult> results)?  $default,) {final _that = this;
switch (_that) {
case _PushResponse() when $default != null:
return $default(_that.results);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PushResponse implements PushResponse {
  const _PushResponse({required  List<PushResult> results}): _results = results;
  factory _PushResponse.fromJson(Map<String, dynamic> json) => _$PushResponseFromJson(json);

 final  List<PushResult> _results;
@override List<PushResult> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of PushResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PushResponseCopyWith<_PushResponse> get copyWith => __$PushResponseCopyWithImpl<_PushResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PushResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PushResponse&&const DeepCollectionEquality().equals(other.results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_results));
}

@override
String toString() {
    return 'PushResponse(results: $results)';
}


}

/// @nodoc
abstract mixin class _$PushResponseCopyWith<$Res> implements $PushResponseCopyWith<$Res> {
  factory _$PushResponseCopyWith(_PushResponse value, $Res Function(_PushResponse) _then) = __$PushResponseCopyWithImpl;
@override @useResult
$Res call({
 List<PushResult> results
});




}
/// @nodoc
class __$PushResponseCopyWithImpl<$Res>
    implements _$PushResponseCopyWith<$Res> {
  __$PushResponseCopyWithImpl(this._self, this._then);

  final _PushResponse _self;
  final $Res Function(_PushResponse) _then;

/// Create a copy of PushResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? results = null,}) {
  return _then(_PushResponse(
results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<PushResult>,
  ));
}


}

// dart format on
