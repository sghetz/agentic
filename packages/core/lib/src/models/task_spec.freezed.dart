// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_spec.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TaskSpec {

 String get projectId; String get goal; List<String> get requirementIds; List<String> get acceptanceCriteria; List<String> get affectedAreas; TaskSpecPriority get priority; List<String> get openQuestions;
/// Create a copy of TaskSpec
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskSpecCopyWith<TaskSpec> get copyWith => _$TaskSpecCopyWithImpl<TaskSpec>(this as TaskSpec, _$identity);

  /// Serializes this TaskSpec to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TaskSpec;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskSpec&&(identical(other.projectId, _this.projectId) || other.projectId == _this.projectId)&&(identical(other.goal, _this.goal) || other.goal == _this.goal)&&const DeepCollectionEquality().equals(other.requirementIds, _this.requirementIds)&&const DeepCollectionEquality().equals(other.acceptanceCriteria, _this.acceptanceCriteria)&&const DeepCollectionEquality().equals(other.affectedAreas, _this.affectedAreas)&&(identical(other.priority, _this.priority) || other.priority == _this.priority)&&const DeepCollectionEquality().equals(other.openQuestions, _this.openQuestions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TaskSpec;
  return Object.hash(runtimeType,_this.projectId,_this.goal,const DeepCollectionEquality().hash(_this.requirementIds),const DeepCollectionEquality().hash(_this.acceptanceCriteria),const DeepCollectionEquality().hash(_this.affectedAreas),_this.priority,const DeepCollectionEquality().hash(_this.openQuestions));
}

@override
String toString() {
  final _this = this as TaskSpec;
  return 'TaskSpec(projectId: ${_this.projectId}, goal: ${_this.goal}, requirementIds: ${_this.requirementIds}, acceptanceCriteria: ${_this.acceptanceCriteria}, affectedAreas: ${_this.affectedAreas}, priority: ${_this.priority}, openQuestions: ${_this.openQuestions})';
}


}

