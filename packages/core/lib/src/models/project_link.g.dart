// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectLink _$ProjectLinkFromJson(Map<String, dynamic> json) => _ProjectLink(
  id: json['id'] as String,
  fromProjectId: json['fromProjectId'] as String,
  toProjectId: json['toProjectId'] as String,
  relation: $enumDecode(_$LinkRelationEnumMap, json['relation']),
);

Map<String, dynamic> _$ProjectLinkToJson(_ProjectLink instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fromProjectId': instance.fromProjectId,
      'toProjectId': instance.toProjectId,
      'relation': _$LinkRelationEnumMap[instance.relation]!,
    };

const _$LinkRelationEnumMap = {
  LinkRelation.dependsOn: 'dependsOn',
  LinkRelation.sharesCodeWith: 'sharesCodeWith',
  LinkRelation.related: 'related',
};
