import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/link_relation.dart';

part 'create_project_link_request.freezed.dart';
part 'create_project_link_request.g.dart';

/// `fromProjectId` is implied by the URL path; only the other side and the
/// relation are supplied.
@freezed
sealed class CreateProjectLinkRequest with _$CreateProjectLinkRequest {
  const factory CreateProjectLinkRequest({
    required String toProjectId,
    required LinkRelation relation,
  }) = _CreateProjectLinkRequest;

  factory CreateProjectLinkRequest.fromJson(Map<String, Object?> json) =>
      _$CreateProjectLinkRequestFromJson(json);
}
