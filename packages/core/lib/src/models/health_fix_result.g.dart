// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_fix_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HealthFixResult _$HealthFixResultFromJson(Map<String, dynamic> json) =>
    _HealthFixResult(
      outcome: $enumDecode(_$HealthFixOutcomeEnumMap, json['outcome']),
      branchName: json['branchName'] as String?,
      summary: json['summary'] as String,
      verificationReport: json['verificationReport'] == null
          ? null
          : HealthReport.fromJson(
              json['verificationReport'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$HealthFixResultToJson(_HealthFixResult instance) =>
    <String, dynamic>{
      'outcome': _$HealthFixOutcomeEnumMap[instance.outcome]!,
      'branchName': instance.branchName,
      'summary': instance.summary,
      'verificationReport': instance.verificationReport?.toJson(),
    };

const _$HealthFixOutcomeEnumMap = {
  HealthFixOutcome.fixed: 'fixed',
  HealthFixOutcome.notTrivial: 'notTrivial',
  HealthFixOutcome.stillFailing: 'stillFailing',
};
