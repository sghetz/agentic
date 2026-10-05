import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/link_relation.dart';

part 'project_link.freezed.dart';
part 'project_link.g.dart';

@freezed
sealed class ProjectLink with _$ProjectLink {
  const factory ProjectLink({
    required String id,
    required String fromProjectId,
    required String toProjectId,
    required LinkRelation relation,
  }) = _ProjectLink;

  factory ProjectLink.fromJson(Map<String, Object?> json) =>
      _$ProjectLinkFromJson(json);
}