/// @nodoc
abstract mixin class $TaskSpecCopyWith<$Res>  {
  factory $TaskSpecCopyWith(TaskSpec value, $Res Function(TaskSpec) _then) = _$TaskSpecCopyWithImpl;
@useResult
$Res call({
 String projectId, String goal, List<String> requirementIds, List<String> acceptanceCriteria, List<String> affectedAreas, TaskSpecPriority priority, List<String> openQuestions
});




}
/// @nodoc
class _$TaskSpecCopyWithImpl<$Res>
    implements $TaskSpecCopyWith<$Res> {
  _$TaskSpecCopyWithImpl(this._self, this._then);

  final TaskSpec _self;
  final $Res Function(TaskSpec) _then;

/// Create a copy of TaskSpec
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? projectId = null,Object? goal = null,Object? requirementIds = null,Object? acceptanceCriteria = null,Object? affectedAreas = null,Object? priority = null,Object? openQuestions = null,}) {
  return _then(TaskSpec(
projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as String,requirementIds: null == requirementIds ? _self.requirementIds : requirementIds // ignore: cast_nullable_to_non_nullable
as List<String>,acceptanceCriteria: null == acceptanceCriteria ? _self.acceptanceCriteria : acceptanceCriteria // ignore: cast_nullable_to_non_nullable
as List<String>,affectedAreas: null == affectedAreas ? _self.affectedAreas : affectedAreas // ignore: cast_nullable_to_non_nullable
as List<String>,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskSpecPriority,openQuestions: null == openQuestions ? _self.openQuestions : openQuestions // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskSpec].
extension TaskSpecPatterns on TaskSpec {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskSpec value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskSpec() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskSpec value)  $default,){
final _that = this;
switch (_that) {
case _TaskSpec():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskSpec value)?  $default,){
final _that = this;
switch (_that) {
case _TaskSpec() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String projectId,  String goal,  List<String> requirementIds,  List<String> acceptanceCriteria,  List<String> affectedAreas,  TaskSpecPriority priority,  List<String> openQuestions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskSpec() when $default != null:
return $default(_that.projectId,_that.goal,_that.requirementIds,_that.acceptanceCriteria,_that.affectedAreas,_that.priority,_that.openQuestions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String projectId,  String goal,  List<String> requirementIds,  List<String> acceptanceCriteria,  List<String> affectedAreas,  TaskSpecPriority priority,  List<String> openQuestions)  $default,) {final _that = this;
switch (_that) {
case _TaskSpec():
return $default(_that.projectId,_that.goal,_that.requirementIds,_that.acceptanceCriteria,_that.affectedAreas,_that.priority,_that.openQuestions);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String projectId,  String goal,  List<String> requirementIds,  List<String> acceptanceCriteria,  List<String> affectedAreas,  TaskSpecPriority priority,  List<String> openQuestions)?  $default,) {final _that = this;
switch (_that) {
case _TaskSpec() when $default != null:
return $default(_that.projectId,_that.goal,_that.requirementIds,_that.acceptanceCriteria,_that.affectedAreas,_that.priority,_that.openQuestions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskSpec implements TaskSpec {
  const _TaskSpec({required this.projectId, required this.goal,  List<String> requirementIds = const [],  List<String> acceptanceCriteria = const [],  List<String> affectedAreas = const [], required this.priority,  List<String> openQuestions = const []}): _requirementIds = requirementIds,_acceptanceCriteria = acceptanceCriteria,_affectedAreas = affectedAreas,_openQuestions = openQuestions;
  factory _TaskSpec.fromJson(Map<String, dynamic> json) => _$TaskSpecFromJson(json);

@override final  String projectId;
@override final  String goal;
 final  List<String> _requirementIds;
@override@JsonKey() List<String> get requirementIds {
  if (_requirementIds is EqualUnmodifiableListView) return _requirementIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_requirementIds);
}

 final  List<String> _acceptanceCriteria;
@override@JsonKey() List<String> get acceptanceCriteria {
  if (_acceptanceCriteria is EqualUnmodifiableListView) return _acceptanceCriteria;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_acceptanceCriteria);
}

 final  List<String> _affectedAreas;
@override@JsonKey() List<String> get affectedAreas {
  if (_affectedAreas is EqualUnmodifiableListView) return _affectedAreas;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_affectedAreas);
}

@override final  TaskSpecPriority priority;
 final  List<String> _openQuestions;
@override@JsonKey() List<String> get openQuestions {
  if (_openQuestions is EqualUnmodifiableListView) return _openQuestions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_openQuestions);
}


/// Create a copy of TaskSpec
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskSpecCopyWith<_TaskSpec> get copyWith => __$TaskSpecCopyWithImpl<_TaskSpec>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskSpecToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskSpec&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.goal, goal) || other.goal == goal)&&const DeepCollectionEquality().equals(other.requirementIds, _requirementIds)&&const DeepCollectionEquality().equals(other.acceptanceCriteria, _acceptanceCriteria)&&const DeepCollectionEquality().equals(other.affectedAreas, _affectedAreas)&&(identical(other.priority, priority) || other.priority == priority)&&const DeepCollectionEquality().equals(other.openQuestions, _openQuestions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,projectId,goal,const DeepCollectionEquality().hash(_requirementIds),const DeepCollectionEquality().hash(_acceptanceCriteria),const DeepCollectionEquality().hash(_affectedAreas),priority,const DeepCollectionEquality().hash(_openQuestions));
}

@override
String toString() {
    return 'TaskSpec(projectId: $projectId, goal: $goal, requirementIds: $requirementIds, acceptanceCriteria: $acceptanceCriteria, affectedAreas: $affectedAreas, priority: $priority, openQuestions: $openQuestions)';
}


}

/// @nodoc
abstract mixin class _$TaskSpecCopyWith<$Res> implements $TaskSpecCopyWith<$Res> {
  factory _$TaskSpecCopyWith(_TaskSpec value, $Res Function(_TaskSpec) _then) = __$TaskSpecCopyWithImpl;
@override @useResult
$Res call({
 String projectId, String goal, List<String> requirementIds, List<String> acceptanceCriteria, List<String> affectedAreas, TaskSpecPriority priority, List<String> openQuestions
});




}
/// @nodoc
class __$TaskSpecCopyWithImpl<$Res>
    implements _$TaskSpecCopyWith<$Res> {
  __$TaskSpecCopyWithImpl(this._self, this._then);

  final _TaskSpec _self;
  final $Res Function(_TaskSpec) _then;

/// Create a copy of TaskSpec
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? projectId = null,Object? goal = null,Object? requirementIds = null,Object? acceptanceCriteria = null,Object? affectedAreas = null,Object? priority = null,Object? openQuestions = null,}) {
  return _then(_TaskSpec(
projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as String,requirementIds: null == requirementIds ? _self._requirementIds : requirementIds // ignore: cast_nullable_to_non_nullable
as List<String>,acceptanceCriteria: null == acceptanceCriteria ? _self._acceptanceCriteria : acceptanceCriteria // ignore: cast_nullable_to_non_nullable
as List<String>,affectedAreas: null == affectedAreas ? _self._affectedAreas : affectedAreas // ignore: cast_nullable_to_non_nullable
as List<String>,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskSpecPriority,openQuestions: null == openQuestions ? _self._openQuestions : openQuestions // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
