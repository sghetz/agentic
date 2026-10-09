// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'developer_run_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeveloperRunResult {

 DeveloperOutcome get outcome; String? get branchName; String get summary; HealthReport? get verificationReport; PullRequestInfo? get pullRequest;
/// Create a copy of DeveloperRunResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeveloperRunResultCopyWith<DeveloperRunResult> get copyWith => _$DeveloperRunResultCopyWithImpl<DeveloperRunResult>(this as DeveloperRunResult, _$identity);

  /// Serializes this DeveloperRunResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DeveloperRunResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeveloperRunResult&&(identical(other.outcome, _this.outcome) || other.outcome == _this.outcome)&&(identical(other.branchName, _this.branchName) || other.branchName == _this.branchName)&&(identical(other.summary, _this.summary) || other.summary == _this.summary)&&(identical(other.verificationReport, _this.verificationReport) || other.verificationReport == _this.verificationReport)&&(identical(other.pullRequest, _this.pullRequest) || other.pullRequest == _this.pullRequest));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DeveloperRunResult;
  return Object.hash(runtimeType,_this.outcome,_this.branchName,_this.summary,_this.verificationReport,_this.pullRequest);
}

@override
String toString() {
  final _this = this as DeveloperRunResult;
  return 'DeveloperRunResult(outcome: ${_this.outcome}, branchName: ${_this.branchName}, summary: ${_this.summary}, verificationReport: ${_this.verificationReport}, pullRequest: ${_this.pullRequest})';
}


}

/// @nodoc
abstract mixin class $DeveloperRunResultCopyWith<$Res>  {
  factory $DeveloperRunResultCopyWith(DeveloperRunResult value, $Res Function(DeveloperRunResult) _then) = _$DeveloperRunResultCopyWithImpl;
@useResult
$Res call({
 DeveloperOutcome outcome, String? branchName, String summary, HealthReport? verificationReport, PullRequestInfo? pullRequest
});


$HealthReportCopyWith<$Res>? get verificationReport;$PullRequestInfoCopyWith<$Res>? get pullRequest;

}
/// @nodoc
class _$DeveloperRunResultCopyWithImpl<$Res>
    implements $DeveloperRunResultCopyWith<$Res> {
  _$DeveloperRunResultCopyWithImpl(this._self, this._then);

  final DeveloperRunResult _self;
  final $Res Function(DeveloperRunResult) _then;

/// Create a copy of DeveloperRunResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? outcome = null,Object? branchName = freezed,Object? summary = null,Object? verificationReport = freezed,Object? pullRequest = freezed,}) {
  return _then(DeveloperRunResult(
outcome: null == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as DeveloperOutcome,branchName: freezed == branchName ? _self.branchName : branchName // ignore: cast_nullable_to_non_nullable
as String?,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,verificationReport: freezed == verificationReport ? _self.verificationReport : verificationReport // ignore: cast_nullable_to_non_nullable
as HealthReport?,pullRequest: freezed == pullRequest ? _self.pullRequest : pullRequest // ignore: cast_nullable_to_non_nullable
as PullRequestInfo?,
  ));
}
/// Create a copy of DeveloperRunResult
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
}/// Create a copy of DeveloperRunResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PullRequestInfoCopyWith<$Res>? get pullRequest {
    if (_self.pullRequest == null) {
    return null;
  }

  return $PullRequestInfoCopyWith<$Res>(_self.pullRequest!, (value) {
    return _then(_self.copyWith(pullRequest: value));
  });
}
}


