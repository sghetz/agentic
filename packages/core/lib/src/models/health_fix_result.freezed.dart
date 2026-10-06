// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_fix_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HealthFixResult {

 HealthFixOutcome get outcome; String? get branchName; String get summary; HealthReport? get verificationReport;
/// Create a copy of HealthFixResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthFixResultCopyWith<HealthFixResult> get copyWith => _$HealthFixResultCopyWithImpl<HealthFixResult>(this as HealthFixResult, _$identity);

  /// Serializes this HealthFixResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as HealthFixResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthFixResult&&(identical(other.outcome, _this.outcome) || other.outcome == _this.outcome)&&(identical(other.branchName, _this.branchName) || other.branchName == _this.branchName)&&(identical(other.summary, _this.summary) || other.summary == _this.summary)&&(identical(other.verificationReport, _this.verificationReport) || other.verificationReport == _this.verificationReport));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as HealthFixResult;
  return Object.hash(runtimeType,_this.outcome,_this.branchName,_this.summary,_this.verificationReport);
}

@override
String toString() {
  final _this = this as HealthFixResult;
  return 'HealthFixResult(outcome: ${_this.outcome}, branchName: ${_this.branchName}, summary: ${_this.summary}, verificationReport: ${_this.verificationReport})';
}


}

/// @nodoc
abstract mixin class $HealthFixResultCopyWith<$Res>  {
  factory $HealthFixResultCopyWith(HealthFixResult value, $Res Function(HealthFixResult) _then) = _$HealthFixResultCopyWithImpl;
@useResult
$Res call({
 HealthFixOutcome outcome, String? branchName, String summary, HealthReport? verificationReport
});


$HealthReportCopyWith<$Res>? get verificationReport;

}
/// @nodoc
class _$HealthFixResultCopyWithImpl<$Res>
    implements $HealthFixResultCopyWith<$Res> {
  _$HealthFixResultCopyWithImpl(this._self, this._then);

  final HealthFixResult _self;
  final $Res Function(HealthFixResult) _then;

/// Create a copy of HealthFixResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? outcome = null,Object? branchName = freezed,Object? summary = null,Object? verificationReport = freezed,}) {
  return _then(HealthFixResult(
outcome: null == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as HealthFixOutcome,branchName: freezed == branchName ? _self.branchName : branchName // ignore: cast_nullable_to_non_nullable
as String?,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,verificationReport: freezed == verificationReport ? _self.verificationReport : verificationReport // ignore: cast_nullable_to_non_nullable
as HealthReport?,
  ));
}
/// Create a copy of HealthFixResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HealthReportCopyWith<$Res>? get verificationReport {
    if (_self.verificationReport == null) {
    return null;
  }

  return $HealthReportCopyWith<$Res>(_self.verificationReport!, (value) {
    return _then(_self.copyWith(verificationReport: value));
  });
}
}


/// Adds pattern-matching-related methods to [HealthFixResult].
extension HealthFixResultPatterns on HealthFixResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthFixResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthFixResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthFixResult value)  $default,){
final _that = this;
switch (_that) {
case _HealthFixResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthFixResult value)?  $default,){
final _that = this;
switch (_that) {
case _HealthFixResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( HealthFixOutcome outcome,  String? branchName,  String summary,  HealthReport? verificationReport)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthFixResult() when $default != null:
return $default(_that.outcome,_that.branchName,_that.summary,_that.verificationReport);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( HealthFixOutcome outcome,  String? branchName,  String summary,  HealthReport? verificationReport)  $default,) {final _that = this;
switch (_that) {
case _HealthFixResult():
return $default(_that.outcome,_that.branchName,_that.summary,_that.verificationReport);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( HealthFixOutcome outcome,  String? branchName,  String summary,  HealthReport? verificationReport)?  $default,) {final _that = this;
switch (_that) {
case _HealthFixResult() when $default != null:
return $default(_that.outcome,_that.branchName,_that.summary,_that.verificationReport);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HealthFixResult implements HealthFixResult {
  const _HealthFixResult({required this.outcome, this.branchName, required this.summary, this.verificationReport});
  factory _HealthFixResult.fromJson(Map<String, dynamic> json) => _$HealthFixResultFromJson(json);

@override final  HealthFixOutcome outcome;
@override final  String? branchName;
@override final  String summary;
@override final  HealthReport? verificationReport;

/// Create a copy of HealthFixResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthFixResultCopyWith<_HealthFixResult> get copyWith => __$HealthFixResultCopyWithImpl<_HealthFixResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HealthFixResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthFixResult&&(identical(other.outcome, outcome) || other.outcome == outcome)&&(identical(other.branchName, branchName) || other.branchName == branchName)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.verificationReport, verificationReport) || other.verificationReport == verificationReport));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,outcome,branchName,summary,verificationReport);
}

@override
String toString() {
    return 'HealthFixResult(outcome: $outcome, branchName: $branchName, summary: $summary, verificationReport: $verificationReport)';
}


}

/// @nodoc
abstract mixin class _$HealthFixResultCopyWith<$Res> implements $HealthFixResultCopyWith<$Res> {
  factory _$HealthFixResultCopyWith(_HealthFixResult value, $Res Function(_HealthFixResult) _then) = __$HealthFixResultCopyWithImpl;
@override @useResult
$Res call({
 HealthFixOutcome outcome, String? branchName, String summary, HealthReport? verificationReport
});


@override $HealthReportCopyWith<$Res>? get verificationReport;

}
/// @nodoc
class __$HealthFixResultCopyWithImpl<$Res>
    implements _$HealthFixResultCopyWith<$Res> {
  __$HealthFixResultCopyWithImpl(this._self, this._then);

  final _HealthFixResult _self;
  final $Res Function(_HealthFixResult) _then;

/// Create a copy of HealthFixResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? outcome = null,Object? branchName = freezed,Object? summary = null,Object? verificationReport = freezed,}) {
  return _then(_HealthFixResult(
outcome: null == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as HealthFixOutcome,branchName: freezed == branchName ? _self.branchName : branchName // ignore: cast_nullable_to_non_nullable
as String?,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,verificationReport: freezed == verificationReport ? _self.verificationReport : verificationReport // ignore: cast_nullable_to_non_nullable
as HealthReport?,
  ));
}

/// Create a copy of HealthFixResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HealthReportCopyWith<$Res>? get verificationReport {
    if (_self.verificationReport == null) {
    return null;
  }

  return $HealthReportCopyWith<$Res>(_self.verificationReport!, (value) {
    return _then(_self.copyWith(verificationReport: value));
  });
}
}

// dart format on
