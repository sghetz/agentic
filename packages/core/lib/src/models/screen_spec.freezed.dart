// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'screen_spec.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScreenSpec {

 String get name; String get purpose; List<ScreenUiState> get states; List<String> get navigatesTo;
/// Create a copy of ScreenSpec
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScreenSpecCopyWith<ScreenSpec> get copyWith => _$ScreenSpecCopyWithImpl<ScreenSpec>(this as ScreenSpec, _$identity);

  /// Serializes this ScreenSpec to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ScreenSpec;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScreenSpec&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.purpose, _this.purpose) || other.purpose == _this.purpose)&&const DeepCollectionEquality().equals(other.states, _this.states)&&const DeepCollectionEquality().equals(other.navigatesTo, _this.navigatesTo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ScreenSpec;
  return Object.hash(runtimeType,_this.name,_this.purpose,const DeepCollectionEquality().hash(_this.states),const DeepCollectionEquality().hash(_this.navigatesTo));
}

@override
String toString() {
  final _this = this as ScreenSpec;
  return 'ScreenSpec(name: ${_this.name}, purpose: ${_this.purpose}, states: ${_this.states}, navigatesTo: ${_this.navigatesTo})';
}


}

/// @nodoc
abstract mixin class $ScreenSpecCopyWith<$Res>  {
  factory $ScreenSpecCopyWith(ScreenSpec value, $Res Function(ScreenSpec) _then) = _$ScreenSpecCopyWithImpl;
@useResult
$Res call({
 String name, String purpose, List<ScreenUiState> states, List<String> navigatesTo
});




}
/// @nodoc
class _$ScreenSpecCopyWithImpl<$Res>
    implements $ScreenSpecCopyWith<$Res> {
  _$ScreenSpecCopyWithImpl(this._self, this._then);

  final ScreenSpec _self;
  final $Res Function(ScreenSpec) _then;

/// Create a copy of ScreenSpec
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? purpose = null,Object? states = null,Object? navigatesTo = null,}) {
  return _then(ScreenSpec(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,purpose: null == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as String,states: null == states ? _self.states : states // ignore: cast_nullable_to_non_nullable
as List<ScreenUiState>,navigatesTo: null == navigatesTo ? _self.navigatesTo : navigatesTo // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ScreenSpec].
extension ScreenSpecPatterns on ScreenSpec {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScreenSpec value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScreenSpec() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScreenSpec value)  $default,){
final _that = this;
switch (_that) {
case _ScreenSpec():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScreenSpec value)?  $default,){
final _that = this;
switch (_that) {
case _ScreenSpec() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String purpose,  List<ScreenUiState> states,  List<String> navigatesTo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScreenSpec() when $default != null:
return $default(_that.name,_that.purpose,_that.states,_that.navigatesTo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String purpose,  List<ScreenUiState> states,  List<String> navigatesTo)  $default,) {final _that = this;
switch (_that) {
case _ScreenSpec():
return $default(_that.name,_that.purpose,_that.states,_that.navigatesTo);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String purpose,  List<ScreenUiState> states,  List<String> navigatesTo)?  $default,) {final _that = this;
switch (_that) {
case _ScreenSpec() when $default != null:
return $default(_that.name,_that.purpose,_that.states,_that.navigatesTo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScreenSpec implements ScreenSpec {
  const _ScreenSpec({required this.name, required this.purpose,  List<ScreenUiState> states = const [],  List<String> navigatesTo = const []}): _states = states,_navigatesTo = navigatesTo;
  factory _ScreenSpec.fromJson(Map<String, dynamic> json) => _$ScreenSpecFromJson(json);

@override final  String name;
@override final  String purpose;
 final  List<ScreenUiState> _states;
@override@JsonKey() List<ScreenUiState> get states {
  if (_states is EqualUnmodifiableListView) return _states;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_states);
}

 final  List<String> _navigatesTo;
@override@JsonKey() List<String> get navigatesTo {
  if (_navigatesTo is EqualUnmodifiableListView) return _navigatesTo;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_navigatesTo);
}


/// Create a copy of ScreenSpec
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScreenSpecCopyWith<_ScreenSpec> get copyWith => __$ScreenSpecCopyWithImpl<_ScreenSpec>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScreenSpecToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScreenSpec&&(identical(other.name, name) || other.name == name)&&(identical(other.purpose, purpose) || other.purpose == purpose)&&const DeepCollectionEquality().equals(other.states, _states)&&const DeepCollectionEquality().equals(other.navigatesTo, _navigatesTo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,purpose,const DeepCollectionEquality().hash(_states),const DeepCollectionEquality().hash(_navigatesTo));
}

@override
String toString() {
    return 'ScreenSpec(name: $name, purpose: $purpose, states: $states, navigatesTo: $navigatesTo)';
}


}

/// @nodoc
abstract mixin class _$ScreenSpecCopyWith<$Res> implements $ScreenSpecCopyWith<$Res> {
  factory _$ScreenSpecCopyWith(_ScreenSpec value, $Res Function(_ScreenSpec) _then) = __$ScreenSpecCopyWithImpl;
@override @useResult
$Res call({
 String name, String purpose, List<ScreenUiState> states, List<String> navigatesTo
});




}
/// @nodoc
class __$ScreenSpecCopyWithImpl<$Res>
    implements _$ScreenSpecCopyWith<$Res> {
  __$ScreenSpecCopyWithImpl(this._self, this._then);

  final _ScreenSpec _self;
  final $Res Function(_ScreenSpec) _then;

/// Create a copy of ScreenSpec
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? purpose = null,Object? states = null,Object? navigatesTo = null,}) {
  return _then(_ScreenSpec(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,purpose: null == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as String,states: null == states ? _self._states : states // ignore: cast_nullable_to_non_nullable
as List<ScreenUiState>,navigatesTo: null == navigatesTo ? _self._navigatesTo : navigatesTo // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
