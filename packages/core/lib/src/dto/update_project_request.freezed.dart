// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_project_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateProjectRequest {

 String? get name; String? get slug; List<RepoConfig>? get repos; String? get flutterVersion; String? get designSystemRef; ProjectStatus? get status;
/// Create a copy of UpdateProjectRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateProjectRequestCopyWith<UpdateProjectRequest> get copyWith => _$UpdateProjectRequestCopyWithImpl<UpdateProjectRequest>(this as UpdateProjectRequest, _$identity);

  /// Serializes this UpdateProjectRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UpdateProjectRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateProjectRequest&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&const DeepCollectionEquality().equals(other.repos, _this.repos)&&(identical(other.flutterVersion, _this.flutterVersion) || other.flutterVersion == _this.flutterVersion)&&(identical(other.designSystemRef, _this.designSystemRef) || other.designSystemRef == _this.designSystemRef)&&(identical(other.status, _this.status) || other.status == _this.status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UpdateProjectRequest;
  return Object.hash(runtimeType,_this.name,_this.slug,const DeepCollectionEquality().hash(_this.repos),_this.flutterVersion,_this.designSystemRef,_this.status);
}

@override
String toString() {
  final _this = this as UpdateProjectRequest;
  return 'UpdateProjectRequest(name: ${_this.name}, slug: ${_this.slug}, repos: ${_this.repos}, flutterVersion: ${_this.flutterVersion}, designSystemRef: ${_this.designSystemRef}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $UpdateProjectRequestCopyWith<$Res>  {
  factory $UpdateProjectRequestCopyWith(UpdateProjectRequest value, $Res Function(UpdateProjectRequest) _then) = _$UpdateProjectRequestCopyWithImpl;
@useResult
$Res call({
 String? name, String? slug, List<RepoConfig>? repos, String? flutterVersion, String? designSystemRef, ProjectStatus? status
});




}
/// @nodoc
class _$UpdateProjectRequestCopyWithImpl<$Res>
    implements $UpdateProjectRequestCopyWith<$Res> {
  _$UpdateProjectRequestCopyWithImpl(this._self, this._then);

  final UpdateProjectRequest _self;
  final $Res Function(UpdateProjectRequest) _then;

/// Create a copy of UpdateProjectRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? slug = freezed,Object? repos = freezed,Object? flutterVersion = freezed,Object? designSystemRef = freezed,Object? status = freezed,}) {
  return _then(UpdateProjectRequest(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,repos: freezed == repos ? _self.repos : repos // ignore: cast_nullable_to_non_nullable
as List<RepoConfig>?,flutterVersion: freezed == flutterVersion ? _self.flutterVersion : flutterVersion // ignore: cast_nullable_to_non_nullable
as String?,designSystemRef: freezed == designSystemRef ? _self.designSystemRef : designSystemRef // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectStatus?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateProjectRequest].
extension UpdateProjectRequestPatterns on UpdateProjectRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateProjectRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateProjectRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateProjectRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateProjectRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateProjectRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateProjectRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String? slug,  List<RepoConfig>? repos,  String? flutterVersion,  String? designSystemRef,  ProjectStatus? status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateProjectRequest() when $default != null:
return $default(_that.name,_that.slug,_that.repos,_that.flutterVersion,_that.designSystemRef,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String? slug,  List<RepoConfig>? repos,  String? flutterVersion,  String? designSystemRef,  ProjectStatus? status)  $default,) {final _that = this;
switch (_that) {
case _UpdateProjectRequest():
return $default(_that.name,_that.slug,_that.repos,_that.flutterVersion,_that.designSystemRef,_that.status);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String? slug,  List<RepoConfig>? repos,  String? flutterVersion,  String? designSystemRef,  ProjectStatus? status)?  $default,) {final _that = this;
switch (_that) {
case _UpdateProjectRequest() when $default != null:
return $default(_that.name,_that.slug,_that.repos,_that.flutterVersion,_that.designSystemRef,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateProjectRequest implements UpdateProjectRequest {
  const _UpdateProjectRequest({this.name, this.slug,  List<RepoConfig>? repos, this.flutterVersion, this.designSystemRef, this.status}): _repos = repos;
  factory _UpdateProjectRequest.fromJson(Map<String, dynamic> json) => _$UpdateProjectRequestFromJson(json);

@override final  String? name;
@override final  String? slug;
 final  List<RepoConfig>? _repos;
@override List<RepoConfig>? get repos {
  final value = _repos;
  if (value == null) return null;
  if (_repos is EqualUnmodifiableListView) return _repos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? flutterVersion;
@override final  String? designSystemRef;
@override final  ProjectStatus? status;

/// Create a copy of UpdateProjectRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateProjectRequestCopyWith<_UpdateProjectRequest> get copyWith => __$UpdateProjectRequestCopyWithImpl<_UpdateProjectRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateProjectRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateProjectRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&const DeepCollectionEquality().equals(other.repos, _repos)&&(identical(other.flutterVersion, flutterVersion) || other.flutterVersion == flutterVersion)&&(identical(other.designSystemRef, designSystemRef) || other.designSystemRef == designSystemRef)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,slug,const DeepCollectionEquality().hash(_repos),flutterVersion,designSystemRef,status);
}

@override
String toString() {
    return 'UpdateProjectRequest(name: $name, slug: $slug, repos: $repos, flutterVersion: $flutterVersion, designSystemRef: $designSystemRef, status: $status)';
}


}

/// @nodoc
abstract mixin class _$UpdateProjectRequestCopyWith<$Res> implements $UpdateProjectRequestCopyWith<$Res> {
  factory _$UpdateProjectRequestCopyWith(_UpdateProjectRequest value, $Res Function(_UpdateProjectRequest) _then) = __$UpdateProjectRequestCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? slug, List<RepoConfig>? repos, String? flutterVersion, String? designSystemRef, ProjectStatus? status
});




}
/// @nodoc
class __$UpdateProjectRequestCopyWithImpl<$Res>
    implements _$UpdateProjectRequestCopyWith<$Res> {
  __$UpdateProjectRequestCopyWithImpl(this._self, this._then);

  final _UpdateProjectRequest _self;
  final $Res Function(_UpdateProjectRequest) _then;

/// Create a copy of UpdateProjectRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? slug = freezed,Object? repos = freezed,Object? flutterVersion = freezed,Object? designSystemRef = freezed,Object? status = freezed,}) {
  return _then(_UpdateProjectRequest(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,repos: freezed == repos ? _self._repos : repos // ignore: cast_nullable_to_non_nullable
as List<RepoConfig>?,flutterVersion: freezed == flutterVersion ? _self.flutterVersion : flutterVersion // ignore: cast_nullable_to_non_nullable
as String?,designSystemRef: freezed == designSystemRef ? _self.designSystemRef : designSystemRef // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectStatus?,
  ));
}


}

// dart format on
