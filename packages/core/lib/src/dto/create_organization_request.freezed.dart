// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_organization_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateOrganizationRequest {

 String get name; String get slug; OrgType get type;
/// Create a copy of CreateOrganizationRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateOrganizationRequestCopyWith<CreateOrganizationRequest> get copyWith => _$CreateOrganizationRequestCopyWithImpl<CreateOrganizationRequest>(this as CreateOrganizationRequest, _$identity);

  /// Serializes this CreateOrganizationRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CreateOrganizationRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateOrganizationRequest&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.type, _this.type) || other.type == _this.type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CreateOrganizationRequest;
  return Object.hash(runtimeType,_this.name,_this.slug,_this.type);
}

@override
String toString() {
  final _this = this as CreateOrganizationRequest;
  return 'CreateOrganizationRequest(name: ${_this.name}, slug: ${_this.slug}, type: ${_this.type})';
}


}

/// @nodoc
abstract mixin class $CreateOrganizationRequestCopyWith<$Res>  {
  factory $CreateOrganizationRequestCopyWith(CreateOrganizationRequest value, $Res Function(CreateOrganizationRequest) _then) = _$CreateOrganizationRequestCopyWithImpl;
@useResult
$Res call({
 String name, String slug, OrgType type
});




}
/// @nodoc
class _$CreateOrganizationRequestCopyWithImpl<$Res>
    implements $CreateOrganizationRequestCopyWith<$Res> {
  _$CreateOrganizationRequestCopyWithImpl(this._self, this._then);

  final CreateOrganizationRequest _self;
  final $Res Function(CreateOrganizationRequest) _then;

/// Create a copy of CreateOrganizationRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? slug = null,Object? type = null,}) {
  return _then(CreateOrganizationRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as OrgType,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateOrganizationRequest].
extension CreateOrganizationRequestPatterns on CreateOrganizationRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateOrganizationRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateOrganizationRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateOrganizationRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateOrganizationRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateOrganizationRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateOrganizationRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String slug,  OrgType type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateOrganizationRequest() when $default != null:
return $default(_that.name,_that.slug,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String slug,  OrgType type)  $default,) {final _that = this;
switch (_that) {
case _CreateOrganizationRequest():
return $default(_that.name,_that.slug,_that.type);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String slug,  OrgType type)?  $default,) {final _that = this;
switch (_that) {
case _CreateOrganizationRequest() when $default != null:
return $default(_that.name,_that.slug,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateOrganizationRequest implements CreateOrganizationRequest {
  const _CreateOrganizationRequest({required this.name, required this.slug, required this.type});
  factory _CreateOrganizationRequest.fromJson(Map<String, dynamic> json) => _$CreateOrganizationRequestFromJson(json);

@override final  String name;
@override final  String slug;
@override final  OrgType type;

/// Create a copy of CreateOrganizationRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateOrganizationRequestCopyWith<_CreateOrganizationRequest> get copyWith => __$CreateOrganizationRequestCopyWithImpl<_CreateOrganizationRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateOrganizationRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateOrganizationRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,slug,type);
}

@override
String toString() {
    return 'CreateOrganizationRequest(name: $name, slug: $slug, type: $type)';
}


}

/// @nodoc
abstract mixin class _$CreateOrganizationRequestCopyWith<$Res> implements $CreateOrganizationRequestCopyWith<$Res> {
  factory _$CreateOrganizationRequestCopyWith(_CreateOrganizationRequest value, $Res Function(_CreateOrganizationRequest) _then) = __$CreateOrganizationRequestCopyWithImpl;
@override @useResult
$Res call({
 String name, String slug, OrgType type
});




}
/// @nodoc
class __$CreateOrganizationRequestCopyWithImpl<$Res>
    implements _$CreateOrganizationRequestCopyWith<$Res> {
  __$CreateOrganizationRequestCopyWithImpl(this._self, this._then);

  final _CreateOrganizationRequest _self;
  final $Res Function(_CreateOrganizationRequest) _then;

/// Create a copy of CreateOrganizationRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? slug = null,Object? type = null,}) {
  return _then(_CreateOrganizationRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as OrgType,
  ));
}


}

// dart format on
