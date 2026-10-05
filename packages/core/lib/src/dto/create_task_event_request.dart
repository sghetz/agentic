import 'package:freezed_annotation/freezed_annotation.dart';

import '../actor.dart';
import '../enums/task_event_type.dart';

part 'create_task_event_request.freezed.dart';
part 'create_task_event_request.g.dart';

/// `taskId`, event `id`, and `ts` are assigned server-side; the id/ts belong
/// to the append-only event log, not the caller.
@freezed
sealed class CreateTaskEventRequest with _$CreateTaskEventRequest {
  const factory CreateTaskEventRequest({
    @ActorConverter() required Actor actor,
    required TaskEventType eventType,
    @Default({}) Map<String, Object?> payload,
  }) = _CreateTaskEventRequest;

  factory CreateTaskEventRequest.fromJson(Map<String, Object?> json) =>
      _$CreateTaskEventRequestFromJson(json);
}
