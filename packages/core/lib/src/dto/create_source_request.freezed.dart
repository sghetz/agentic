// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_source_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateSourceRequest {

 SourceKind get kind; Map<String, Object?> get config; String? get projectId;
/// Create a copy of CreateSourceRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateSourceRequestCopyWith<CreateSourceRequest> get copyWith => _$CreateSourceRequestCopyWithImpl<CreateSourceRequest>(this as CreateSourceRequest, _$identity);

  /// Serializes this CreateSourceRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CreateSourceRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateSourceRequest&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&const DeepCollectionEquality().equals(other.config, _this.config)&&(identical(other.projectId, _this.projectId) || other.projectId == _this.projectId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CreateSourceRequest;
  return Object.hash(runtimeType,_this.kind,const DeepCollectionEquality().hash(_this.config),_this.projectId);
}

@override
String toString() {
  final _this = this as CreateSourceRequest;
  return 'CreateSourceRequest(kind: ${_this.kind}, config: ${_this.config}, projectId: ${_this.projectId})';
}


}

/// @nodoc
abstract mixin class $CreateSourceRequestCopyWith<$Res>  {
  factory $CreateSourceRequestCopyWith(CreateSourceRequest value, $Res Function(CreateSourceRequest) _then) = _$CreateSourceRequestCopyWithImpl;
@useResult
$Res call({
 SourceKind kind, Map<String, Object?> config, String? projectId
});




}
/// @nodoc
class _$CreateSourceRequestCopyWithImpl<$Res>
    implements $CreateSourceRequestCopyWith<$Res> {
  _$CreateSourceRequestCopyWithImpl(this._self, this._then);

  final CreateSourceRequest _self;
  final $Res Function(CreateSourceRequest) _then;

/// Create a copy of CreateSourceRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? config = null,Object? projectId = freezed,}) {
  return _then(CreateSourceRequest(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as SourceKind,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateSourceRequest].
extension CreateSourceRequestPatterns on CreateSourceRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateSourceRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateSourceRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateSourceRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateSourceRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateSourceRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateSourceRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SourceKind kind,  Map<String, Object?> config,  String? projectId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateSourceRequest() when $default != null:
return $default(_that.kind,_that.config,_that.projectId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SourceKind kind,  Map<String, Object?> config,  String? projectId)  $default,) {final _that = this;
switch (_that) {
case _CreateSourceRequest():
return $default(_that.kind,_that.config,_that.projectId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SourceKind kind,  Map<String, Object?> config,  String? projectId)?  $default,) {final _that = this;
switch (_that) {
case _CreateSourceRequest() when $default != null:
return $default(_that.kind,_that.config,_that.projectId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateSourceRequest implements CreateSourceRequest {
  const _CreateSourceRequest({required this.kind,  Map<String, Object?> config = const {}, this.projectId}): _config = config;
  factory _CreateSourceRequest.fromJson(Map<String, dynamic> json) => _$CreateSourceRequestFromJson(json);

@override final  SourceKind kind;
 final  Map<String, Object?> _config;
@override@JsonKey() Map<String, Object?> get config {
  if (_config is EqualUnmodifiableMapView) return _config;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_config);
}

@override final  String? projectId;

/// Create a copy of CreateSourceRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateSourceRequestCopyWith<_CreateSourceRequest> get copyWith => __$CreateSourceRequestCopyWithImpl<_CreateSourceRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateSourceRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateSourceRequest&&(identical(other.kind, kind) || other.kind == kind)&&const DeepCollectionEquality().equals(other.config, _config)&&(identical(other.projectId, projectId) || other.projectId == projectId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,const DeepCollectionEquality().hash(_config),projectId);
}

@override
String toString() {
    return 'CreateSourceRequest(kind: $kind, config: $config, projectId: $projectId)';
}


}

/// @nodoc
abstract mixin class _$CreateSourceRequestCopyWith<$Res> implements $CreateSourceRequestCopyWith<$Res> {
  factory _$CreateSourceRequestCopyWith(_CreateSourceRequest value, $Res Function(_CreateSourceRequest) _then) = __$CreateSourceRequestCopyWithImpl;
@override @useResult
$Res call({
 SourceKind kind, Map<String, Object?> config, String? projectId
});




}
/// @nodoc
class __$CreateSourceRequestCopyWithImpl<$Res>
    implements _$CreateSourceRequestCopyWith<$Res> {
  __$CreateSourceRequestCopyWithImpl(this._self, this._then);

  final _CreateSourceRequest _self;
  final $Res Function(_CreateSourceRequest) _then;

/// Create a copy of CreateSourceRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? config = null,Object? projectId = freezed,}) {
  return _then(_CreateSourceRequest(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as SourceKind,config: null == config ? _self._config : config // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
