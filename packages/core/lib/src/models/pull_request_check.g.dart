// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pull_request_check.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PullRequestCheck _$PullRequestCheckFromJson(Map<String, dynamic> json) =>
    _PullRequestCheck(
      name: json['name'] as String,
      conclusion: $enumDecode(_$PrCheckConclusionEnumMap, json['conclusion']),
      detailsUrl: json['detailsUrl'] as String?,
    );

Map<String, dynamic> _$PullRequestCheckToJson(_PullRequestCheck instance) =>
    <String, dynamic>{
      'name': instance.name,
      'conclusion': _$PrCheckConclusionEnumMap[instance.conclusion]!,
      'detailsUrl': instance.detailsUrl,
    };

const _$PrCheckConclusionEnumMap = {
  PrCheckConclusion.pending: 'pending',
  PrCheckConclusion.success: 'success',
  PrCheckConclusion.failure: 'failure',
  PrCheckConclusion.neutral: 'neutral',
};
