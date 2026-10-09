// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pull_request_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PullRequestInfo {

 int get number; String get url; String get branch; String get baseBranch;
/// Create a copy of PullRequestInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PullRequestInfoCopyWith<PullRequestInfo> get copyWith => _$PullRequestInfoCopyWithImpl<PullRequestInfo>(this as PullRequestInfo, _$identity);

  /// Serializes this PullRequestInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PullRequestInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PullRequestInfo&&(identical(other.number, _this.number) || other.number == _this.number)&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.branch, _this.branch) || other.branch == _this.branch)&&(identical(other.baseBranch, _this.baseBranch) || other.baseBranch == _this.baseBranch));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PullRequestInfo;
  return Object.hash(runtimeType,_this.number,_this.url,_this.branch,_this.baseBranch);
}

@override
String toString() {
  final _this = this as PullRequestInfo;
  return 'PullRequestInfo(number: ${_this.number}, url: ${_this.url}, branch: ${_this.branch}, baseBranch: ${_this.baseBranch})';
}


}

/// @nodoc
abstract mixin class $PullRequestInfoCopyWith<$Res>  {
  factory $PullRequestInfoCopyWith(PullRequestInfo value, $Res Function(PullRequestInfo) _then) = _$PullRequestInfoCopyWithImpl;
@useResult
$Res call({
 int number, String url, String branch, String baseBranch
});




}
/// @nodoc
class _$PullRequestInfoCopyWithImpl<$Res>
    implements $PullRequestInfoCopyWith<$Res> {
  _$PullRequestInfoCopyWithImpl(this._self, this._then);

  final PullRequestInfo _self;
  final $Res Function(PullRequestInfo) _then;

/// Create a copy of PullRequestInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? number = null,Object? url = null,Object? branch = null,Object? baseBranch = null,}) {
  return _then(PullRequestInfo(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,branch: null == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as String,baseBranch: null == baseBranch ? _self.baseBranch : baseBranch // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PullRequestInfo].
extension PullRequestInfoPatterns on PullRequestInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PullRequestInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PullRequestInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PullRequestInfo value)  $default,){
final _that = this;
switch (_that) {
case _PullRequestInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PullRequestInfo value)?  $default,){
final _that = this;
switch (_that) {
case _PullRequestInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int number,  String url,  String branch,  String baseBranch)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PullRequestInfo() when $default != null:
return $default(_that.number,_that.url,_that.branch,_that.baseBranch);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int number,  String url,  String branch,  String baseBranch)  $default,) {final _that = this;
switch (_that) {
case _PullRequestInfo():
return $default(_that.number,_that.url,_that.branch,_that.baseBranch);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int number,  String url,  String branch,  String baseBranch)?  $default,) {final _that = this;
switch (_that) {
case _PullRequestInfo() when $default != null:
return $default(_that.number,_that.url,_that.branch,_that.baseBranch);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PullRequestInfo implements PullRequestInfo {
  const _PullRequestInfo({required this.number, required this.url, required this.branch, required this.baseBranch});
  factory _PullRequestInfo.fromJson(Map<String, dynamic> json) => _$PullRequestInfoFromJson(json);

@override final  int number;
@override final  String url;
@override final  String branch;
@override final  String baseBranch;

/// Create a copy of PullRequestInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PullRequestInfoCopyWith<_PullRequestInfo> get copyWith => __$PullRequestInfoCopyWithImpl<_PullRequestInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PullRequestInfoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PullRequestInfo&&(identical(other.number, number) || other.number == number)&&(identical(other.url, url) || other.url == url)&&(identical(other.branch, branch) || other.branch == branch)&&(identical(other.baseBranch, baseBranch) || other.baseBranch == baseBranch));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,number,url,branch,baseBranch);
}

@override
String toString() {
    return 'PullRequestInfo(number: $number, url: $url, branch: $branch, baseBranch: $baseBranch)';
}


}

/// @nodoc
abstract mixin class _$PullRequestInfoCopyWith<$Res> implements $PullRequestInfoCopyWith<$Res> {
  factory _$PullRequestInfoCopyWith(_PullRequestInfo value, $Res Function(_PullRequestInfo) _then) = __$PullRequestInfoCopyWithImpl;
@override @useResult
$Res call({
 int number, String url, String branch, String baseBranch
});




}
/// @nodoc
class __$PullRequestInfoCopyWithImpl<$Res>
    implements _$PullRequestInfoCopyWith<$Res> {
  __$PullRequestInfoCopyWithImpl(this._self, this._then);

  final _PullRequestInfo _self;
  final $Res Function(_PullRequestInfo) _then;

/// Create a copy of PullRequestInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? number = null,Object? url = null,Object? branch = null,Object? baseBranch = null,}) {
  return _then(_PullRequestInfo(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,branch: null == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as String,baseBranch: null == baseBranch ? _self.baseBranch : baseBranch // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
