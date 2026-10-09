// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pull_request_check.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PullRequestCheck {

 String get name; PrCheckConclusion get conclusion; String? get detailsUrl;
/// Create a copy of PullRequestCheck
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PullRequestCheckCopyWith<PullRequestCheck> get copyWith => _$PullRequestCheckCopyWithImpl<PullRequestCheck>(this as PullRequestCheck, _$identity);

  /// Serializes this PullRequestCheck to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PullRequestCheck;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PullRequestCheck&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.conclusion, _this.conclusion) || other.conclusion == _this.conclusion)&&(identical(other.detailsUrl, _this.detailsUrl) || other.detailsUrl == _this.detailsUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PullRequestCheck;
  return Object.hash(runtimeType,_this.name,_this.conclusion,_this.detailsUrl);
}

@override
String toString() {
  final _this = this as PullRequestCheck;
  return 'PullRequestCheck(name: ${_this.name}, conclusion: ${_this.conclusion}, detailsUrl: ${_this.detailsUrl})';
}


}

/// @nodoc
abstract mixin class $PullRequestCheckCopyWith<$Res>  {
  factory $PullRequestCheckCopyWith(PullRequestCheck value, $Res Function(PullRequestCheck) _then) = _$PullRequestCheckCopyWithImpl;
@useResult
$Res call({
 String name, PrCheckConclusion conclusion, String? detailsUrl
});




}
/// @nodoc
class _$PullRequestCheckCopyWithImpl<$Res>
    implements $PullRequestCheckCopyWith<$Res> {
  _$PullRequestCheckCopyWithImpl(this._self, this._then);

  final PullRequestCheck _self;
  final $Res Function(PullRequestCheck) _then;

/// Create a copy of PullRequestCheck
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? conclusion = null,Object? detailsUrl = freezed,}) {
  return _then(PullRequestCheck(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,conclusion: null == conclusion ? _self.conclusion : conclusion // ignore: cast_nullable_to_non_nullable
as PrCheckConclusion,detailsUrl: freezed == detailsUrl ? _self.detailsUrl : detailsUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PullRequestCheck].
extension PullRequestCheckPatterns on PullRequestCheck {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PullRequestCheck value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PullRequestCheck() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PullRequestCheck value)  $default,){
final _that = this;
switch (_that) {
case _PullRequestCheck():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PullRequestCheck value)?  $default,){
final _that = this;
switch (_that) {
case _PullRequestCheck() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  PrCheckConclusion conclusion,  String? detailsUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PullRequestCheck() when $default != null:
return $default(_that.name,_that.conclusion,_that.detailsUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  PrCheckConclusion conclusion,  String? detailsUrl)  $default,) {final _that = this;
switch (_that) {
case _PullRequestCheck():
return $default(_that.name,_that.conclusion,_that.detailsUrl);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  PrCheckConclusion conclusion,  String? detailsUrl)?  $default,) {final _that = this;
switch (_that) {
case _PullRequestCheck() when $default != null:
return $default(_that.name,_that.conclusion,_that.detailsUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PullRequestCheck implements PullRequestCheck {
  const _PullRequestCheck({required this.name, required this.conclusion, this.detailsUrl});
  factory _PullRequestCheck.fromJson(Map<String, dynamic> json) => _$PullRequestCheckFromJson(json);

@override final  String name;
@override final  PrCheckConclusion conclusion;
@override final  String? detailsUrl;

/// Create a copy of PullRequestCheck
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PullRequestCheckCopyWith<_PullRequestCheck> get copyWith => __$PullRequestCheckCopyWithImpl<_PullRequestCheck>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PullRequestCheckToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PullRequestCheck&&(identical(other.name, name) || other.name == name)&&(identical(other.conclusion, conclusion) || other.conclusion == conclusion)&&(identical(other.detailsUrl, detailsUrl) || other.detailsUrl == detailsUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,conclusion,detailsUrl);
}

@override
String toString() {
    return 'PullRequestCheck(name: $name, conclusion: $conclusion, detailsUrl: $detailsUrl)';
}


}

/// @nodoc
abstract mixin class _$PullRequestCheckCopyWith<$Res> implements $PullRequestCheckCopyWith<$Res> {
  factory _$PullRequestCheckCopyWith(_PullRequestCheck value, $Res Function(_PullRequestCheck) _then) = __$PullRequestCheckCopyWithImpl;
@override @useResult
$Res call({
 String name, PrCheckConclusion conclusion, String? detailsUrl
});




}
/// @nodoc
class __$PullRequestCheckCopyWithImpl<$Res>
    implements _$PullRequestCheckCopyWith<$Res> {
  __$PullRequestCheckCopyWithImpl(this._self, this._then);

  final _PullRequestCheck _self;
  final $Res Function(_PullRequestCheck) _then;

/// Create a copy of PullRequestCheck
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? conclusion = null,Object? detailsUrl = freezed,}) {
  return _then(_PullRequestCheck(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,conclusion: null == conclusion ? _self.conclusion : conclusion // ignore: cast_nullable_to_non_nullable
as PrCheckConclusion,detailsUrl: freezed == detailsUrl ? _self.detailsUrl : detailsUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
