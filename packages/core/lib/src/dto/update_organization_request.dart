import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_organization_request.freezed.dart';
part 'update_organization_request.g.dart';

/// All fields optional; omitted fields are left unchanged.
@freezed
sealed class UpdateOrganizationRequest with _$UpdateOrganizationRequest {
  const factory UpdateOrganizationRequest({String? name, String? slug}) =
      _UpdateOrganizationRequest;

  factory UpdateOrganizationRequest.fromJson(Map<String, Object?> json) =>
      _$UpdateOrganizationRequestFromJson(json);
}
