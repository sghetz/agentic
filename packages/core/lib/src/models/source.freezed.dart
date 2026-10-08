// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'source.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Source {

 String get id; SourceKind get kind; Map<String, Object?> get config; String? get projectId; DateTime get createdAt;
/// Create a copy of Source
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SourceCopyWith<Source> get copyWith => _$SourceCopyWithImpl<Source>(this as Source, _$identity);

  /// Serializes this Source to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Source;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Source&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&const DeepCollectionEquality().equals(other.config, _this.config)&&(identical(other.projectId, _this.projectId) || other.projectId == _this.projectId)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Source;
  return Object.hash(runtimeType,_this.id,_this.kind,const DeepCollectionEquality().hash(_this.config),_this.projectId,_this.createdAt);
}

@override
String toString() {
  final _this = this as Source;
  return 'Source(id: ${_this.id}, kind: ${_this.kind}, config: ${_this.config}, projectId: ${_this.projectId}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $SourceCopyWith<$Res>  {
  factory $SourceCopyWith(Source value, $Res Function(Source) _then) = _$SourceCopyWithImpl;
@useResult
$Res call({
 String id, SourceKind kind, Map<String, Object?> config, String? projectId, DateTime createdAt
});




}
/// @nodoc
class _$SourceCopyWithImpl<$Res>
    implements $SourceCopyWith<$Res> {
  _$SourceCopyWithImpl(this._self, this._then);

  final Source _self;
  final $Res Function(Source) _then;

/// Create a copy of Source
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? config = null,Object? projectId = freezed,Object? createdAt = null,}) {
  return _then(Source(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as SourceKind,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Source].
extension SourcePatterns on Source {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Source value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Source() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Source value)  $default,){
final _that = this;
switch (_that) {
case _Source():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Source value)?  $default,){
final _that = this;
switch (_that) {
case _Source() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  SourceKind kind,  Map<String, Object?> config,  String? projectId,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Source() when $default != null:
return $default(_that.id,_that.kind,_that.config,_that.projectId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  SourceKind kind,  Map<String, Object?> config,  String? projectId,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Source():
return $default(_that.id,_that.kind,_that.config,_that.projectId,_that.createdAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  SourceKind kind,  Map<String, Object?> config,  String? projectId,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Source() when $default != null:
return $default(_that.id,_that.kind,_that.config,_that.projectId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Source implements Source {
  const _Source({required this.id, required this.kind, required  Map<String, Object?> config, this.projectId, required this.createdAt}): _config = config;
  factory _Source.fromJson(Map<String, dynamic> json) => _$SourceFromJson(json);

@override final  String id;
@override final  SourceKind kind;
 final  Map<String, Object?> _config;
@override Map<String, Object?> get config {
  if (_config is EqualUnmodifiableMapView) return _config;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_config);
}

@override final  String? projectId;
@override final  DateTime createdAt;

/// Create a copy of Source
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SourceCopyWith<_Source> get copyWith => __$SourceCopyWithImpl<_Source>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SourceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Source&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&const DeepCollectionEquality().equals(other.config, _config)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,kind,const DeepCollectionEquality().hash(_config),projectId,createdAt);
}

@override
String toString() {
    return 'Source(id: $id, kind: $kind, config: $config, projectId: $projectId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SourceCopyWith<$Res> implements $SourceCopyWith<$Res> {
  factory _$SourceCopyWith(_Source value, $Res Function(_Source) _then) = __$SourceCopyWithImpl;
@override @useResult
$Res call({
 String id, SourceKind kind, Map<String, Object?> config, String? projectId, DateTime createdAt
});




}
/// @nodoc
class __$SourceCopyWithImpl<$Res>
    implements _$SourceCopyWith<$Res> {
  __$SourceCopyWithImpl(this._self, this._then);

  final _Source _self;
  final $Res Function(_Source) _then;

/// Create a copy of Source
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? config = null,Object? projectId = freezed,Object? createdAt = null,}) {
  return _then(_Source(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as SourceKind,config: null == config ? _self._config : config // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
