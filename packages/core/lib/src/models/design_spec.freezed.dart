// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'design_spec.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DesignSpec {

 String get projectId; List<ScreenSpec> get screens; List<String> get requirementIds; String? get sourceTaskSpecArtifactId;
/// Create a copy of DesignSpec
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DesignSpecCopyWith<DesignSpec> get copyWith => _$DesignSpecCopyWithImpl<DesignSpec>(this as DesignSpec, _$identity);

  /// Serializes this DesignSpec to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DesignSpec;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DesignSpec&&(identical(other.projectId, _this.projectId) || other.projectId == _this.projectId)&&const DeepCollectionEquality().equals(other.screens, _this.screens)&&const DeepCollectionEquality().equals(other.requirementIds, _this.requirementIds)&&(identical(other.sourceTaskSpecArtifactId, _this.sourceTaskSpecArtifactId) || other.sourceTaskSpecArtifactId == _this.sourceTaskSpecArtifactId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DesignSpec;
  return Object.hash(runtimeType,_this.projectId,const DeepCollectionEquality().hash(_this.screens),const DeepCollectionEquality().hash(_this.requirementIds),_this.sourceTaskSpecArtifactId);
}

@override
String toString() {
  final _this = this as DesignSpec;
  return 'DesignSpec(projectId: ${_this.projectId}, screens: ${_this.screens}, requirementIds: ${_this.requirementIds}, sourceTaskSpecArtifactId: ${_this.sourceTaskSpecArtifactId})';
}


}

/// @nodoc
abstract mixin class $DesignSpecCopyWith<$Res>  {
  factory $DesignSpecCopyWith(DesignSpec value, $Res Function(DesignSpec) _then) = _$DesignSpecCopyWithImpl;
@useResult
$Res call({
 String projectId, List<ScreenSpec> screens, List<String> requirementIds, String? sourceTaskSpecArtifactId
});




}
/// @nodoc
class _$DesignSpecCopyWithImpl<$Res>
    implements $DesignSpecCopyWith<$Res> {
  _$DesignSpecCopyWithImpl(this._self, this._then);

  final DesignSpec _self;
  final $Res Function(DesignSpec) _then;

/// Create a copy of DesignSpec
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? projectId = null,Object? screens = null,Object? requirementIds = null,Object? sourceTaskSpecArtifactId = freezed,}) {
  return _then(DesignSpec(
projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,screens: null == screens ? _self.screens : screens // ignore: cast_nullable_to_non_nullable
as List<ScreenSpec>,requirementIds: null == requirementIds ? _self.requirementIds : requirementIds // ignore: cast_nullable_to_non_nullable
as List<String>,sourceTaskSpecArtifactId: freezed == sourceTaskSpecArtifactId ? _self.sourceTaskSpecArtifactId : sourceTaskSpecArtifactId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DesignSpec].
extension DesignSpecPatterns on DesignSpec {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DesignSpec value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DesignSpec() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DesignSpec value)  $default,){
final _that = this;
switch (_that) {
case _DesignSpec():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DesignSpec value)?  $default,){
final _that = this;
switch (_that) {
case _DesignSpec() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String projectId,  List<ScreenSpec> screens,  List<String> requirementIds,  String? sourceTaskSpecArtifactId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DesignSpec() when $default != null:
return $default(_that.projectId,_that.screens,_that.requirementIds,_that.sourceTaskSpecArtifactId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String projectId,  List<ScreenSpec> screens,  List<String> requirementIds,  String? sourceTaskSpecArtifactId)  $default,) {final _that = this;
switch (_that) {
case _DesignSpec():
return $default(_that.projectId,_that.screens,_that.requirementIds,_that.sourceTaskSpecArtifactId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String projectId,  List<ScreenSpec> screens,  List<String> requirementIds,  String? sourceTaskSpecArtifactId)?  $default,) {final _that = this;
switch (_that) {
case _DesignSpec() when $default != null:
return $default(_that.projectId,_that.screens,_that.requirementIds,_that.sourceTaskSpecArtifactId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DesignSpec implements DesignSpec {
  const _DesignSpec({required this.projectId,  List<ScreenSpec> screens = const [],  List<String> requirementIds = const [], this.sourceTaskSpecArtifactId}): _screens = screens,_requirementIds = requirementIds;
  factory _DesignSpec.fromJson(Map<String, dynamic> json) => _$DesignSpecFromJson(json);

@override final  String projectId;
 final  List<ScreenSpec> _screens;
@override@JsonKey() List<ScreenSpec> get screens {
  if (_screens is EqualUnmodifiableListView) return _screens;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_screens);
}

 final  List<String> _requirementIds;
@override@JsonKey() List<String> get requirementIds {
  if (_requirementIds is EqualUnmodifiableListView) return _requirementIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_requirementIds);
}

@override final  String? sourceTaskSpecArtifactId;

/// Create a copy of DesignSpec
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DesignSpecCopyWith<_DesignSpec> get copyWith => __$DesignSpecCopyWithImpl<_DesignSpec>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DesignSpecToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DesignSpec&&(identical(other.projectId, projectId) || other.projectId == projectId)&&const DeepCollectionEquality().equals(other.screens, _screens)&&const DeepCollectionEquality().equals(other.requirementIds, _requirementIds)&&(identical(other.sourceTaskSpecArtifactId, sourceTaskSpecArtifactId) || other.sourceTaskSpecArtifactId == sourceTaskSpecArtifactId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,projectId,const DeepCollectionEquality().hash(_screens),const DeepCollectionEquality().hash(_requirementIds),sourceTaskSpecArtifactId);
}

@override
String toString() {
    return 'DesignSpec(projectId: $projectId, screens: $screens, requirementIds: $requirementIds, sourceTaskSpecArtifactId: $sourceTaskSpecArtifactId)';
}


}

/// @nodoc
abstract mixin class _$DesignSpecCopyWith<$Res> implements $DesignSpecCopyWith<$Res> {
  factory _$DesignSpecCopyWith(_DesignSpec value, $Res Function(_DesignSpec) _then) = __$DesignSpecCopyWithImpl;
@override @useResult
$Res call({
 String projectId, List<ScreenSpec> screens, List<String> requirementIds, String? sourceTaskSpecArtifactId
});




}
/// @nodoc
class __$DesignSpecCopyWithImpl<$Res>
    implements _$DesignSpecCopyWith<$Res> {
  __$DesignSpecCopyWithImpl(this._self, this._then);

  final _DesignSpec _self;
  final $Res Function(_DesignSpec) _then;

/// Create a copy of DesignSpec
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? projectId = null,Object? screens = null,Object? requirementIds = null,Object? sourceTaskSpecArtifactId = freezed,}) {
  return _then(_DesignSpec(
projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,screens: null == screens ? _self._screens : screens // ignore: cast_nullable_to_non_nullable
as List<ScreenSpec>,requirementIds: null == requirementIds ? _self._requirementIds : requirementIds // ignore: cast_nullable_to_non_nullable
as List<String>,sourceTaskSpecArtifactId: freezed == sourceTaskSpecArtifactId ? _self.sourceTaskSpecArtifactId : sourceTaskSpecArtifactId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
