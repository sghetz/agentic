import 'package:freezed_annotation/freezed_annotation.dart';

import '../actor.dart';
import '../enums/task_event_type.dart';

part 'task_event.freezed.dart';
part 'task_event.g.dart';

@freezed
sealed class TaskEvent with _$TaskEvent {
  const factory TaskEvent({
    required String id,
    required String taskId,
    required DateTime ts,
    @ActorConverter() required Actor actor,
    required TaskEventType eventType,
    required Map<String, Object?> payload,
  }) = _TaskEvent;

  factory TaskEvent.fromJson(Map<String, Object?> json) =>
      _$TaskEventFromJson(json);
}
