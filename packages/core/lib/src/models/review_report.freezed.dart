// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReviewReport {

 String get summary; List<String> get acceptanceCriteriaMet; List<String> get acceptanceCriteriaUnmet; List<String> get requirementIdsCovered; List<String> get requirementIdsMissing; List<String> get codeQualityIssues; List<String> get missingTests;
/// Create a copy of ReviewReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewReportCopyWith<ReviewReport> get copyWith => _$ReviewReportCopyWithImpl<ReviewReport>(this as ReviewReport, _$identity);

  /// Serializes this ReviewReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReviewReport;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewReport&&(identical(other.summary, _this.summary) || other.summary == _this.summary)&&const DeepCollectionEquality().equals(other.acceptanceCriteriaMet, _this.acceptanceCriteriaMet)&&const DeepCollectionEquality().equals(other.acceptanceCriteriaUnmet, _this.acceptanceCriteriaUnmet)&&const DeepCollectionEquality().equals(other.requirementIdsCovered, _this.requirementIdsCovered)&&const DeepCollectionEquality().equals(other.requirementIdsMissing, _this.requirementIdsMissing)&&const DeepCollectionEquality().equals(other.codeQualityIssues, _this.codeQualityIssues)&&const DeepCollectionEquality().equals(other.missingTests, _this.missingTests));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReviewReport;
  return Object.hash(runtimeType,_this.summary,const DeepCollectionEquality().hash(_this.acceptanceCriteriaMet),const DeepCollectionEquality().hash(_this.acceptanceCriteriaUnmet),const DeepCollectionEquality().hash(_this.requirementIdsCovered),const DeepCollectionEquality().hash(_this.requirementIdsMissing),const DeepCollectionEquality().hash(_this.codeQualityIssues),const DeepCollectionEquality().hash(_this.missingTests));
}

@override
String toString() {
  final _this = this as ReviewReport;
  return 'ReviewReport(summary: ${_this.summary}, acceptanceCriteriaMet: ${_this.acceptanceCriteriaMet}, acceptanceCriteriaUnmet: ${_this.acceptanceCriteriaUnmet}, requirementIdsCovered: ${_this.requirementIdsCovered}, requirementIdsMissing: ${_this.requirementIdsMissing}, codeQualityIssues: ${_this.codeQualityIssues}, missingTests: ${_this.missingTests})';
}


}

