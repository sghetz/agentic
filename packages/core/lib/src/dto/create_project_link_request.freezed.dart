// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_project_link_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateProjectLinkRequest {

 String get toProjectId; LinkRelation get relation;
/// Create a copy of CreateProjectLinkRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateProjectLinkRequestCopyWith<CreateProjectLinkRequest> get copyWith => _$CreateProjectLinkRequestCopyWithImpl<CreateProjectLinkRequest>(this as CreateProjectLinkRequest, _$identity);

  /// Serializes this CreateProjectLinkRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CreateProjectLinkRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateProjectLinkRequest&&(identical(other.toProjectId, _this.toProjectId) || other.toProjectId == _this.toProjectId)&&(identical(other.relation, _this.relation) || other.relation == _this.relation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CreateProjectLinkRequest;
  return Object.hash(runtimeType,_this.toProjectId,_this.relation);
}

@override
String toString() {
  final _this = this as CreateProjectLinkRequest;
  return 'CreateProjectLinkRequest(toProjectId: ${_this.toProjectId}, relation: ${_this.relation})';
}


}

/// @nodoc
abstract mixin class $CreateProjectLinkRequestCopyWith<$Res>  {
  factory $CreateProjectLinkRequestCopyWith(CreateProjectLinkRequest value, $Res Function(CreateProjectLinkRequest) _then) = _$CreateProjectLinkRequestCopyWithImpl;
@useResult
$Res call({
 String toProjectId, LinkRelation relation
});




}
/// @nodoc
class _$CreateProjectLinkRequestCopyWithImpl<$Res>
    implements $CreateProjectLinkRequestCopyWith<$Res> {
  _$CreateProjectLinkRequestCopyWithImpl(this._self, this._then);

  final CreateProjectLinkRequest _self;
  final $Res Function(CreateProjectLinkRequest) _then;

/// Create a copy of CreateProjectLinkRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? toProjectId = null,Object? relation = null,}) {
  return _then(CreateProjectLinkRequest(
toProjectId: null == toProjectId ? _self.toProjectId : toProjectId // ignore: cast_nullable_to_non_nullable
as String,relation: null == relation ? _self.relation : relation // ignore: cast_nullable_to_non_nullable
as LinkRelation,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateProjectLinkRequest].
extension CreateProjectLinkRequestPatterns on CreateProjectLinkRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateProjectLinkRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateProjectLinkRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateProjectLinkRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateProjectLinkRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateProjectLinkRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateProjectLinkRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String toProjectId,  LinkRelation relation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateProjectLinkRequest() when $default != null:
return $default(_that.toProjectId,_that.relation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String toProjectId,  LinkRelation relation)  $default,) {final _that = this;
switch (_that) {
case _CreateProjectLinkRequest():
return $default(_that.toProjectId,_that.relation);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String toProjectId,  LinkRelation relation)?  $default,) {final _that = this;
switch (_that) {
case _CreateProjectLinkRequest() when $default != null:
return $default(_that.toProjectId,_that.relation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateProjectLinkRequest implements CreateProjectLinkRequest {
  const _CreateProjectLinkRequest({required this.toProjectId, required this.relation});
  factory _CreateProjectLinkRequest.fromJson(Map<String, dynamic> json) => _$CreateProjectLinkRequestFromJson(json);

@override final  String toProjectId;
@override final  LinkRelation relation;

/// Create a copy of CreateProjectLinkRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateProjectLinkRequestCopyWith<_CreateProjectLinkRequest> get copyWith => __$CreateProjectLinkRequestCopyWithImpl<_CreateProjectLinkRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateProjectLinkRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateProjectLinkRequest&&(identical(other.toProjectId, toProjectId) || other.toProjectId == toProjectId)&&(identical(other.relation, relation) || other.relation == relation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,toProjectId,relation);
}

@override
String toString() {
    return 'CreateProjectLinkRequest(toProjectId: $toProjectId, relation: $relation)';
}


}

/// @nodoc
abstract mixin class _$CreateProjectLinkRequestCopyWith<$Res> implements $CreateProjectLinkRequestCopyWith<$Res> {
  factory _$CreateProjectLinkRequestCopyWith(_CreateProjectLinkRequest value, $Res Function(_CreateProjectLinkRequest) _then) = __$CreateProjectLinkRequestCopyWithImpl;
@override @useResult
$Res call({
 String toProjectId, LinkRelation relation
});




}
/// @nodoc
class __$CreateProjectLinkRequestCopyWithImpl<$Res>
    implements _$CreateProjectLinkRequestCopyWith<$Res> {
  __$CreateProjectLinkRequestCopyWithImpl(this._self, this._then);

  final _CreateProjectLinkRequest _self;
  final $Res Function(_CreateProjectLinkRequest) _then;

/// Create a copy of CreateProjectLinkRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? toProjectId = null,Object? relation = null,}) {
  return _then(_CreateProjectLinkRequest(
toProjectId: null == toProjectId ? _self.toProjectId : toProjectId // ignore: cast_nullable_to_non_nullable
as String,relation: null == relation ? _self.relation : relation // ignore: cast_nullable_to_non_nullable
as LinkRelation,
  ));
}


}

// dart format on
