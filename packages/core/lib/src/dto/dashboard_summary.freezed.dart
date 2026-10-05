// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecentActivityItem {

 String get taskId; String get taskTitle; String get projectId; String get projectName; DateTime get ts;@ActorConverter() Actor get actor; TaskEventType get eventType;
/// Create a copy of RecentActivityItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecentActivityItemCopyWith<RecentActivityItem> get copyWith => _$RecentActivityItemCopyWithImpl<RecentActivityItem>(this as RecentActivityItem, _$identity);

  /// Serializes this RecentActivityItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecentActivityItem&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.taskTitle, taskTitle) || other.taskTitle == taskTitle)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.projectName, projectName) || other.projectName == projectName)&&(identical(other.ts, ts) || other.ts == ts)&&(identical(other.actor, actor) || other.actor == actor)&&(identical(other.eventType, eventType) || other.eventType == eventType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,taskTitle,projectId,projectName,ts,actor,eventType);

@override
String toString() {
  return 'RecentActivityItem(taskId: $taskId, taskTitle: $taskTitle, projectId: $projectId, projectName: $projectName, ts: $ts, actor: $actor, eventType: $eventType)';
}


}

/// @nodoc
abstract mixin class $RecentActivityItemCopyWith<$Res>  {
  factory $RecentActivityItemCopyWith(RecentActivityItem value, $Res Function(RecentActivityItem) _then) = _$RecentActivityItemCopyWithImpl;
@useResult
$Res call({
 String taskId, String taskTitle, String projectId, String projectName, DateTime ts,@ActorConverter() Actor actor, TaskEventType eventType
});




}
/// @nodoc
class _$RecentActivityItemCopyWithImpl<$Res>
    implements $RecentActivityItemCopyWith<$Res> {
  _$RecentActivityItemCopyWithImpl(this._self, this._then);

  final RecentActivityItem _self;
  final $Res Function(RecentActivityItem) _then;

/// Create a copy of RecentActivityItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taskId = null,Object? taskTitle = null,Object? projectId = null,Object? projectName = null,Object? ts = null,Object? actor = null,Object? eventType = null,}) {
  return _then(_self.copyWith(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,taskTitle: null == taskTitle ? _self.taskTitle : taskTitle // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,projectName: null == projectName ? _self.projectName : projectName // ignore: cast_nullable_to_non_nullable
as String,ts: null == ts ? _self.ts : ts // ignore: cast_nullable_to_non_nullable
as DateTime,actor: null == actor ? _self.actor : actor // ignore: cast_nullable_to_non_nullable
as Actor,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as TaskEventType,
  ));
}

}