/// Adds pattern-matching-related methods to [DeveloperRunResult].
extension DeveloperRunResultPatterns on DeveloperRunResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeveloperRunResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeveloperRunResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeveloperRunResult value)  $default,){
final _that = this;
switch (_that) {
case _DeveloperRunResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeveloperRunResult value)?  $default,){
final _that = this;
switch (_that) {
case _DeveloperRunResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DeveloperOutcome outcome,  String? branchName,  String summary,  HealthReport? verificationReport,  PullRequestInfo? pullRequest)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeveloperRunResult() when $default != null:
return $default(_that.outcome,_that.branchName,_that.summary,_that.verificationReport,_that.pullRequest);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DeveloperOutcome outcome,  String? branchName,  String summary,  HealthReport? verificationReport,  PullRequestInfo? pullRequest)  $default,) {final _that = this;
switch (_that) {
case _DeveloperRunResult():
return $default(_that.outcome,_that.branchName,_that.summary,_that.verificationReport,_that.pullRequest);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DeveloperOutcome outcome,  String? branchName,  String summary,  HealthReport? verificationReport,  PullRequestInfo? pullRequest)?  $default,) {final _that = this;
switch (_that) {
case _DeveloperRunResult() when $default != null:
return $default(_that.outcome,_that.branchName,_that.summary,_that.verificationReport,_that.pullRequest);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeveloperRunResult implements DeveloperRunResult {
  const _DeveloperRunResult({required this.outcome, this.branchName, required this.summary, this.verificationReport, this.pullRequest});
  factory _DeveloperRunResult.fromJson(Map<String, dynamic> json) => _$DeveloperRunResultFromJson(json);

@override final  DeveloperOutcome outcome;
@override final  String? branchName;
@override final  String summary;
@override final  HealthReport? verificationReport;
@override final  PullRequestInfo? pullRequest;

/// Create a copy of DeveloperRunResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeveloperRunResultCopyWith<_DeveloperRunResult> get copyWith => __$DeveloperRunResultCopyWithImpl<_DeveloperRunResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeveloperRunResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeveloperRunResult&&(identical(other.outcome, outcome) || other.outcome == outcome)&&(identical(other.branchName, branchName) || other.branchName == branchName)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.verificationReport, verificationReport) || other.verificationReport == verificationReport)&&(identical(other.pullRequest, pullRequest) || other.pullRequest == pullRequest));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,outcome,branchName,summary,verificationReport,pullRequest);
}

@override
String toString() {
    return 'DeveloperRunResult(outcome: $outcome, branchName: $branchName, summary: $summary, verificationReport: $verificationReport, pullRequest: $pullRequest)';
}


}

/// @nodoc
abstract mixin class _$DeveloperRunResultCopyWith<$Res> implements $DeveloperRunResultCopyWith<$Res> {
  factory _$DeveloperRunResultCopyWith(_DeveloperRunResult value, $Res Function(_DeveloperRunResult) _then) = __$DeveloperRunResultCopyWithImpl;
@override @useResult
$Res call({
 DeveloperOutcome outcome, String? branchName, String summary, HealthReport? verificationReport, PullRequestInfo? pullRequest
});


@override $HealthReportCopyWith<$Res>? get verificationReport;@override $PullRequestInfoCopyWith<$Res>? get pullRequest;

}
/// @nodoc
class __$DeveloperRunResultCopyWithImpl<$Res>
    implements _$DeveloperRunResultCopyWith<$Res> {
  __$DeveloperRunResultCopyWithImpl(this._self, this._then);

  final _DeveloperRunResult _self;
  final $Res Function(_DeveloperRunResult) _then;

/// Create a copy of DeveloperRunResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? outcome = null,Object? branchName = freezed,Object? summary = null,Object? verificationReport = freezed,Object? pullRequest = freezed,}) {
  return _then(_DeveloperRunResult(
outcome: null == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as DeveloperOutcome,branchName: freezed == branchName ? _self.branchName : branchName // ignore: cast_nullable_to_non_nullable
as String?,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,verificationReport: freezed == verificationReport ? _self.verificationReport : verificationReport // ignore: cast_nullable_to_non_nullable
as HealthReport?,pullRequest: freezed == pullRequest ? _self.pullRequest : pullRequest // ignore: cast_nullable_to_non_nullable
as PullRequestInfo?,
  ));
}

/// Create a copy of DeveloperRunResult
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
}/// Create a copy of DeveloperRunResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PullRequestInfoCopyWith<$Res>? get pullRequest {
    if (_self.pullRequest == null) {
    return null;
  }

  return $PullRequestInfoCopyWith<$Res>(_self.pullRequest!, (value) {
    return _then(_self.copyWith(pullRequest: value));
  });
}
}

// dart format on
