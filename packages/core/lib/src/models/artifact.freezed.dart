// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'artifact.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Artifact {

 String get id; String get taskId; ArtifactKind get kind; String get uri; int get version; DateTime get createdAt;
/// Create a copy of Artifact
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArtifactCopyWith<Artifact> get copyWith => _$ArtifactCopyWithImpl<Artifact>(this as Artifact, _$identity);

  /// Serializes this Artifact to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Artifact;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Artifact&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.taskId, _this.taskId) || other.taskId == _this.taskId)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.uri, _this.uri) || other.uri == _this.uri)&&(identical(other.version, _this.version) || other.version == _this.version)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Artifact;
  return Object.hash(runtimeType,_this.id,_this.taskId,_this.kind,_this.uri,_this.version,_this.createdAt);
}

@override
String toString() {
  final _this = this as Artifact;
  return 'Artifact(id: ${_this.id}, taskId: ${_this.taskId}, kind: ${_this.kind}, uri: ${_this.uri}, version: ${_this.version}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $ArtifactCopyWith<$Res>  {
  factory $ArtifactCopyWith(Artifact value, $Res Function(Artifact) _then) = _$ArtifactCopyWithImpl;
@useResult
$Res call({
 String id, String taskId, ArtifactKind kind, String uri, int version, DateTime createdAt
});




}
/// @nodoc
class _$ArtifactCopyWithImpl<$Res>
    implements $ArtifactCopyWith<$Res> {
  _$ArtifactCopyWithImpl(this._self, this._then);

  final Artifact _self;
  final $Res Function(Artifact) _then;

/// Create a copy of Artifact
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? taskId = null,Object? kind = null,Object? uri = null,Object? version = null,Object? createdAt = null,}) {
  return _then(Artifact(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ArtifactKind,uri: null == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Artifact].
extension ArtifactPatterns on Artifact {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Artifact value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Artifact() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Artifact value)  $default,){
final _that = this;
switch (_that) {
case _Artifact():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Artifact value)?  $default,){
final _that = this;
switch (_that) {
case _Artifact() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String taskId,  ArtifactKind kind,  String uri,  int version,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Artifact() when $default != null:
return $default(_that.id,_that.taskId,_that.kind,_that.uri,_that.version,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String taskId,  ArtifactKind kind,  String uri,  int version,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Artifact():
return $default(_that.id,_that.taskId,_that.kind,_that.uri,_that.version,_that.createdAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String taskId,  ArtifactKind kind,  String uri,  int version,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Artifact() when $default != null:
return $default(_that.id,_that.taskId,_that.kind,_that.uri,_that.version,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Artifact implements Artifact {
  const _Artifact({required this.id, required this.taskId, required this.kind, required this.uri, required this.version, required this.createdAt});
  factory _Artifact.fromJson(Map<String, dynamic> json) => _$ArtifactFromJson(json);

@override final  String id;
@override final  String taskId;
@override final  ArtifactKind kind;
@override final  String uri;
@override final  int version;
@override final  DateTime createdAt;

/// Create a copy of Artifact
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArtifactCopyWith<_Artifact> get copyWith => __$ArtifactCopyWithImpl<_Artifact>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArtifactToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Artifact&&(identical(other.id, id) || other.id == id)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.uri, uri) || other.uri == uri)&&(identical(other.version, version) || other.version == version)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,taskId,kind,uri,version,createdAt);
}

@override
String toString() {
    return 'Artifact(id: $id, taskId: $taskId, kind: $kind, uri: $uri, version: $version, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ArtifactCopyWith<$Res> implements $ArtifactCopyWith<$Res> {
  factory _$ArtifactCopyWith(_Artifact value, $Res Function(_Artifact) _then) = __$ArtifactCopyWithImpl;
@override @useResult
$Res call({
 String id, String taskId, ArtifactKind kind, String uri, int version, DateTime createdAt
});




}
/// @nodoc
class __$ArtifactCopyWithImpl<$Res>
    implements _$ArtifactCopyWith<$Res> {
  __$ArtifactCopyWithImpl(this._self, this._then);

  final _Artifact _self;
  final $Res Function(_Artifact) _then;

/// Create a copy of Artifact
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? taskId = null,Object? kind = null,Object? uri = null,Object? version = null,Object? createdAt = null,}) {
  return _then(_Artifact(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ArtifactKind,uri: null == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
