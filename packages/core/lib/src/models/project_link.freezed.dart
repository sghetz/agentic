// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_link.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProjectLink {

 String get id; String get fromProjectId; String get toProjectId; LinkRelation get relation;
/// Create a copy of ProjectLink
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectLinkCopyWith<ProjectLink> get copyWith => _$ProjectLinkCopyWithImpl<ProjectLink>(this as ProjectLink, _$identity);

  /// Serializes this ProjectLink to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectLink&&(identical(other.id, id) || other.id == id)&&(identical(other.fromProjectId, fromProjectId) || other.fromProjectId == fromProjectId)&&(identical(other.toProjectId, toProjectId) || other.toProjectId == toProjectId)&&(identical(other.relation, relation) || other.relation == relation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fromProjectId,toProjectId,relation);

@override
String toString() {
  return 'ProjectLink(id: $id, fromProjectId: $fromProjectId, toProjectId: $toProjectId, relation: $relation)';
}


}

/// @nodoc
abstract mixin class $ProjectLinkCopyWith<$Res>  {
  factory $ProjectLinkCopyWith(ProjectLink value, $Res Function(ProjectLink) _then) = _$ProjectLinkCopyWithImpl;
@useResult
$Res call({
 String id, String fromProjectId, String toProjectId, LinkRelation relation
});




}
/// @nodoc
class _$ProjectLinkCopyWithImpl<$Res>
    implements $ProjectLinkCopyWith<$Res> {
  _$ProjectLinkCopyWithImpl(this._self, this._then);

  final ProjectLink _self;
  final $Res Function(ProjectLink) _then;

/// Create a copy of ProjectLink
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fromProjectId = null,Object? toProjectId = null,Object? relation = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fromProjectId: null == fromProjectId ? _self.fromProjectId : fromProjectId // ignore: cast_nullable_to_non_nullable
as String,toProjectId: null == toProjectId ? _self.toProjectId : toProjectId // ignore: cast_nullable_to_non_nullable
as String,relation: null == relation ? _self.relation : relation // ignore: cast_nullable_to_non_nullable
as LinkRelation,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectLink].
extension ProjectLinkPatterns on ProjectLink {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectLink value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectLink() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectLink value)  $default,){
final _that = this;
switch (_that) {
case _ProjectLink():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectLink value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectLink() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String fromProjectId,  String toProjectId,  LinkRelation relation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectLink() when $default != null:
return $default(_that.id,_that.fromProjectId,_that.toProjectId,_that.relation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String fromProjectId,  String toProjectId,  LinkRelation relation)  $default,) {final _that = this;
switch (_that) {
case _ProjectLink():
return $default(_that.id,_that.fromProjectId,_that.toProjectId,_that.relation);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String fromProjectId,  String toProjectId,  LinkRelation relation)?  $default,) {final _that = this;
switch (_that) {
case _ProjectLink() when $default != null:
return $default(_that.id,_that.fromProjectId,_that.toProjectId,_that.relation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectLink implements ProjectLink {
  const _ProjectLink({required this.id, required this.fromProjectId, required this.toProjectId, required this.relation});
  factory _ProjectLink.fromJson(Map<String, dynamic> json) => _$ProjectLinkFromJson(json);

@override final  String id;
@override final  String fromProjectId;
@override final  String toProjectId;
@override final  LinkRelation relation;

/// Create a copy of ProjectLink
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectLinkCopyWith<_ProjectLink> get copyWith => __$ProjectLinkCopyWithImpl<_ProjectLink>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectLinkToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectLink&&(identical(other.id, id) || other.id == id)&&(identical(other.fromProjectId, fromProjectId) || other.fromProjectId == fromProjectId)&&(identical(other.toProjectId, toProjectId) || other.toProjectId == toProjectId)&&(identical(other.relation, relation) || other.relation == relation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fromProjectId,toProjectId,relation);

@override
String toString() {
  return 'ProjectLink(id: $id, fromProjectId: $fromProjectId, toProjectId: $toProjectId, relation: $relation)';
}


}

/// @nodoc
abstract mixin class _$ProjectLinkCopyWith<$Res> implements $ProjectLinkCopyWith<$Res> {
  factory _$ProjectLinkCopyWith(_ProjectLink value, $Res Function(_ProjectLink) _then) = __$ProjectLinkCopyWithImpl;
@override @useResult
$Res call({
 String id, String fromProjectId, String toProjectId, LinkRelation relation
});




}
/// @nodoc
class __$ProjectLinkCopyWithImpl<$Res>
    implements _$ProjectLinkCopyWith<$Res> {
  __$ProjectLinkCopyWithImpl(this._self, this._then);

  final _ProjectLink _self;
  final $Res Function(_ProjectLink) _then;

/// Create a copy of ProjectLink
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fromProjectId = null,Object? toProjectId = null,Object? relation = null,}) {
  return _then(_ProjectLink(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fromProjectId: null == fromProjectId ? _self.fromProjectId : fromProjectId // ignore: cast_nullable_to_non_nullable
as String,toProjectId: null == toProjectId ? _self.toProjectId : toProjectId // ignore: cast_nullable_to_non_nullable
as String,relation: null == relation ? _self.relation : relation // ignore: cast_nullable_to_non_nullable
as LinkRelation,
  ));
}


}

// dart format on
