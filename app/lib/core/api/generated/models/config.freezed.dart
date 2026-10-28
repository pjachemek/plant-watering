// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Config {

 Platform get platform;@JsonKey(name: 'min_version') SemVer get minVersion;@JsonKey(name: 'recommended_version') SemVer get recommendedVersion;/// The newest API major version, for example "1".
@JsonKey(name: 'api_version') String get apiVersion;/// Feature flags (AGENTS.md section 10).
 Map<String, bool>? get features;
/// Create a copy of Config
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConfigCopyWith<Config> get copyWith => _$ConfigCopyWithImpl<Config>(this as Config, _$identity);

  /// Serializes this Config to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Config;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Config&&(identical(other.platform, _this.platform) || other.platform == _this.platform)&&(identical(other.minVersion, _this.minVersion) || other.minVersion == _this.minVersion)&&(identical(other.recommendedVersion, _this.recommendedVersion) || other.recommendedVersion == _this.recommendedVersion)&&(identical(other.apiVersion, _this.apiVersion) || other.apiVersion == _this.apiVersion)&&const DeepCollectionEquality().equals(other.features, _this.features));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Config;
  return Object.hash(runtimeType,_this.platform,_this.minVersion,_this.recommendedVersion,_this.apiVersion,const DeepCollectionEquality().hash(_this.features));
}

@override
String toString() {
  final _this = this as Config;
  return 'Config(platform: ${_this.platform}, minVersion: ${_this.minVersion}, recommendedVersion: ${_this.recommendedVersion}, apiVersion: ${_this.apiVersion}, features: ${_this.features})';
}


}

/// @nodoc
abstract mixin class $ConfigCopyWith<$Res>  {
  factory $ConfigCopyWith(Config value, $Res Function(Config) _then) = _$ConfigCopyWithImpl;
@useResult
$Res call({
 Platform platform,@JsonKey(name: 'min_version') SemVer minVersion,@JsonKey(name: 'recommended_version') SemVer recommendedVersion,@JsonKey(name: 'api_version') String apiVersion, Map<String, bool>? features
});




}
/// @nodoc
class _$ConfigCopyWithImpl<$Res>
    implements $ConfigCopyWith<$Res> {
  _$ConfigCopyWithImpl(this._self, this._then);

  final Config _self;
  final $Res Function(Config) _then;

/// Create a copy of Config
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? platform = null,Object? minVersion = null,Object? recommendedVersion = null,Object? apiVersion = null,Object? features = freezed,}) {
  return _then(Config(
platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as Platform,minVersion: null == minVersion ? _self.minVersion : minVersion // ignore: cast_nullable_to_non_nullable
as SemVer,recommendedVersion: null == recommendedVersion ? _self.recommendedVersion : recommendedVersion // ignore: cast_nullable_to_non_nullable
as SemVer,apiVersion: null == apiVersion ? _self.apiVersion : apiVersion // ignore: cast_nullable_to_non_nullable
as String,features: freezed == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as Map<String, bool>?,
  ));
}

}


/// Adds pattern-matching-related methods to [Config].
extension ConfigPatterns on Config {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Config value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Config() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Config value)  $default,){
final _that = this;
switch (_that) {
case _Config():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Config value)?  $default,){
final _that = this;
switch (_that) {
case _Config() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Platform platform, @JsonKey(name: 'min_version')  SemVer minVersion, @JsonKey(name: 'recommended_version')  SemVer recommendedVersion, @JsonKey(name: 'api_version')  String apiVersion,  Map<String, bool>? features)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Config() when $default != null:
return $default(_that.platform,_that.minVersion,_that.recommendedVersion,_that.apiVersion,_that.features);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Platform platform, @JsonKey(name: 'min_version')  SemVer minVersion, @JsonKey(name: 'recommended_version')  SemVer recommendedVersion, @JsonKey(name: 'api_version')  String apiVersion,  Map<String, bool>? features)  $default,) {final _that = this;
switch (_that) {
case _Config():
return $default(_that.platform,_that.minVersion,_that.recommendedVersion,_that.apiVersion,_that.features);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Platform platform, @JsonKey(name: 'min_version')  SemVer minVersion, @JsonKey(name: 'recommended_version')  SemVer recommendedVersion, @JsonKey(name: 'api_version')  String apiVersion,  Map<String, bool>? features)?  $default,) {final _that = this;
switch (_that) {
case _Config() when $default != null:
return $default(_that.platform,_that.minVersion,_that.recommendedVersion,_that.apiVersion,_that.features);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Config implements Config {
  const _Config({required this.platform, @JsonKey(name: 'min_version') required this.minVersion, @JsonKey(name: 'recommended_version') required this.recommendedVersion, @JsonKey(name: 'api_version') required this.apiVersion,  Map<String, bool>? features}): _features = features;
  factory _Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);

@override final  Platform platform;
@override@JsonKey(name: 'min_version') final  SemVer minVersion;
@override@JsonKey(name: 'recommended_version') final  SemVer recommendedVersion;
/// The newest API major version, for example "1".
@override@JsonKey(name: 'api_version') final  String apiVersion;
/// Feature flags (AGENTS.md section 10).
 final  Map<String, bool>? _features;
/// Feature flags (AGENTS.md section 10).
@override Map<String, bool>? get features {
  final value = _features;
  if (value == null) return null;
  if (_features is EqualUnmodifiableMapView) return _features;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of Config
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConfigCopyWith<_Config> get copyWith => __$ConfigCopyWithImpl<_Config>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConfigToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Config&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.minVersion, minVersion) || other.minVersion == minVersion)&&(identical(other.recommendedVersion, recommendedVersion) || other.recommendedVersion == recommendedVersion)&&(identical(other.apiVersion, apiVersion) || other.apiVersion == apiVersion)&&const DeepCollectionEquality().equals(other.features, _features));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,platform,minVersion,recommendedVersion,apiVersion,const DeepCollectionEquality().hash(_features));
}

@override
String toString() {
    return 'Config(platform: $platform, minVersion: $minVersion, recommendedVersion: $recommendedVersion, apiVersion: $apiVersion, features: $features)';
}


}

/// @nodoc
abstract mixin class _$ConfigCopyWith<$Res> implements $ConfigCopyWith<$Res> {
  factory _$ConfigCopyWith(_Config value, $Res Function(_Config) _then) = __$ConfigCopyWithImpl;
@override @useResult
$Res call({
 Platform platform,@JsonKey(name: 'min_version') SemVer minVersion,@JsonKey(name: 'recommended_version') SemVer recommendedVersion,@JsonKey(name: 'api_version') String apiVersion, Map<String, bool>? features
});




}
/// @nodoc
class __$ConfigCopyWithImpl<$Res>
    implements _$ConfigCopyWith<$Res> {
  __$ConfigCopyWithImpl(this._self, this._then);

  final _Config _self;
  final $Res Function(_Config) _then;

/// Create a copy of Config
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? platform = null,Object? minVersion = null,Object? recommendedVersion = null,Object? apiVersion = null,Object? features = freezed,}) {
  return _then(_Config(
platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as Platform,minVersion: null == minVersion ? _self.minVersion : minVersion // ignore: cast_nullable_to_non_nullable
as SemVer,recommendedVersion: null == recommendedVersion ? _self.recommendedVersion : recommendedVersion // ignore: cast_nullable_to_non_nullable
as SemVer,apiVersion: null == apiVersion ? _self.apiVersion : apiVersion // ignore: cast_nullable_to_non_nullable
as String,features: freezed == features ? _self._features : features // ignore: cast_nullable_to_non_nullable
as Map<String, bool>?,
  ));
}


}

// dart format on
