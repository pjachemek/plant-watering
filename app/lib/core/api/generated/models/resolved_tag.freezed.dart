// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resolved_tag.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ResolvedTag {

 Tag get tag;/// The linked plant; absent when the tag is unlinked.
 Plant? get plant;
/// Create a copy of ResolvedTag
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResolvedTagCopyWith<ResolvedTag> get copyWith => _$ResolvedTagCopyWithImpl<ResolvedTag>(this as ResolvedTag, _$identity);

  /// Serializes this ResolvedTag to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ResolvedTag;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResolvedTag&&(identical(other.tag, _this.tag) || other.tag == _this.tag)&&(identical(other.plant, _this.plant) || other.plant == _this.plant));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ResolvedTag;
  return Object.hash(runtimeType,_this.tag,_this.plant);
}

@override
String toString() {
  final _this = this as ResolvedTag;
  return 'ResolvedTag(tag: ${_this.tag}, plant: ${_this.plant})';
}


}

/// @nodoc
abstract mixin class $ResolvedTagCopyWith<$Res>  {
  factory $ResolvedTagCopyWith(ResolvedTag value, $Res Function(ResolvedTag) _then) = _$ResolvedTagCopyWithImpl;
@useResult
$Res call({
 Tag tag, Plant? plant
});


$TagCopyWith<$Res> get tag;$PlantCopyWith<$Res>? get plant;

}
/// @nodoc
class _$ResolvedTagCopyWithImpl<$Res>
    implements $ResolvedTagCopyWith<$Res> {
  _$ResolvedTagCopyWithImpl(this._self, this._then);

  final ResolvedTag _self;
  final $Res Function(ResolvedTag) _then;

/// Create a copy of ResolvedTag
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tag = null,Object? plant = freezed,}) {
  return _then(ResolvedTag(
tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as Tag,plant: freezed == plant ? _self.plant : plant // ignore: cast_nullable_to_non_nullable
as Plant?,
  ));
}
/// Create a copy of ResolvedTag
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TagCopyWith<$Res> get tag {
  
  return $TagCopyWith<$Res>(_self.tag, (value) {
    return _then(_self.copyWith(tag: value));
  });
}/// Create a copy of ResolvedTag
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlantCopyWith<$Res>? get plant {
    if (_self.plant == null) {
    return null;
  }

  return $PlantCopyWith<$Res>(_self.plant!, (value) {
    return _then(_self.copyWith(plant: value));
  });
}
}


/// Adds pattern-matching-related methods to [ResolvedTag].
extension ResolvedTagPatterns on ResolvedTag {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResolvedTag value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResolvedTag() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResolvedTag value)  $default,){
final _that = this;
switch (_that) {
case _ResolvedTag():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResolvedTag value)?  $default,){
final _that = this;
switch (_that) {
case _ResolvedTag() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Tag tag,  Plant? plant)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResolvedTag() when $default != null:
return $default(_that.tag,_that.plant);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Tag tag,  Plant? plant)  $default,) {final _that = this;
switch (_that) {
case _ResolvedTag():
return $default(_that.tag,_that.plant);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Tag tag,  Plant? plant)?  $default,) {final _that = this;
switch (_that) {
case _ResolvedTag() when $default != null:
return $default(_that.tag,_that.plant);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ResolvedTag implements ResolvedTag {
  const _ResolvedTag({required this.tag, this.plant});
  factory _ResolvedTag.fromJson(Map<String, dynamic> json) => _$ResolvedTagFromJson(json);

@override final  Tag tag;
/// The linked plant; absent when the tag is unlinked.
@override final  Plant? plant;

/// Create a copy of ResolvedTag
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResolvedTagCopyWith<_ResolvedTag> get copyWith => __$ResolvedTagCopyWithImpl<_ResolvedTag>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResolvedTagToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResolvedTag&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.plant, plant) || other.plant == plant));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,tag,plant);
}

@override
String toString() {
    return 'ResolvedTag(tag: $tag, plant: $plant)';
}


}

/// @nodoc
abstract mixin class _$ResolvedTagCopyWith<$Res> implements $ResolvedTagCopyWith<$Res> {
  factory _$ResolvedTagCopyWith(_ResolvedTag value, $Res Function(_ResolvedTag) _then) = __$ResolvedTagCopyWithImpl;
@override @useResult
$Res call({
 Tag tag, Plant? plant
});


@override $TagCopyWith<$Res> get tag;@override $PlantCopyWith<$Res>? get plant;

}
/// @nodoc
class __$ResolvedTagCopyWithImpl<$Res>
    implements _$ResolvedTagCopyWith<$Res> {
  __$ResolvedTagCopyWithImpl(this._self, this._then);

  final _ResolvedTag _self;
  final $Res Function(_ResolvedTag) _then;

/// Create a copy of ResolvedTag
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tag = null,Object? plant = freezed,}) {
  return _then(_ResolvedTag(
tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as Tag,plant: freezed == plant ? _self.plant : plant // ignore: cast_nullable_to_non_nullable
as Plant?,
  ));
}

/// Create a copy of ResolvedTag
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TagCopyWith<$Res> get tag {
  
  return $TagCopyWith<$Res>(_self.tag, (value) {
    return _then(_self.copyWith(tag: value));
  });
}/// Create a copy of ResolvedTag
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlantCopyWith<$Res>? get plant {
    if (_self.plant == null) {
    return null;
  }

  return $PlantCopyWith<$Res>(_self.plant!, (value) {
    return _then(_self.copyWith(plant: value));
  });
}
}

// dart format on
