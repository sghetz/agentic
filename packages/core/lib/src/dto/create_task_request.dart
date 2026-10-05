import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_task_request.freezed.dart';
part 'create_task_request.g.dart';

/// `projectId` is implied by the URL path.
@freezed
sealed class CreateTaskRequest with _$CreateTaskRequest {
  const factory CreateTaskRequest({required String title}) = _CreateTaskRequest;

  factory CreateTaskRequest.fromJson(Map<String, Object?> json) =>
      _$CreateTaskRequestFromJson(json);
}