/// @nodoc
abstract mixin class $ReviewReportCopyWith<$Res>  {
  factory $ReviewReportCopyWith(ReviewReport value, $Res Function(ReviewReport) _then) = _$ReviewReportCopyWithImpl;
@useResult
$Res call({
 String summary, List<String> acceptanceCriteriaMet, List<String> acceptanceCriteriaUnmet, List<String> requirementIdsCovered, List<String> requirementIdsMissing, List<String> codeQualityIssues, List<String> missingTests
});




}
/// @nodoc
class _$ReviewReportCopyWithImpl<$Res>
    implements $ReviewReportCopyWith<$Res> {
  _$ReviewReportCopyWithImpl(this._self, this._then);

  final ReviewReport _self;
  final $Res Function(ReviewReport) _then;

/// Create a copy of ReviewReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? summary = null,Object? acceptanceCriteriaMet = null,Object? acceptanceCriteriaUnmet = null,Object? requirementIdsCovered = null,Object? requirementIdsMissing = null,Object? codeQualityIssues = null,Object? missingTests = null,}) {
  return _then(ReviewReport(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,acceptanceCriteriaMet: null == acceptanceCriteriaMet ? _self.acceptanceCriteriaMet : acceptanceCriteriaMet // ignore: cast_nullable_to_non_nullable
as List<String>,acceptanceCriteriaUnmet: null == acceptanceCriteriaUnmet ? _self.acceptanceCriteriaUnmet : acceptanceCriteriaUnmet // ignore: cast_nullable_to_non_nullable
as List<String>,requirementIdsCovered: null == requirementIdsCovered ? _self.requirementIdsCovered : requirementIdsCovered // ignore: cast_nullable_to_non_nullable
as List<String>,requirementIdsMissing: null == requirementIdsMissing ? _self.requirementIdsMissing : requirementIdsMissing // ignore: cast_nullable_to_non_nullable
as List<String>,codeQualityIssues: null == codeQualityIssues ? _self.codeQualityIssues : codeQualityIssues // ignore: cast_nullable_to_non_nullable
as List<String>,missingTests: null == missingTests ? _self.missingTests : missingTests // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ReviewReport].
extension ReviewReportPatterns on ReviewReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviewReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviewReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviewReport value)  $default,){
final _that = this;
switch (_that) {
case _ReviewReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviewReport value)?  $default,){
final _that = this;
switch (_that) {
case _ReviewReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String summary,  List<String> acceptanceCriteriaMet,  List<String> acceptanceCriteriaUnmet,  List<String> requirementIdsCovered,  List<String> requirementIdsMissing,  List<String> codeQualityIssues,  List<String> missingTests)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReviewReport() when $default != null:
return $default(_that.summary,_that.acceptanceCriteriaMet,_that.acceptanceCriteriaUnmet,_that.requirementIdsCovered,_that.requirementIdsMissing,_that.codeQualityIssues,_that.missingTests);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String summary,  List<String> acceptanceCriteriaMet,  List<String> acceptanceCriteriaUnmet,  List<String> requirementIdsCovered,  List<String> requirementIdsMissing,  List<String> codeQualityIssues,  List<String> missingTests)  $default,) {final _that = this;
switch (_that) {
case _ReviewReport():
return $default(_that.summary,_that.acceptanceCriteriaMet,_that.acceptanceCriteriaUnmet,_that.requirementIdsCovered,_that.requirementIdsMissing,_that.codeQualityIssues,_that.missingTests);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String summary,  List<String> acceptanceCriteriaMet,  List<String> acceptanceCriteriaUnmet,  List<String> requirementIdsCovered,  List<String> requirementIdsMissing,  List<String> codeQualityIssues,  List<String> missingTests)?  $default,) {final _that = this;
switch (_that) {
case _ReviewReport() when $default != null:
return $default(_that.summary,_that.acceptanceCriteriaMet,_that.acceptanceCriteriaUnmet,_that.requirementIdsCovered,_that.requirementIdsMissing,_that.codeQualityIssues,_that.missingTests);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReviewReport implements ReviewReport {
  const _ReviewReport({required this.summary,  List<String> acceptanceCriteriaMet = const [],  List<String> acceptanceCriteriaUnmet = const [],  List<String> requirementIdsCovered = const [],  List<String> requirementIdsMissing = const [],  List<String> codeQualityIssues = const [],  List<String> missingTests = const []}): _acceptanceCriteriaMet = acceptanceCriteriaMet,_acceptanceCriteriaUnmet = acceptanceCriteriaUnmet,_requirementIdsCovered = requirementIdsCovered,_requirementIdsMissing = requirementIdsMissing,_codeQualityIssues = codeQualityIssues,_missingTests = missingTests;
  factory _ReviewReport.fromJson(Map<String, dynamic> json) => _$ReviewReportFromJson(json);

@override final  String summary;
 final  List<String> _acceptanceCriteriaMet;
@override@JsonKey() List<String> get acceptanceCriteriaMet {
  if (_acceptanceCriteriaMet is EqualUnmodifiableListView) return _acceptanceCriteriaMet;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_acceptanceCriteriaMet);
}

 final  List<String> _acceptanceCriteriaUnmet;
@override@JsonKey() List<String> get acceptanceCriteriaUnmet {
  if (_acceptanceCriteriaUnmet is EqualUnmodifiableListView) return _acceptanceCriteriaUnmet;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_acceptanceCriteriaUnmet);
}

 final  List<String> _requirementIdsCovered;
@override@JsonKey() List<String> get requirementIdsCovered {
  if (_requirementIdsCovered is EqualUnmodifiableListView) return _requirementIdsCovered;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_requirementIdsCovered);
}

 final  List<String> _requirementIdsMissing;
@override@JsonKey() List<String> get requirementIdsMissing {
  if (_requirementIdsMissing is EqualUnmodifiableListView) return _requirementIdsMissing;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_requirementIdsMissing);
}

 final  List<String> _codeQualityIssues;
