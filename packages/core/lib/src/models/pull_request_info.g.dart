// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pull_request_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PullRequestInfo _$PullRequestInfoFromJson(Map<String, dynamic> json) =>
    _PullRequestInfo(
      number: (json['number'] as num).toInt(),
      url: json['url'] as String,
      branch: json['branch'] as String,
      baseBranch: json['baseBranch'] as String,
    );

Map<String, dynamic> _$PullRequestInfoToJson(_PullRequestInfo instance) =>
    <String, dynamic>{
      'number': instance.number,
      'url': instance.url,
      'branch': instance.branch,
      'baseBranch': instance.baseBranch,
    };
