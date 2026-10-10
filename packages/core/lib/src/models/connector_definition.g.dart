// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connector_definition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConnectorDefinition _$ConnectorDefinitionFromJson(Map<String, dynamic> json) =>
    _ConnectorDefinition(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      authorizeUrl: json['authorizeUrl'] as String,
      tokenUrl: json['tokenUrl'] as String,
      scopes: (json['scopes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ConnectorDefinitionToJson(
  _ConnectorDefinition instance,
) => <String, dynamic>{
  'id': instance.id,
  'displayName': instance.displayName,
  'authorizeUrl': instance.authorizeUrl,
  'tokenUrl': instance.tokenUrl,
  'scopes': instance.scopes,
};
