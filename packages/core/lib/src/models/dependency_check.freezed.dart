// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dependency_check.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DependencyCheck {

 String get name; bool get found; String? get version; String? get error;
/// Create a copy of DependencyCheck
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DependencyCheckCopyWith<DependencyCheck> get copyWith => _$DependencyCheckCopyWithImpl<DependencyCheck>(this as DependencyCheck, _$identity);

  /// Serializes this DependencyCheck to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DependencyCheck;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DependencyCheck&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.found, _this.found) || other.found == _this.found)&&(identical(other.version, _this.version) || other.version == _this.version)&&(identical(other.error, _this.error) || other.error == _this.error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DependencyCheck;
  return Object.hash(runtimeType,_this.name,_this.found,_this.version,_this.error);
}

@override
String toString() {
  final _this = this as DependencyCheck;
  return 'DependencyCheck(name: ${_this.name}, found: ${_this.found}, version: ${_this.version}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $DependencyCheckCopyWith<$Res>  {
  factory $DependencyCheckCopyWith(DependencyCheck value, $Res Function(DependencyCheck) _then) = _$DependencyCheckCopyWithImpl;
@useResult
$Res call({
 String name, bool found, String? version, String? error
});




}
/// @nodoc
class _$DependencyCheckCopyWithImpl<$Res>
    implements $DependencyCheckCopyWith<$Res> {
  _$DependencyCheckCopyWithImpl(this._self, this._then);

  final DependencyCheck _self;
  final $Res Function(DependencyCheck) _then;

/// Create a copy of DependencyCheck
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? found = null,Object? version = freezed,Object? error = freezed,}) {
  return _then(DependencyCheck(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,found: null == found ? _self.found : found // ignore: cast_nullable_to_non_nullable
as bool,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DependencyCheck].
extension DependencyCheckPatterns on DependencyCheck {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DependencyCheck value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DependencyCheck() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DependencyCheck value)  $default,){
final _that = this;
switch (_that) {
case _DependencyCheck():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DependencyCheck value)?  $default,){
final _that = this;
switch (_that) {
case _DependencyCheck() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  bool found,  String? version,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DependencyCheck() when $default != null:
return $default(_that.name,_that.found,_that.version,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  bool found,  String? version,  String? error)  $default,) {final _that = this;
switch (_that) {
case _DependencyCheck():
return $default(_that.name,_that.found,_that.version,_that.error);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  bool found,  String? version,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _DependencyCheck() when $default != null:
return $default(_that.name,_that.found,_that.version,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DependencyCheck implements DependencyCheck {
  const _DependencyCheck({required this.name, required this.found, this.version, this.error});
  factory _DependencyCheck.fromJson(Map<String, dynamic> json) => _$DependencyCheckFromJson(json);

@override final  String name;
@override final  bool found;
@override final  String? version;
@override final  String? error;

/// Create a copy of DependencyCheck
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DependencyCheckCopyWith<_DependencyCheck> get copyWith => __$DependencyCheckCopyWithImpl<_DependencyCheck>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DependencyCheckToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DependencyCheck&&(identical(other.name, name) || other.name == name)&&(identical(other.found, found) || other.found == found)&&(identical(other.version, version) || other.version == version)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,found,version,error);
}

@override
String toString() {
    return 'DependencyCheck(name: $name, found: $found, version: $version, error: $error)';
}


}

/// @nodoc
abstract mixin class _$DependencyCheckCopyWith<$Res> implements $DependencyCheckCopyWith<$Res> {
  factory _$DependencyCheckCopyWith(_DependencyCheck value, $Res Function(_DependencyCheck) _then) = __$DependencyCheckCopyWithImpl;
@override @useResult
$Res call({
 String name, bool found, String? version, String? error
});




}
/// @nodoc
class __$DependencyCheckCopyWithImpl<$Res>
    implements _$DependencyCheckCopyWith<$Res> {
  __$DependencyCheckCopyWithImpl(this._self, this._then);

  final _DependencyCheck _self;
  final $Res Function(_DependencyCheck) _then;

/// Create a copy of DependencyCheck
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? found = null,Object? version = freezed,Object? error = freezed,}) {
  return _then(_DependencyCheck(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,found: null == found ? _self.found : found // ignore: cast_nullable_to_non_nullable
as bool,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
