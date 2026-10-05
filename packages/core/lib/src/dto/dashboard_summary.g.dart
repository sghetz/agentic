// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecentActivityItem _$RecentActivityItemFromJson(Map<String, dynamic> json) =>
    _RecentActivityItem(
      taskId: json['taskId'] as String,
      taskTitle: json['taskTitle'] as String,
      projectId: json['projectId'] as String,
      projectName: json['projectName'] as String,
      ts: DateTime.parse(json['ts'] as String),
      actor: const ActorConverter().fromJson(json['actor'] as String),
      eventType: $enumDecode(_$TaskEventTypeEnumMap, json['eventType']),
    );

Map<String, dynamic> _$RecentActivityItemToJson(_RecentActivityItem instance) =>
    <String, dynamic>{
      'taskId': instance.taskId,
      'taskTitle': instance.taskTitle,
      'projectId': instance.projectId,
      'projectName': instance.projectName,
      'ts': instance.ts.toIso8601String(),
      'actor': const ActorConverter().toJson(instance.actor),
      'eventType': _$TaskEventTypeEnumMap[instance.eventType]!,
    };

const _$TaskEventTypeEnumMap = {
  TaskEventType.created: 'created',
  TaskEventType.statusChanged: 'statusChanged',
  TaskEventType.commented: 'commented',
  TaskEventType.reopened: 'reopened',
  TaskEventType.artifactAttached: 'artifactAttached',
  TaskEventType.edited: 'edited',
};

_DashboardOrgSummary _$DashboardOrgSummaryFromJson(
  Map<String, dynamic> json,
) => _DashboardOrgSummary(
  orgId: json['orgId'] as String,
  orgName: json['orgName'] as String,
  taskCountsByStatus: (json['taskCountsByStatus'] as Map<String, dynamic>).map(
    (k, e) => MapEntry($enumDecode(_$TaskStatusEnumMap, k), (e as num).toInt()),
  ),
  recentActivity: (json['recentActivity'] as List<dynamic>)
      .map((e) => RecentActivityItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DashboardOrgSummaryToJson(
  _DashboardOrgSummary instance,
) => <String, dynamic>{
  'orgId': instance.orgId,
  'orgName': instance.orgName,
  'taskCountsByStatus': instance.taskCountsByStatus.map(
    (k, e) => MapEntry(_$TaskStatusEnumMap[k]!, e),
  ),
  'recentActivity': instance.recentActivity.map((e) => e.toJson()).toList(),
};

const _$TaskStatusEnumMap = {
  TaskStatus.newTask: 'newTask',
  TaskStatus.specified: 'specified',
  TaskStatus.inDesign: 'inDesign',
  TaskStatus.inDevelopment: 'inDevelopment',
  TaskStatus.inReview: 'inReview',
  TaskStatus.awaitingApproval: 'awaitingApproval',
  TaskStatus.done: 'done',
  TaskStatus.blocked: 'blocked',
};

_DashboardSummary _$DashboardSummaryFromJson(Map<String, dynamic> json) =>
    _DashboardSummary(
      orgs: (json['orgs'] as List<dynamic>)
          .map((e) => DashboardOrgSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DashboardSummaryToJson(_DashboardSummary instance) =>
    <String, dynamic>{'orgs': instance.orgs.map((e) => e.toJson()).toList()};
