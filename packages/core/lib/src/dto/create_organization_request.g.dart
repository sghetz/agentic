// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_organization_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateOrganizationRequest _$CreateOrganizationRequestFromJson(
  Map<String, dynamic> json,
) => _CreateOrganizationRequest(
  name: json['name'] as String,
  slug: json['slug'] as String,
  type: $enumDecode(_$OrgTypeEnumMap, json['type']),
);

Map<String, dynamic> _$CreateOrganizationRequestToJson(
  _CreateOrganizationRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'slug': instance.slug,
  'type': _$OrgTypeEnumMap[instance.type]!,
};

const _$OrgTypeEnumMap = {
  OrgType.employer: 'employer',
  OrgType.personal: 'personal',
  OrgType.client: 'client',
};
