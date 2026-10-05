import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/org_type.dart';

part 'organization.freezed.dart';
part 'organization.g.dart';

@freezed
sealed class Organization with _$Organization {
  const factory Organization({
    required String id,
    required String name,
    required String slug,
    required OrgType type,
    required DateTime createdAt,
    DateTime? archivedAt,
  }) = _Organization;

  factory Organization.fromJson(Map<String, Object?> json) =>
      _$OrganizationFromJson(json);
}
