import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/org_type.dart';

part 'create_organization_request.freezed.dart';
part 'create_organization_request.g.dart';

@freezed
sealed class CreateOrganizationRequest with _$CreateOrganizationRequest {
  const factory CreateOrganizationRequest({
    required String name,
    required String slug,
    required OrgType type,
  }) = _CreateOrganizationRequest;

  factory CreateOrganizationRequest.fromJson(Map<String, Object?> json) =>
      _$CreateOrganizationRequestFromJson(json);
}
