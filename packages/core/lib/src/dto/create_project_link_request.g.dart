// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_project_link_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateProjectLinkRequest _$CreateProjectLinkRequestFromJson(
  Map<String, dynamic> json,
) => _CreateProjectLinkRequest(
  toProjectId: json['toProjectId'] as String,
  relation: $enumDecode(_$LinkRelationEnumMap, json['relation']),
);

Map<String, dynamic> _$CreateProjectLinkRequestToJson(
  _CreateProjectLinkRequest instance,
) => <String, dynamic>{
  'toProjectId': instance.toProjectId,
  'relation': _$LinkRelationEnumMap[instance.relation]!,
};

const _$LinkRelationEnumMap = {
  LinkRelation.dependsOn: 'dependsOn',
  LinkRelation.sharesCodeWith: 'sharesCodeWith',
  LinkRelation.related: 'related',
};