@override@JsonKey() List<String> get codeQualityIssues {
  if (_codeQualityIssues is EqualUnmodifiableListView) return _codeQualityIssues;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_codeQualityIssues);
}

 final  List<String> _missingTests;
@override@JsonKey() List<String> get missingTests {
  if (_missingTests is EqualUnmodifiableListView) return _missingTests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_missingTests);
}


/// Create a copy of ReviewReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewReportCopyWith<_ReviewReport> get copyWith => __$ReviewReportCopyWithImpl<_ReviewReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReviewReportToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewReport&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.acceptanceCriteriaMet, _acceptanceCriteriaMet)&&const DeepCollectionEquality().equals(other.acceptanceCriteriaUnmet, _acceptanceCriteriaUnmet)&&const DeepCollectionEquality().equals(other.requirementIdsCovered, _requirementIdsCovered)&&const DeepCollectionEquality().equals(other.requirementIdsMissing, _requirementIdsMissing)&&const DeepCollectionEquality().equals(other.codeQualityIssues, _codeQualityIssues)&&const DeepCollectionEquality().equals(other.missingTests, _missingTests));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,summary,const DeepCollectionEquality().hash(_acceptanceCriteriaMet),const DeepCollectionEquality().hash(_acceptanceCriteriaUnmet),const DeepCollectionEquality().hash(_requirementIdsCovered),const DeepCollectionEquality().hash(_requirementIdsMissing),const DeepCollectionEquality().hash(_codeQualityIssues),const DeepCollectionEquality().hash(_missingTests));
}

@override
String toString() {
    return 'ReviewReport(summary: $summary, acceptanceCriteriaMet: $acceptanceCriteriaMet, acceptanceCriteriaUnmet: $acceptanceCriteriaUnmet, requirementIdsCovered: $requirementIdsCovered, requirementIdsMissing: $requirementIdsMissing, codeQualityIssues: $codeQualityIssues, missingTests: $missingTests)';
}


}

/// @nodoc
abstract mixin class _$ReviewReportCopyWith<$Res> implements $ReviewReportCopyWith<$Res> {
  factory _$ReviewReportCopyWith(_ReviewReport value, $Res Function(_ReviewReport) _then) = __$ReviewReportCopyWithImpl;
@override @useResult
$Res call({
 String summary, List<String> acceptanceCriteriaMet, List<String> acceptanceCriteriaUnmet, List<String> requirementIdsCovered, List<String> requirementIdsMissing, List<String> codeQualityIssues, List<String> missingTests
});




}
/// @nodoc
class __$ReviewReportCopyWithImpl<$Res>
    implements _$ReviewReportCopyWith<$Res> {
  __$ReviewReportCopyWithImpl(this._self, this._then);

  final _ReviewReport _self;
  final $Res Function(_ReviewReport) _then;

/// Create a copy of ReviewReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? summary = null,Object? acceptanceCriteriaMet = null,Object? acceptanceCriteriaUnmet = null,Object? requirementIdsCovered = null,Object? requirementIdsMissing = null,Object? codeQualityIssues = null,Object? missingTests = null,}) {
  return _then(_ReviewReport(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,acceptanceCriteriaMet: null == acceptanceCriteriaMet ? _self._acceptanceCriteriaMet : acceptanceCriteriaMet // ignore: cast_nullable_to_non_nullable
as List<String>,acceptanceCriteriaUnmet: null == acceptanceCriteriaUnmet ? _self._acceptanceCriteriaUnmet : acceptanceCriteriaUnmet // ignore: cast_nullable_to_non_nullable
as List<String>,requirementIdsCovered: null == requirementIdsCovered ? _self._requirementIdsCovered : requirementIdsCovered // ignore: cast_nullable_to_non_nullable
as List<String>,requirementIdsMissing: null == requirementIdsMissing ? _self._requirementIdsMissing : requirementIdsMissing // ignore: cast_nullable_to_non_nullable
as List<String>,codeQualityIssues: null == codeQualityIssues ? _self._codeQualityIssues : codeQualityIssues // ignore: cast_nullable_to_non_nullable
as List<String>,missingTests: null == missingTests ? _self._missingTests : missingTests // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
