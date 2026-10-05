// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_organization_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateOrganizationRequest {

 String? get name; String? get slug;
/// Create a copy of UpdateOrganizationRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateOrganizationRequestCopyWith<UpdateOrganizationRequest> get copyWith => _$UpdateOrganizationRequestCopyWithImpl<UpdateOrganizationRequest>(this as UpdateOrganizationRequest, _$identity);

  /// Serializes this UpdateOrganizationRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UpdateOrganizationRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateOrganizationRequest&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.slug, _this.slug) || other.slug == _this.slug));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UpdateOrganizationRequest;
  return Object.hash(runtimeType,_this.name,_this.slug);
}

@override
String toString() {
  final _this = this as UpdateOrganizationRequest;
  return 'UpdateOrganizationRequest(name: ${_this.name}, slug: ${_this.slug})';
}


}

/// @nodoc
abstract mixin class $UpdateOrganizationRequestCopyWith<$Res>  {
  factory $UpdateOrganizationRequestCopyWith(UpdateOrganizationRequest value, $Res Function(UpdateOrganizationRequest) _then) = _$UpdateOrganizationRequestCopyWithImpl;
@useResult
$Res call({
 String? name, String? slug
});




}
/// @nodoc
class _$UpdateOrganizationRequestCopyWithImpl<$Res>
    implements $UpdateOrganizationRequestCopyWith<$Res> {
  _$UpdateOrganizationRequestCopyWithImpl(this._self, this._then);

  final UpdateOrganizationRequest _self;
  final $Res Function(UpdateOrganizationRequest) _then;

/// Create a copy of UpdateOrganizationRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? slug = freezed,}) {
  return _then(UpdateOrganizationRequest(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateOrganizationRequest].
extension UpdateOrganizationRequestPatterns on UpdateOrganizationRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateOrganizationRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateOrganizationRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateOrganizationRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateOrganizationRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateOrganizationRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateOrganizationRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String? slug)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateOrganizationRequest() when $default != null:
return $default(_that.name,_that.slug);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String? slug)  $default,) {final _that = this;
switch (_that) {
case _UpdateOrganizationRequest():
return $default(_that.name,_that.slug);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String? slug)?  $default,) {final _that = this;
switch (_that) {
case _UpdateOrganizationRequest() when $default != null:
return $default(_that.name,_that.slug);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateOrganizationRequest implements UpdateOrganizationRequest {
  const _UpdateOrganizationRequest({this.name, this.slug});
  factory _UpdateOrganizationRequest.fromJson(Map<String, dynamic> json) => _$UpdateOrganizationRequestFromJson(json);

@override final  String? name;
@override final  String? slug;

/// Create a copy of UpdateOrganizationRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateOrganizationRequestCopyWith<_UpdateOrganizationRequest> get copyWith => __$UpdateOrganizationRequestCopyWithImpl<_UpdateOrganizationRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateOrganizationRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateOrganizationRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,slug);
}

@override
String toString() {
    return 'UpdateOrganizationRequest(name: $name, slug: $slug)';
}


}

/// @nodoc
abstract mixin class _$UpdateOrganizationRequestCopyWith<$Res> implements $UpdateOrganizationRequestCopyWith<$Res> {
  factory _$UpdateOrganizationRequestCopyWith(_UpdateOrganizationRequest value, $Res Function(_UpdateOrganizationRequest) _then) = __$UpdateOrganizationRequestCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? slug
});




}
/// @nodoc
class __$UpdateOrganizationRequestCopyWithImpl<$Res>
    implements _$UpdateOrganizationRequestCopyWith<$Res> {
  __$UpdateOrganizationRequestCopyWithImpl(this._self, this._then);

  final _UpdateOrganizationRequest _self;
  final $Res Function(_UpdateOrganizationRequest) _then;

/// Create a copy of UpdateOrganizationRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? slug = freezed,}) {
  return _then(_UpdateOrganizationRequest(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
