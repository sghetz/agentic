// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_artifact_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateArtifactRequest {

 ArtifactKind get kind; String get uri;
/// Create a copy of CreateArtifactRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateArtifactRequestCopyWith<CreateArtifactRequest> get copyWith => _$CreateArtifactRequestCopyWithImpl<CreateArtifactRequest>(this as CreateArtifactRequest, _$identity);

  /// Serializes this CreateArtifactRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CreateArtifactRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateArtifactRequest&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.uri, _this.uri) || other.uri == _this.uri));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CreateArtifactRequest;
  return Object.hash(runtimeType,_this.kind,_this.uri);
}

@override
String toString() {
  final _this = this as CreateArtifactRequest;
  return 'CreateArtifactRequest(kind: ${_this.kind}, uri: ${_this.uri})';
}


}

/// @nodoc
abstract mixin class $CreateArtifactRequestCopyWith<$Res>  {
  factory $CreateArtifactRequestCopyWith(CreateArtifactRequest value, $Res Function(CreateArtifactRequest) _then) = _$CreateArtifactRequestCopyWithImpl;
@useResult
$Res call({
 ArtifactKind kind, String uri
});




}
/// @nodoc
class _$CreateArtifactRequestCopyWithImpl<$Res>
    implements $CreateArtifactRequestCopyWith<$Res> {
  _$CreateArtifactRequestCopyWithImpl(this._self, this._then);

  final CreateArtifactRequest _self;
  final $Res Function(CreateArtifactRequest) _then;

/// Create a copy of CreateArtifactRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? uri = null,}) {
  return _then(CreateArtifactRequest(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ArtifactKind,uri: null == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateArtifactRequest].
extension CreateArtifactRequestPatterns on CreateArtifactRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateArtifactRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateArtifactRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateArtifactRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateArtifactRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateArtifactRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateArtifactRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ArtifactKind kind,  String uri)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateArtifactRequest() when $default != null:
return $default(_that.kind,_that.uri);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ArtifactKind kind,  String uri)  $default,) {final _that = this;
switch (_that) {
case _CreateArtifactRequest():
return $default(_that.kind,_that.uri);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ArtifactKind kind,  String uri)?  $default,) {final _that = this;
switch (_that) {
case _CreateArtifactRequest() when $default != null:
return $default(_that.kind,_that.uri);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateArtifactRequest implements CreateArtifactRequest {
  const _CreateArtifactRequest({required this.kind, required this.uri});
  factory _CreateArtifactRequest.fromJson(Map<String, dynamic> json) => _$CreateArtifactRequestFromJson(json);

@override final  ArtifactKind kind;
@override final  String uri;

/// Create a copy of CreateArtifactRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateArtifactRequestCopyWith<_CreateArtifactRequest> get copyWith => __$CreateArtifactRequestCopyWithImpl<_CreateArtifactRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateArtifactRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateArtifactRequest&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.uri, uri) || other.uri == uri));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,uri);
}

@override
String toString() {
    return 'CreateArtifactRequest(kind: $kind, uri: $uri)';
}


}

/// @nodoc
abstract mixin class _$CreateArtifactRequestCopyWith<$Res> implements $CreateArtifactRequestCopyWith<$Res> {
  factory _$CreateArtifactRequestCopyWith(_CreateArtifactRequest value, $Res Function(_CreateArtifactRequest) _then) = __$CreateArtifactRequestCopyWithImpl;
@override @useResult
$Res call({
 ArtifactKind kind, String uri
});




}
/// @nodoc
class __$CreateArtifactRequestCopyWithImpl<$Res>
    implements _$CreateArtifactRequestCopyWith<$Res> {
  __$CreateArtifactRequestCopyWithImpl(this._self, this._then);

  final _CreateArtifactRequest _self;
  final $Res Function(_CreateArtifactRequest) _then;

/// Create a copy of CreateArtifactRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? uri = null,}) {
  return _then(_CreateArtifactRequest(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ArtifactKind,uri: null == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
