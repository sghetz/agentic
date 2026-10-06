// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HealthCheckStep {

 String get name; HealthCheckStepStatus get status; int get durationMs; String get output;
/// Create a copy of HealthCheckStep
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthCheckStepCopyWith<HealthCheckStep> get copyWith => _$HealthCheckStepCopyWithImpl<HealthCheckStep>(this as HealthCheckStep, _$identity);

  /// Serializes this HealthCheckStep to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as HealthCheckStep;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthCheckStep&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.durationMs, _this.durationMs) || other.durationMs == _this.durationMs)&&(identical(other.output, _this.output) || other.output == _this.output));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as HealthCheckStep;
  return Object.hash(runtimeType,_this.name,_this.status,_this.durationMs,_this.output);
}

@override
String toString() {
  final _this = this as HealthCheckStep;
  return 'HealthCheckStep(name: ${_this.name}, status: ${_this.status}, durationMs: ${_this.durationMs}, output: ${_this.output})';
}


}

/// @nodoc
abstract mixin class $HealthCheckStepCopyWith<$Res>  {
  factory $HealthCheckStepCopyWith(HealthCheckStep value, $Res Function(HealthCheckStep) _then) = _$HealthCheckStepCopyWithImpl;
@useResult
$Res call({
 String name, HealthCheckStepStatus status, int durationMs, String output
});




}
/// @nodoc
class _$HealthCheckStepCopyWithImpl<$Res>
    implements $HealthCheckStepCopyWith<$Res> {
  _$HealthCheckStepCopyWithImpl(this._self, this._then);

  final HealthCheckStep _self;
  final $Res Function(HealthCheckStep) _then;

/// Create a copy of HealthCheckStep
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? status = null,Object? durationMs = null,Object? output = null,}) {
  return _then(HealthCheckStep(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as HealthCheckStepStatus,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,output: null == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HealthCheckStep].
extension HealthCheckStepPatterns on HealthCheckStep {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthCheckStep value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthCheckStep() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthCheckStep value)  $default,){
final _that = this;
switch (_that) {
case _HealthCheckStep():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthCheckStep value)?  $default,){
final _that = this;
switch (_that) {
case _HealthCheckStep() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  HealthCheckStepStatus status,  int durationMs,  String output)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthCheckStep() when $default != null:
return $default(_that.name,_that.status,_that.durationMs,_that.output);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  HealthCheckStepStatus status,  int durationMs,  String output)  $default,) {final _that = this;
switch (_that) {
case _HealthCheckStep():
return $default(_that.name,_that.status,_that.durationMs,_that.output);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  HealthCheckStepStatus status,  int durationMs,  String output)?  $default,) {final _that = this;
switch (_that) {
case _HealthCheckStep() when $default != null:
return $default(_that.name,_that.status,_that.durationMs,_that.output);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HealthCheckStep implements HealthCheckStep {
  const _HealthCheckStep({required this.name, required this.status, required this.durationMs, required this.output});
  factory _HealthCheckStep.fromJson(Map<String, dynamic> json) => _$HealthCheckStepFromJson(json);

@override final  String name;
@override final  HealthCheckStepStatus status;
@override final  int durationMs;
@override final  String output;

/// Create a copy of HealthCheckStep
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthCheckStepCopyWith<_HealthCheckStep> get copyWith => __$HealthCheckStepCopyWithImpl<_HealthCheckStep>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HealthCheckStepToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthCheckStep&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.output, output) || other.output == output));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,status,durationMs,output);
}

@override
String toString() {
    return 'HealthCheckStep(name: $name, status: $status, durationMs: $durationMs, output: $output)';
}


}

