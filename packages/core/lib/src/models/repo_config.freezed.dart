// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'repo_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RepoConfig {

 String get url; String get defaultBranch; String get path;
/// Create a copy of RepoConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RepoConfigCopyWith<RepoConfig> get copyWith => _$RepoConfigCopyWithImpl<RepoConfig>(this as RepoConfig, _$identity);

  /// Serializes this RepoConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RepoConfig;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RepoConfig&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.defaultBranch, _this.defaultBranch) || other.defaultBranch == _this.defaultBranch)&&(identical(other.path, _this.path) || other.path == _this.path));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RepoConfig;
  return Object.hash(runtimeType,_this.url,_this.defaultBranch,_this.path);
}

@override
String toString() {
  final _this = this as RepoConfig;
  return 'RepoConfig(url: ${_this.url}, defaultBranch: ${_this.defaultBranch}, path: ${_this.path})';
}


}

/// @nodoc
abstract mixin class $RepoConfigCopyWith<$Res>  {
  factory $RepoConfigCopyWith(RepoConfig value, $Res Function(RepoConfig) _then) = _$RepoConfigCopyWithImpl;
@useResult
$Res call({
 String url, String defaultBranch, String path
});




}
/// @nodoc
class _$RepoConfigCopyWithImpl<$Res>
    implements $RepoConfigCopyWith<$Res> {
  _$RepoConfigCopyWithImpl(this._self, this._then);

  final RepoConfig _self;
  final $Res Function(RepoConfig) _then;

/// Create a copy of RepoConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = null,Object? defaultBranch = null,Object? path = null,}) {
  return _then(RepoConfig(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,defaultBranch: null == defaultBranch ? _self.defaultBranch : defaultBranch // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RepoConfig].
extension RepoConfigPatterns on RepoConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RepoConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RepoConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RepoConfig value)  $default,){
final _that = this;
switch (_that) {
case _RepoConfig():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RepoConfig value)?  $default,){
final _that = this;
switch (_that) {
case _RepoConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String url,  String defaultBranch,  String path)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RepoConfig() when $default != null:
return $default(_that.url,_that.defaultBranch,_that.path);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String url,  String defaultBranch,  String path)  $default,) {final _that = this;
switch (_that) {
case _RepoConfig():
return $default(_that.url,_that.defaultBranch,_that.path);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String url,  String defaultBranch,  String path)?  $default,) {final _that = this;
switch (_that) {
case _RepoConfig() when $default != null:
return $default(_that.url,_that.defaultBranch,_that.path);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RepoConfig implements RepoConfig {
  const _RepoConfig({required this.url, required this.defaultBranch, required this.path});
  factory _RepoConfig.fromJson(Map<String, dynamic> json) => _$RepoConfigFromJson(json);

@override final  String url;
@override final  String defaultBranch;
@override final  String path;

/// Create a copy of RepoConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RepoConfigCopyWith<_RepoConfig> get copyWith => __$RepoConfigCopyWithImpl<_RepoConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RepoConfigToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RepoConfig&&(identical(other.url, url) || other.url == url)&&(identical(other.defaultBranch, defaultBranch) || other.defaultBranch == defaultBranch)&&(identical(other.path, path) || other.path == path));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,url,defaultBranch,path);
}

@override
String toString() {
    return 'RepoConfig(url: $url, defaultBranch: $defaultBranch, path: $path)';
}


}

/// @nodoc
abstract mixin class _$RepoConfigCopyWith<$Res> implements $RepoConfigCopyWith<$Res> {
  factory _$RepoConfigCopyWith(_RepoConfig value, $Res Function(_RepoConfig) _then) = __$RepoConfigCopyWithImpl;
@override @useResult
$Res call({
 String url, String defaultBranch, String path
});




}
/// @nodoc
class __$RepoConfigCopyWithImpl<$Res>
    implements _$RepoConfigCopyWith<$Res> {
  __$RepoConfigCopyWithImpl(this._self, this._then);

  final _RepoConfig _self;
  final $Res Function(_RepoConfig) _then;

/// Create a copy of RepoConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = null,Object? defaultBranch = null,Object? path = null,}) {
  return _then(_RepoConfig(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,defaultBranch: null == defaultBranch ? _self.defaultBranch : defaultBranch // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
