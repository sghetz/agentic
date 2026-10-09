// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'developer_run_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeveloperRunResult _$DeveloperRunResultFromJson(Map<String, dynamic> json) =>
    _DeveloperRunResult(
      outcome: $enumDecode(_$DeveloperOutcomeEnumMap, json['outcome']),
      branchName: json['branchName'] as String?,
      summary: json['summary'] as String,
      verificationReport: json['verificationReport'] == null
          ? null
          : HealthReport.fromJson(
              json['verificationReport'] as Map<String, dynamic>,
            ),
      pullRequest: json['pullRequest'] == null
          ? null
          : PullRequestInfo.fromJson(
              json['pullRequest'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$DeveloperRunResultToJson(_DeveloperRunResult instance) =>
    <String, dynamic>{
      'outcome': _$DeveloperOutcomeEnumMap[instance.outcome]!,
      'branchName': instance.branchName,
      'summary': instance.summary,
      'verificationReport': instance.verificationReport?.toJson(),
      'pullRequest': instance.pullRequest?.toJson(),
    };

const _$DeveloperOutcomeEnumMap = {
  DeveloperOutcome.prOpened: 'prOpened',
  DeveloperOutcome.verificationFailed: 'verificationFailed',
  DeveloperOutcome.noChanges: 'noChanges',
  DeveloperOutcome.sessionFailed: 'sessionFailed',
};