/// @nodoc
abstract mixin class _$HealthCheckStepCopyWith<$Res> implements $HealthCheckStepCopyWith<$Res> {
  factory _$HealthCheckStepCopyWith(_HealthCheckStep value, $Res Function(_HealthCheckStep) _then) = __$HealthCheckStepCopyWithImpl;
@override @useResult
$Res call({
 String name, HealthCheckStepStatus status, int durationMs, String output
});




}
/// @nodoc
class __$HealthCheckStepCopyWithImpl<$Res>
    implements _$HealthCheckStepCopyWith<$Res> {
  __$HealthCheckStepCopyWithImpl(this._self, this._then);

  final _HealthCheckStep _self;
  final $Res Function(_HealthCheckStep) _then;

/// Create a copy of HealthCheckStep
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? status = null,Object? durationMs = null,Object? output = null,}) {
  return _then(_HealthCheckStep(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as HealthCheckStepStatus,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,output: null == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$HealthReport {

 HealthCheckStepStatus get status; List<HealthCheckStep> get steps; DateTime get startedAt; DateTime get finishedAt;
/// Create a copy of HealthReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthReportCopyWith<HealthReport> get copyWith => _$HealthReportCopyWithImpl<HealthReport>(this as HealthReport, _$identity);

  /// Serializes this HealthReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as HealthReport;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthReport&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.steps, _this.steps)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&(identical(other.finishedAt, _this.finishedAt) || other.finishedAt == _this.finishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as HealthReport;
  return Object.hash(runtimeType,_this.status,const DeepCollectionEquality().hash(_this.steps),_this.startedAt,_this.finishedAt);
}

@override
String toString() {
  final _this = this as HealthReport;
  return 'HealthReport(status: ${_this.status}, steps: ${_this.steps}, startedAt: ${_this.startedAt}, finishedAt: ${_this.finishedAt})';
}


}

/// @nodoc
abstract mixin class $HealthReportCopyWith<$Res>  {
  factory $HealthReportCopyWith(HealthReport value, $Res Function(HealthReport) _then) = _$HealthReportCopyWithImpl;
@useResult
$Res call({
 HealthCheckStepStatus status, List<HealthCheckStep> steps, DateTime startedAt, DateTime finishedAt
});




}
/// @nodoc
class _$HealthReportCopyWithImpl<$Res>
    implements $HealthReportCopyWith<$Res> {
  _$HealthReportCopyWithImpl(this._self, this._then);

  final HealthReport _self;
  final $Res Function(HealthReport) _then;

/// Create a copy of HealthReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? steps = null,Object? startedAt = null,Object? finishedAt = null,}) {
  return _then(HealthReport(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as HealthCheckStepStatus,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as List<HealthCheckStep>,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,finishedAt: null == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [HealthReport].
extension HealthReportPatterns on HealthReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthReport value)  $default,){
final _that = this;
switch (_that) {
case _HealthReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthReport value)?  $default,){
final _that = this;
switch (_that) {
case _HealthReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( HealthCheckStepStatus status,  List<HealthCheckStep> steps,  DateTime startedAt,  DateTime finishedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthReport() when $default != null:
return $default(_that.status,_that.steps,_that.startedAt,_that.finishedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( HealthCheckStepStatus status,  List<HealthCheckStep> steps,  DateTime startedAt,  DateTime finishedAt)  $default,) {final _that = this;
switch (_that) {
case _HealthReport():
return $default(_that.status,_that.steps,_that.startedAt,_that.finishedAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( HealthCheckStepStatus status,  List<HealthCheckStep> steps,  DateTime startedAt,  DateTime finishedAt)?  $default,) {final _that = this;
switch (_that) {
case _HealthReport() when $default != null:
return $default(_that.status,_that.steps,_that.startedAt,_that.finishedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HealthReport implements HealthReport {
  const _HealthReport({required this.status, required  List<HealthCheckStep> steps, required this.startedAt, required this.finishedAt}): _steps = steps;
  factory _HealthReport.fromJson(Map<String, dynamic> json) => _$HealthReportFromJson(json);

@override final  HealthCheckStepStatus status;
 final  List<HealthCheckStep> _steps;
@override List<HealthCheckStep> get steps {
  if (_steps is EqualUnmodifiableListView) return _steps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_steps);
}

@override final  DateTime startedAt;
@override final  DateTime finishedAt;

/// Create a copy of HealthReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthReportCopyWith<_HealthReport> get copyWith => __$HealthReportCopyWithImpl<_HealthReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HealthReportToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthReport&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.steps, _steps)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_steps),startedAt,finishedAt);
}

@override
String toString() {
    return 'HealthReport(status: $status, steps: $steps, startedAt: $startedAt, finishedAt: $finishedAt)';
}


}

/// @nodoc
abstract mixin class _$HealthReportCopyWith<$Res> implements $HealthReportCopyWith<$Res> {
  factory _$HealthReportCopyWith(_HealthReport value, $Res Function(_HealthReport) _then) = __$HealthReportCopyWithImpl;
@override @useResult
$Res call({
 HealthCheckStepStatus status, List<HealthCheckStep> steps, DateTime startedAt, DateTime finishedAt
});




}
/// @nodoc
class __$HealthReportCopyWithImpl<$Res>
    implements _$HealthReportCopyWith<$Res> {
  __$HealthReportCopyWithImpl(this._self, this._then);

  final _HealthReport _self;
  final $Res Function(_HealthReport) _then;

/// Create a copy of HealthReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? steps = null,Object? startedAt = null,Object? finishedAt = null,}) {
  return _then(_HealthReport(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as HealthCheckStepStatus,steps: null == steps ? _self._steps : steps // ignore: cast_nullable_to_non_nullable
as List<HealthCheckStep>,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,finishedAt: null == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
