import 'package:freezed_annotation/freezed_annotation.dart';

import '../actor.dart';
import '../enums/task_event_type.dart';
import '../enums/task_status.dart';

part 'dashboard_summary.freezed.dart';
part 'dashboard_summary.g.dart';

/// One entry in a dashboard's recent-activity feed.
@freezed
sealed class RecentActivityItem with _$RecentActivityItem {
  const factory RecentActivityItem({
    required String taskId,
    required String taskTitle,
    required String projectId,
    required String projectName,
    required DateTime ts,
    @ActorConverter() required Actor actor,
    required TaskEventType eventType,
  }) = _RecentActivityItem;

  factory RecentActivityItem.fromJson(Map<String, Object?> json) =>
      _$RecentActivityItemFromJson(json);
}

/// Dashboard data for a single organization. Computed by reading that org's
/// own `data.db` in isolation; never joined with another org's data.
@freezed
sealed class DashboardOrgSummary with _$DashboardOrgSummary {
  const factory DashboardOrgSummary({
    required String orgId,
    required String orgName,
    required Map<TaskStatus, int> taskCountsByStatus,
    required List<RecentActivityItem> recentActivity,

    /// Messages still waiting on a project assignment (routing confidence
    /// was below threshold, or routing failed outright) -- the morning
    /// briefing's "needs your attention" signal alongside [draftTaskSpecCount].
    @Default(0) int unroutedMessageCount,

    /// Total Task Spec artifacts drafted across every project in this org.
    @Default(0) int draftTaskSpecCount,
  }) = _DashboardOrgSummary;

  factory DashboardOrgSummary.fromJson(Map<String, Object?> json) =>
      _$DashboardOrgSummaryFromJson(json);
}

/// Response for `GET /dashboard`: each org's summary, assembled in memory
/// from separate per-org reads.
@freezed
sealed class DashboardSummary with _$DashboardSummary {
  const factory DashboardSummary({required List<DashboardOrgSummary> orgs}) =
      _DashboardSummary;

  factory DashboardSummary.fromJson(Map<String, Object?> json) =>
      _$DashboardSummaryFromJson(json);
}
