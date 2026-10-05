// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_project_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateProjectRequest {

 String get name; String get slug; List<RepoConfig> get repos; String? get flutterVersion; String? get designSystemRef;
/// Create a copy of CreateProjectRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateProjectRequestCopyWith<CreateProjectRequest> get copyWith => _$CreateProjectRequestCopyWithImpl<CreateProjectRequest>(this as CreateProjectRequest, _$identity);

  /// Serializes this CreateProjectRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CreateProjectRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateProjectRequest&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&const DeepCollectionEquality().equals(other.repos, _this.repos)&&(identical(other.flutterVersion, _this.flutterVersion) || other.flutterVersion == _this.flutterVersion)&&(identical(other.designSystemRef, _this.designSystemRef) || other.designSystemRef == _this.designSystemRef));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CreateProjectRequest;
  return Object.hash(runtimeType,_this.name,_this.slug,const DeepCollectionEquality().hash(_this.repos),_this.flutterVersion,_this.designSystemRef);
}

@override
String toString() {
  final _this = this as CreateProjectRequest;
  return 'CreateProjectRequest(name: ${_this.name}, slug: ${_this.slug}, repos: ${_this.repos}, flutterVersion: ${_this.flutterVersion}, designSystemRef: ${_this.designSystemRef})';
}


}

/// @nodoc
abstract mixin class $CreateProjectRequestCopyWith<$Res>  {
  factory $CreateProjectRequestCopyWith(CreateProjectRequest value, $Res Function(CreateProjectRequest) _then) = _$CreateProjectRequestCopyWithImpl;
@useResult
$Res call({
 String name, String slug, List<RepoConfig> repos, String? flutterVersion, String? designSystemRef
});




}
/// @nodoc
class _$CreateProjectRequestCopyWithImpl<$Res>
    implements $CreateProjectRequestCopyWith<$Res> {
  _$CreateProjectRequestCopyWithImpl(this._self, this._then);

  final CreateProjectRequest _self;
  final $Res Function(CreateProjectRequest) _then;

/// Create a copy of CreateProjectRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? slug = null,Object? repos = null,Object? flutterVersion = freezed,Object? designSystemRef = freezed,}) {
  return _then(CreateProjectRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,repos: null == repos ? _self.repos : repos // ignore: cast_nullable_to_non_nullable
as List<RepoConfig>,flutterVersion: freezed == flutterVersion ? _self.flutterVersion : flutterVersion // ignore: cast_nullable_to_non_nullable
as String?,designSystemRef: freezed == designSystemRef ? _self.designSystemRef : designSystemRef // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateProjectRequest].
extension CreateProjectRequestPatterns on CreateProjectRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateProjectRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateProjectRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateProjectRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateProjectRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateProjectRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateProjectRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String slug,  List<RepoConfig> repos,  String? flutterVersion,  String? designSystemRef)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateProjectRequest() when $default != null:
return $default(_that.name,_that.slug,_that.repos,_that.flutterVersion,_that.designSystemRef);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String slug,  List<RepoConfig> repos,  String? flutterVersion,  String? designSystemRef)  $default,) {final _that = this;
switch (_that) {
case _CreateProjectRequest():
return $default(_that.name,_that.slug,_that.repos,_that.flutterVersion,_that.designSystemRef);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String slug,  List<RepoConfig> repos,  String? flutterVersion,  String? designSystemRef)?  $default,) {final _that = this;
switch (_that) {
case _CreateProjectRequest() when $default != null:
return $default(_that.name,_that.slug,_that.repos,_that.flutterVersion,_that.designSystemRef);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateProjectRequest implements CreateProjectRequest {
  const _CreateProjectRequest({required this.name, required this.slug,  List<RepoConfig> repos = const [], this.flutterVersion, this.designSystemRef}): _repos = repos;
  factory _CreateProjectRequest.fromJson(Map<String, dynamic> json) => _$CreateProjectRequestFromJson(json);

@override final  String name;
@override final  String slug;
 final  List<RepoConfig> _repos;
@override@JsonKey() List<RepoConfig> get repos {
  if (_repos is EqualUnmodifiableListView) return _repos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_repos);
}

@override final  String? flutterVersion;
@override final  String? designSystemRef;

/// Create a copy of CreateProjectRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateProjectRequestCopyWith<_CreateProjectRequest> get copyWith => __$CreateProjectRequestCopyWithImpl<_CreateProjectRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateProjectRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateProjectRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&const DeepCollectionEquality().equals(other.repos, _repos)&&(identical(other.flutterVersion, flutterVersion) || other.flutterVersion == flutterVersion)&&(identical(other.designSystemRef, designSystemRef) || other.designSystemRef == designSystemRef));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,slug,const DeepCollectionEquality().hash(_repos),flutterVersion,designSystemRef);
}

@override
String toString() {
    return 'CreateProjectRequest(name: $name, slug: $slug, repos: $repos, flutterVersion: $flutterVersion, designSystemRef: $designSystemRef)';
}


}

/// @nodoc
abstract mixin class _$CreateProjectRequestCopyWith<$Res> implements $CreateProjectRequestCopyWith<$Res> {
  factory _$CreateProjectRequestCopyWith(_CreateProjectRequest value, $Res Function(_CreateProjectRequest) _then) = __$CreateProjectRequestCopyWithImpl;
@override @useResult
$Res call({
 String name, String slug, List<RepoConfig> repos, String? flutterVersion, String? designSystemRef
});




}
/// @nodoc
class __$CreateProjectRequestCopyWithImpl<$Res>
    implements _$CreateProjectRequestCopyWith<$Res> {
  __$CreateProjectRequestCopyWithImpl(this._self, this._then);

  final _CreateProjectRequest _self;
  final $Res Function(_CreateProjectRequest) _then;

/// Create a copy of CreateProjectRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? slug = null,Object? repos = null,Object? flutterVersion = freezed,Object? designSystemRef = freezed,}) {
  return _then(_CreateProjectRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,repos: null == repos ? _self._repos : repos // ignore: cast_nullable_to_non_nullable
as List<RepoConfig>,flutterVersion: freezed == flutterVersion ? _self.flutterVersion : flutterVersion // ignore: cast_nullable_to_non_nullable
as String?,designSystemRef: freezed == designSystemRef ? _self.designSystemRef : designSystemRef // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