/// Adds pattern-matching-related methods to [RecentActivityItem].
extension RecentActivityItemPatterns on RecentActivityItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecentActivityItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecentActivityItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecentActivityItem value)  $default,){
final _that = this;
switch (_that) {
case _RecentActivityItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecentActivityItem value)?  $default,){
final _that = this;
switch (_that) {
case _RecentActivityItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String taskId,  String taskTitle,  String projectId,  String projectName,  DateTime ts, @ActorConverter()  Actor actor,  TaskEventType eventType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecentActivityItem() when $default != null:
return $default(_that.taskId,_that.taskTitle,_that.projectId,_that.projectName,_that.ts,_that.actor,_that.eventType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String taskId,  String taskTitle,  String projectId,  String projectName,  DateTime ts, @ActorConverter()  Actor actor,  TaskEventType eventType)  $default,) {final _that = this;
switch (_that) {
case _RecentActivityItem():
return $default(_that.taskId,_that.taskTitle,_that.projectId,_that.projectName,_that.ts,_that.actor,_that.eventType);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String taskId,  String taskTitle,  String projectId,  String projectName,  DateTime ts, @ActorConverter()  Actor actor,  TaskEventType eventType)?  $default,) {final _that = this;
switch (_that) {
case _RecentActivityItem() when $default != null:
return $default(_that.taskId,_that.taskTitle,_that.projectId,_that.projectName,_that.ts,_that.actor,_that.eventType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecentActivityItem implements RecentActivityItem {
  const _RecentActivityItem({required this.taskId, required this.taskTitle, required this.projectId, required this.projectName, required this.ts, @ActorConverter() required this.actor, required this.eventType});
  factory _RecentActivityItem.fromJson(Map<String, dynamic> json) => _$RecentActivityItemFromJson(json);

@override final  String taskId;
@override final  String taskTitle;
@override final  String projectId;
@override final  String projectName;
@override final  DateTime ts;
@override@ActorConverter() final  Actor actor;
@override final  TaskEventType eventType;

/// Create a copy of RecentActivityItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecentActivityItemCopyWith<_RecentActivityItem> get copyWith => __$RecentActivityItemCopyWithImpl<_RecentActivityItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecentActivityItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecentActivityItem&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.taskTitle, taskTitle) || other.taskTitle == taskTitle)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.projectName, projectName) || other.projectName == projectName)&&(identical(other.ts, ts) || other.ts == ts)&&(identical(other.actor, actor) || other.actor == actor)&&(identical(other.eventType, eventType) || other.eventType == eventType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,taskTitle,projectId,projectName,ts,actor,eventType);

@override
String toString() {
  return 'RecentActivityItem(taskId: $taskId, taskTitle: $taskTitle, projectId: $projectId, projectName: $projectName, ts: $ts, actor: $actor, eventType: $eventType)';
}


}

/// @nodoc
abstract mixin class _$RecentActivityItemCopyWith<$Res> implements $RecentActivityItemCopyWith<$Res> {
  factory _$RecentActivityItemCopyWith(_RecentActivityItem value, $Res Function(_RecentActivityItem) _then) = __$RecentActivityItemCopyWithImpl;
@override @useResult
$Res call({
 String taskId, String taskTitle, String projectId, String projectName, DateTime ts,@ActorConverter() Actor actor, TaskEventType eventType
});




}
/// @nodoc
class __$RecentActivityItemCopyWithImpl<$Res>
    implements _$RecentActivityItemCopyWith<$Res> {
  __$RecentActivityItemCopyWithImpl(this._self, this._then);

  final _RecentActivityItem _self;
  final $Res Function(_RecentActivityItem) _then;

/// Create a copy of RecentActivityItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taskId = null,Object? taskTitle = null,Object? projectId = null,Object? projectName = null,Object? ts = null,Object? actor = null,Object? eventType = null,}) {
  return _then(_RecentActivityItem(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,taskTitle: null == taskTitle ? _self.taskTitle : taskTitle // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,projectName: null == projectName ? _self.projectName : projectName // ignore: cast_nullable_to_non_nullable
as String,ts: null == ts ? _self.ts : ts // ignore: cast_nullable_to_non_nullable
as DateTime,actor: null == actor ? _self.actor : actor // ignore: cast_nullable_to_non_nullable
as Actor,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as TaskEventType,
  ));
}


}


/// @nodoc
mixin _$DashboardOrgSummary {

 String get orgId; String get orgName; Map<TaskStatus, int> get taskCountsByStatus; List<RecentActivityItem> get recentActivity;
/// Create a copy of DashboardOrgSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardOrgSummaryCopyWith<DashboardOrgSummary> get copyWith => _$DashboardOrgSummaryCopyWithImpl<DashboardOrgSummary>(this as DashboardOrgSummary, _$identity);

  /// Serializes this DashboardOrgSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardOrgSummary&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.orgName, orgName) || other.orgName == orgName)&&const DeepCollectionEquality().equals(other.taskCountsByStatus, taskCountsByStatus)&&const DeepCollectionEquality().equals(other.recentActivity, recentActivity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,orgId,orgName,const DeepCollectionEquality().hash(taskCountsByStatus),const DeepCollectionEquality().hash(recentActivity));

@override
String toString() {
  return 'DashboardOrgSummary(orgId: $orgId, orgName: $orgName, taskCountsByStatus: $taskCountsByStatus, recentActivity: $recentActivity)';
}


}

/// @nodoc
abstract mixin class $DashboardOrgSummaryCopyWith<$Res>  {
  factory $DashboardOrgSummaryCopyWith(DashboardOrgSummary value, $Res Function(DashboardOrgSummary) _then) = _$DashboardOrgSummaryCopyWithImpl;
@useResult
$Res call({
 String orgId, String orgName, Map<TaskStatus, int> taskCountsByStatus, List<RecentActivityItem> recentActivity
});




}
/// @nodoc
class _$DashboardOrgSummaryCopyWithImpl<$Res>
    implements $DashboardOrgSummaryCopyWith<$Res> {
  _$DashboardOrgSummaryCopyWithImpl(this._self, this._then);

  final DashboardOrgSummary _self;
  final $Res Function(DashboardOrgSummary) _then;

/// Create a copy of DashboardOrgSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orgId = null,Object? orgName = null,Object? taskCountsByStatus = null,Object? recentActivity = null,}) {
  return _then(_self.copyWith(
orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,orgName: null == orgName ? _self.orgName : orgName // ignore: cast_nullable_to_non_nullable
as String,taskCountsByStatus: null == taskCountsByStatus ? _self.taskCountsByStatus : taskCountsByStatus // ignore: cast_nullable_to_non_nullable
as Map<TaskStatus, int>,recentActivity: null == recentActivity ? _self.recentActivity : recentActivity // ignore: cast_nullable_to_non_nullable
as List<RecentActivityItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardOrgSummary].
extension DashboardOrgSummaryPatterns on DashboardOrgSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardOrgSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardOrgSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardOrgSummary value)  $default,){
final _that = this;
switch (_that) {
case _DashboardOrgSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardOrgSummary value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardOrgSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String orgId,  String orgName,  Map<TaskStatus, int> taskCountsByStatus,  List<RecentActivityItem> recentActivity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardOrgSummary() when $default != null:
return $default(_that.orgId,_that.orgName,_that.taskCountsByStatus,_that.recentActivity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String orgId,  String orgName,  Map<TaskStatus, int> taskCountsByStatus,  List<RecentActivityItem> recentActivity)  $default,) {final _that = this;
switch (_that) {
case _DashboardOrgSummary():
return $default(_that.orgId,_that.orgName,_that.taskCountsByStatus,_that.recentActivity);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String orgId,  String orgName,  Map<TaskStatus, int> taskCountsByStatus,  List<RecentActivityItem> recentActivity)?  $default,) {final _that = this;
switch (_that) {
case _DashboardOrgSummary() when $default != null:
return $default(_that.orgId,_that.orgName,_that.taskCountsByStatus,_that.recentActivity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardOrgSummary implements DashboardOrgSummary {
  const _DashboardOrgSummary({required this.orgId, required this.orgName, required final  Map<TaskStatus, int> taskCountsByStatus, required final  List<RecentActivityItem> recentActivity}): _taskCountsByStatus = taskCountsByStatus,_recentActivity = recentActivity;
  factory _DashboardOrgSummary.fromJson(Map<String, dynamic> json) => _$DashboardOrgSummaryFromJson(json);

@override final  String orgId;
@override final  String orgName;
 final  Map<TaskStatus, int> _taskCountsByStatus;
@override Map<TaskStatus, int> get taskCountsByStatus {
  if (_taskCountsByStatus is EqualUnmodifiableMapView) return _taskCountsByStatus;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_taskCountsByStatus);
}

 final  List<RecentActivityItem> _recentActivity;
@override List<RecentActivityItem> get recentActivity {
  if (_recentActivity is EqualUnmodifiableListView) return _recentActivity;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentActivity);
}


/// Create a copy of DashboardOrgSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardOrgSummaryCopyWith<_DashboardOrgSummary> get copyWith => __$DashboardOrgSummaryCopyWithImpl<_DashboardOrgSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardOrgSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardOrgSummary&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.orgName, orgName) || other.orgName == orgName)&&const DeepCollectionEquality().equals(other._taskCountsByStatus, _taskCountsByStatus)&&const DeepCollectionEquality().equals(other._recentActivity, _recentActivity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,orgId,orgName,const DeepCollectionEquality().hash(_taskCountsByStatus),const DeepCollectionEquality().hash(_recentActivity));

@override
String toString() {
  return 'DashboardOrgSummary(orgId: $orgId, orgName: $orgName, taskCountsByStatus: $taskCountsByStatus, recentActivity: $recentActivity)';
}


}

/// @nodoc
abstract mixin class _$DashboardOrgSummaryCopyWith<$Res> implements $DashboardOrgSummaryCopyWith<$Res> {
  factory _$DashboardOrgSummaryCopyWith(_DashboardOrgSummary value, $Res Function(_DashboardOrgSummary) _then) = __$DashboardOrgSummaryCopyWithImpl;
@override @useResult
$Res call({
 String orgId, String orgName, Map<TaskStatus, int> taskCountsByStatus, List<RecentActivityItem> recentActivity
});




}
/// @nodoc
class __$DashboardOrgSummaryCopyWithImpl<$Res>
    implements _$DashboardOrgSummaryCopyWith<$Res> {
  __$DashboardOrgSummaryCopyWithImpl(this._self, this._then);

  final _DashboardOrgSummary _self;
  final $Res Function(_DashboardOrgSummary) _then;

/// Create a copy of DashboardOrgSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orgId = null,Object? orgName = null,Object? taskCountsByStatus = null,Object? recentActivity = null,}) {
  return _then(_DashboardOrgSummary(
orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,orgName: null == orgName ? _self.orgName : orgName // ignore: cast_nullable_to_non_nullable
as String,taskCountsByStatus: null == taskCountsByStatus ? _self._taskCountsByStatus : taskCountsByStatus // ignore: cast_nullable_to_non_nullable
as Map<TaskStatus, int>,recentActivity: null == recentActivity ? _self._recentActivity : recentActivity // ignore: cast_nullable_to_non_nullable
as List<RecentActivityItem>,
  ));
}


}


/// @nodoc
mixin _$DashboardSummary {

 List<DashboardOrgSummary> get orgs;
/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardSummaryCopyWith<DashboardSummary> get copyWith => _$DashboardSummaryCopyWithImpl<DashboardSummary>(this as DashboardSummary, _$identity);

  /// Serializes this DashboardSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardSummary&&const DeepCollectionEquality().equals(other.orgs, orgs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(orgs));

@override
String toString() {
  return 'DashboardSummary(orgs: $orgs)';
}


}

/// @nodoc
abstract mixin class $DashboardSummaryCopyWith<$Res>  {
  factory $DashboardSummaryCopyWith(DashboardSummary value, $Res Function(DashboardSummary) _then) = _$DashboardSummaryCopyWithImpl;
@useResult
$Res call({
 List<DashboardOrgSummary> orgs
});




}
/// @nodoc
class _$DashboardSummaryCopyWithImpl<$Res>
    implements $DashboardSummaryCopyWith<$Res> {
  _$DashboardSummaryCopyWithImpl(this._self, this._then);

  final DashboardSummary _self;
  final $Res Function(DashboardSummary) _then;

/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orgs = null,}) {
  return _then(_self.copyWith(
orgs: null == orgs ? _self.orgs : orgs // ignore: cast_nullable_to_non_nullable
as List<DashboardOrgSummary>,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardSummary].
extension DashboardSummaryPatterns on DashboardSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardSummary value)  $default,){
final _that = this;
switch (_that) {
case _DashboardSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardSummary value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<DashboardOrgSummary> orgs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
return $default(_that.orgs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<DashboardOrgSummary> orgs)  $default,) {final _that = this;
switch (_that) {
case _DashboardSummary():
return $default(_that.orgs);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<DashboardOrgSummary> orgs)?  $default,) {final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
return $default(_that.orgs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardSummary implements DashboardSummary {
  const _DashboardSummary({required final  List<DashboardOrgSummary> orgs}): _orgs = orgs;
  factory _DashboardSummary.fromJson(Map<String, dynamic> json) => _$DashboardSummaryFromJson(json);

 final  List<DashboardOrgSummary> _orgs;
@override List<DashboardOrgSummary> get orgs {
  if (_orgs is EqualUnmodifiableListView) return _orgs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_orgs);
}


/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardSummaryCopyWith<_DashboardSummary> get copyWith => __$DashboardSummaryCopyWithImpl<_DashboardSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardSummary&&const DeepCollectionEquality().equals(other._orgs, _orgs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_orgs));

@override
String toString() {
  return 'DashboardSummary(orgs: $orgs)';
}


}

/// @nodoc
abstract mixin class _$DashboardSummaryCopyWith<$Res> implements $DashboardSummaryCopyWith<$Res> {
  factory _$DashboardSummaryCopyWith(_DashboardSummary value, $Res Function(_DashboardSummary) _then) = __$DashboardSummaryCopyWithImpl;
@override @useResult
$Res call({
 List<DashboardOrgSummary> orgs
});




}
/// @nodoc
class __$DashboardSummaryCopyWithImpl<$Res>
    implements _$DashboardSummaryCopyWith<$Res> {
  __$DashboardSummaryCopyWithImpl(this._self, this._then);

  final _DashboardSummary _self;
  final $Res Function(_DashboardSummary) _then;

/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orgs = null,}) {
  return _then(_DashboardSummary(
orgs: null == orgs ? _self._orgs : orgs // ignore: cast_nullable_to_non_nullable
as List<DashboardOrgSummary>,
  ));
}


}

// dart format on
