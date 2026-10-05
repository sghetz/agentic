// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Project {

 String get id; String get name; String get slug; List<RepoConfig> get repos; ProjectStatus get status; DateTime get createdAt; String? get flutterVersion; String? get designSystemRef; DateTime? get archivedAt;
/// Create a copy of Project
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectCopyWith<Project> get copyWith => _$ProjectCopyWithImpl<Project>(this as Project, _$identity);

  /// Serializes this Project to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Project;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Project&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&const DeepCollectionEquality().equals(other.repos, _this.repos)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.flutterVersion, _this.flutterVersion) || other.flutterVersion == _this.flutterVersion)&&(identical(other.designSystemRef, _this.designSystemRef) || other.designSystemRef == _this.designSystemRef)&&(identical(other.archivedAt, _this.archivedAt) || other.archivedAt == _this.archivedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Project;
  return Object.hash(runtimeType,_this.id,_this.name,_this.slug,const DeepCollectionEquality().hash(_this.repos),_this.status,_this.createdAt,_this.flutterVersion,_this.designSystemRef,_this.archivedAt);
}

@override
String toString() {
  final _this = this as Project;
  return 'Project(id: ${_this.id}, name: ${_this.name}, slug: ${_this.slug}, repos: ${_this.repos}, status: ${_this.status}, createdAt: ${_this.createdAt}, flutterVersion: ${_this.flutterVersion}, designSystemRef: ${_this.designSystemRef}, archivedAt: ${_this.archivedAt})';
}


}

/// @nodoc
abstract mixin class $ProjectCopyWith<$Res>  {
  factory $ProjectCopyWith(Project value, $Res Function(Project) _then) = _$ProjectCopyWithImpl;
@useResult
$Res call({
 String id, String name, String slug, List<RepoConfig> repos, ProjectStatus status, DateTime createdAt, String? flutterVersion, String? designSystemRef, DateTime? archivedAt
});




}
/// @nodoc
class _$ProjectCopyWithImpl<$Res>
    implements $ProjectCopyWith<$Res> {
  _$ProjectCopyWithImpl(this._self, this._then);

  final Project _self;
  final $Res Function(Project) _then;

/// Create a copy of Project
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? slug = null,Object? repos = null,Object? status = null,Object? createdAt = null,Object? flutterVersion = freezed,Object? designSystemRef = freezed,Object? archivedAt = freezed,}) {
  return _then(Project(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,repos: null == repos ? _self.repos : repos // ignore: cast_nullable_to_non_nullable
as List<RepoConfig>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,flutterVersion: freezed == flutterVersion ? _self.flutterVersion : flutterVersion // ignore: cast_nullable_to_non_nullable
as String?,designSystemRef: freezed == designSystemRef ? _self.designSystemRef : designSystemRef // ignore: cast_nullable_to_non_nullable
as String?,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Project].
extension ProjectPatterns on Project {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Project value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Project() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Project value)  $default,){
final _that = this;
switch (_that) {
case _Project():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Project value)?  $default,){
final _that = this;
switch (_that) {
case _Project() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String slug,  List<RepoConfig> repos,  ProjectStatus status,  DateTime createdAt,  String? flutterVersion,  String? designSystemRef,  DateTime? archivedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Project() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.repos,_that.status,_that.createdAt,_that.flutterVersion,_that.designSystemRef,_that.archivedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String slug,  List<RepoConfig> repos,  ProjectStatus status,  DateTime createdAt,  String? flutterVersion,  String? designSystemRef,  DateTime? archivedAt)  $default,) {final _that = this;
switch (_that) {
case _Project():
return $default(_that.id,_that.name,_that.slug,_that.repos,_that.status,_that.createdAt,_that.flutterVersion,_that.designSystemRef,_that.archivedAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String slug,  List<RepoConfig> repos,  ProjectStatus status,  DateTime createdAt,  String? flutterVersion,  String? designSystemRef,  DateTime? archivedAt)?  $default,) {final _that = this;
switch (_that) {
case _Project() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.repos,_that.status,_that.createdAt,_that.flutterVersion,_that.designSystemRef,_that.archivedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Project implements Project {
  const _Project({required this.id, required this.name, required this.slug, required  List<RepoConfig> repos, required this.status, required this.createdAt, this.flutterVersion, this.designSystemRef, this.archivedAt}): _repos = repos;
  factory _Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);

@override final  String id;
@override final  String name;
@override final  String slug;
 final  List<RepoConfig> _repos;
@override List<RepoConfig> get repos {
  if (_repos is EqualUnmodifiableListView) return _repos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_repos);
}

@override final  ProjectStatus status;
@override final  DateTime createdAt;
@override final  String? flutterVersion;
@override final  String? designSystemRef;
@override final  DateTime? archivedAt;

/// Create a copy of Project
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectCopyWith<_Project> get copyWith => __$ProjectCopyWithImpl<_Project>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Project&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&const DeepCollectionEquality().equals(other.repos, _repos)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.flutterVersion, flutterVersion) || other.flutterVersion == flutterVersion)&&(identical(other.designSystemRef, designSystemRef) || other.designSystemRef == designSystemRef)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,slug,const DeepCollectionEquality().hash(_repos),status,createdAt,flutterVersion,designSystemRef,archivedAt);
}

@override
String toString() {
    return 'Project(id: $id, name: $name, slug: $slug, repos: $repos, status: $status, createdAt: $createdAt, flutterVersion: $flutterVersion, designSystemRef: $designSystemRef, archivedAt: $archivedAt)';
}


}

/// @nodoc
abstract mixin class _$ProjectCopyWith<$Res> implements $ProjectCopyWith<$Res> {
  factory _$ProjectCopyWith(_Project value, $Res Function(_Project) _then) = __$ProjectCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String slug, List<RepoConfig> repos, ProjectStatus status, DateTime createdAt, String? flutterVersion, String? designSystemRef, DateTime? archivedAt
});




}
/// @nodoc
class __$ProjectCopyWithImpl<$Res>
    implements _$ProjectCopyWith<$Res> {
  __$ProjectCopyWithImpl(this._self, this._then);

  final _Project _self;
  final $Res Function(_Project) _then;

/// Create a copy of Project
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? slug = null,Object? repos = null,Object? status = null,Object? createdAt = null,Object? flutterVersion = freezed,Object? designSystemRef = freezed,Object? archivedAt = freezed,}) {
  return _then(_Project(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,repos: null == repos ? _self._repos : repos // ignore: cast_nullable_to_non_nullable
as List<RepoConfig>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,flutterVersion: freezed == flutterVersion ? _self.flutterVersion : flutterVersion // ignore: cast_nullable_to_non_nullable
as String?,designSystemRef: freezed == designSystemRef ? _self.designSystemRef : designSystemRef // ignore: cast_nullable_to_non_nullable
as String?,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
