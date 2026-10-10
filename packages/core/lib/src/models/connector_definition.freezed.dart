// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connector_definition.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConnectorDefinition {

 String get id; String get displayName; String get authorizeUrl; String get tokenUrl; List<String> get scopes;
/// Create a copy of ConnectorDefinition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConnectorDefinitionCopyWith<ConnectorDefinition> get copyWith => _$ConnectorDefinitionCopyWithImpl<ConnectorDefinition>(this as ConnectorDefinition, _$identity);

  /// Serializes this ConnectorDefinition to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ConnectorDefinition;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectorDefinition&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.authorizeUrl, _this.authorizeUrl) || other.authorizeUrl == _this.authorizeUrl)&&(identical(other.tokenUrl, _this.tokenUrl) || other.tokenUrl == _this.tokenUrl)&&const DeepCollectionEquality().equals(other.scopes, _this.scopes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ConnectorDefinition;
  return Object.hash(runtimeType,_this.id,_this.displayName,_this.authorizeUrl,_this.tokenUrl,const DeepCollectionEquality().hash(_this.scopes));
}

@override
String toString() {
  final _this = this as ConnectorDefinition;
  return 'ConnectorDefinition(id: ${_this.id}, displayName: ${_this.displayName}, authorizeUrl: ${_this.authorizeUrl}, tokenUrl: ${_this.tokenUrl}, scopes: ${_this.scopes})';
}


}

/// @nodoc
abstract mixin class $ConnectorDefinitionCopyWith<$Res>  {
  factory $ConnectorDefinitionCopyWith(ConnectorDefinition value, $Res Function(ConnectorDefinition) _then) = _$ConnectorDefinitionCopyWithImpl;
@useResult
$Res call({
 String id, String displayName, String authorizeUrl, String tokenUrl, List<String> scopes
});




}
/// @nodoc
class _$ConnectorDefinitionCopyWithImpl<$Res>
    implements $ConnectorDefinitionCopyWith<$Res> {
  _$ConnectorDefinitionCopyWithImpl(this._self, this._then);

  final ConnectorDefinition _self;
  final $Res Function(ConnectorDefinition) _then;

/// Create a copy of ConnectorDefinition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? displayName = null,Object? authorizeUrl = null,Object? tokenUrl = null,Object? scopes = null,}) {
  return _then(ConnectorDefinition(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,authorizeUrl: null == authorizeUrl ? _self.authorizeUrl : authorizeUrl // ignore: cast_nullable_to_non_nullable
as String,tokenUrl: null == tokenUrl ? _self.tokenUrl : tokenUrl // ignore: cast_nullable_to_non_nullable
as String,scopes: null == scopes ? _self.scopes : scopes // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ConnectorDefinition].
extension ConnectorDefinitionPatterns on ConnectorDefinition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConnectorDefinition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConnectorDefinition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConnectorDefinition value)  $default,){
final _that = this;
switch (_that) {
case _ConnectorDefinition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConnectorDefinition value)?  $default,){
final _that = this;
switch (_that) {
case _ConnectorDefinition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String displayName,  String authorizeUrl,  String tokenUrl,  List<String> scopes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConnectorDefinition() when $default != null:
return $default(_that.id,_that.displayName,_that.authorizeUrl,_that.tokenUrl,_that.scopes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String displayName,  String authorizeUrl,  String tokenUrl,  List<String> scopes)  $default,) {final _that = this;
switch (_that) {
case _ConnectorDefinition():
return $default(_that.id,_that.displayName,_that.authorizeUrl,_that.tokenUrl,_that.scopes);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String displayName,  String authorizeUrl,  String tokenUrl,  List<String> scopes)?  $default,) {final _that = this;
switch (_that) {
case _ConnectorDefinition() when $default != null:
return $default(_that.id,_that.displayName,_that.authorizeUrl,_that.tokenUrl,_that.scopes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConnectorDefinition implements ConnectorDefinition {
  const _ConnectorDefinition({required this.id, required this.displayName, required this.authorizeUrl, required this.tokenUrl, required  List<String> scopes}): _scopes = scopes;
  factory _ConnectorDefinition.fromJson(Map<String, dynamic> json) => _$ConnectorDefinitionFromJson(json);

@override final  String id;
@override final  String displayName;
@override final  String authorizeUrl;
@override final  String tokenUrl;
 final  List<String> _scopes;
@override List<String> get scopes {
  if (_scopes is EqualUnmodifiableListView) return _scopes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_scopes);
}


/// Create a copy of ConnectorDefinition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConnectorDefinitionCopyWith<_ConnectorDefinition> get copyWith => __$ConnectorDefinitionCopyWithImpl<_ConnectorDefinition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConnectorDefinitionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConnectorDefinition&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.authorizeUrl, authorizeUrl) || other.authorizeUrl == authorizeUrl)&&(identical(other.tokenUrl, tokenUrl) || other.tokenUrl == tokenUrl)&&const DeepCollectionEquality().equals(other.scopes, _scopes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,displayName,authorizeUrl,tokenUrl,const DeepCollectionEquality().hash(_scopes));
}

@override
String toString() {
    return 'ConnectorDefinition(id: $id, displayName: $displayName, authorizeUrl: $authorizeUrl, tokenUrl: $tokenUrl, scopes: $scopes)';
}


}

/// @nodoc
abstract mixin class _$ConnectorDefinitionCopyWith<$Res> implements $ConnectorDefinitionCopyWith<$Res> {
  factory _$ConnectorDefinitionCopyWith(_ConnectorDefinition value, $Res Function(_ConnectorDefinition) _then) = __$ConnectorDefinitionCopyWithImpl;
@override @useResult
$Res call({
 String id, String displayName, String authorizeUrl, String tokenUrl, List<String> scopes
});




}
/// @nodoc
class __$ConnectorDefinitionCopyWithImpl<$Res>
    implements _$ConnectorDefinitionCopyWith<$Res> {
  __$ConnectorDefinitionCopyWithImpl(this._self, this._then);

  final _ConnectorDefinition _self;
  final $Res Function(_ConnectorDefinition) _then;

/// Create a copy of ConnectorDefinition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayName = null,Object? authorizeUrl = null,Object? tokenUrl = null,Object? scopes = null,}) {
  return _then(_ConnectorDefinition(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,authorizeUrl: null == authorizeUrl ? _self.authorizeUrl : authorizeUrl // ignore: cast_nullable_to_non_nullable
as String,tokenUrl: null == tokenUrl ? _self.tokenUrl : tokenUrl // ignore: cast_nullable_to_non_nullable
as String,scopes: null == scopes ? _self._scopes : scopes // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
