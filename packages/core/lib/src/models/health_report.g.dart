// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HealthCheckStep _$HealthCheckStepFromJson(Map<String, dynamic> json) =>
    _HealthCheckStep(
      name: json['name'] as String,
      status: $enumDecode(_$HealthCheckStepStatusEnumMap, json['status']),
      durationMs: (json['durationMs'] as num).toInt(),
      output: json['output'] as String,
    );

Map<String, dynamic> _$HealthCheckStepToJson(_HealthCheckStep instance) =>
    <String, dynamic>{
      'name': instance.name,
      'status': _$HealthCheckStepStatusEnumMap[instance.status]!,
      'durationMs': instance.durationMs,
      'output': instance.output,
    };

const _$HealthCheckStepStatusEnumMap = {
  HealthCheckStepStatus.passed: 'passed',
  HealthCheckStepStatus.failed: 'failed',
  HealthCheckStepStatus.skipped: 'skipped',
};

_FailureDiagnosis _$FailureDiagnosisFromJson(Map<String, dynamic> json) =>
    _FailureDiagnosis(
      category: $enumDecode(
        _$FailureDiagnosisCategoryEnumMap,
        json['category'],
      ),
      summary: json['summary'] as String,
      suggestedFix: json['suggestedFix'] as String,
    );

Map<String, dynamic> _$FailureDiagnosisToJson(_FailureDiagnosis instance) =>
    <String, dynamic>{
      'category': _$FailureDiagnosisCategoryEnumMap[instance.category]!,
      'summary': instance.summary,
      'suggestedFix': instance.suggestedFix,
    };

const _$FailureDiagnosisCategoryEnumMap = {
  FailureDiagnosisCategory.dependency: 'dependency',
  FailureDiagnosisCategory.sdkMismatch: 'sdkMismatch',
  FailureDiagnosisCategory.codeBreak: 'codeBreak',
  FailureDiagnosisCategory.flakyTest: 'flakyTest',
  FailureDiagnosisCategory.environment: 'environment',
};

_HealthReport _$HealthReportFromJson(Map<String, dynamic> json) =>
    _HealthReport(
      status: $enumDecode(_$HealthCheckStepStatusEnumMap, json['status']),
      steps: (json['steps'] as List<dynamic>)
          .map((e) => HealthCheckStep.fromJson(e as Map<String, dynamic>))
          .toList(),
      startedAt: DateTime.parse(json['startedAt'] as String),
      finishedAt: DateTime.parse(json['finishedAt'] as String),
      diagnosis: json['diagnosis'] == null
          ? null
          : FailureDiagnosis.fromJson(
              json['diagnosis'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$HealthReportToJson(_HealthReport instance) =>
    <String, dynamic>{
      'status': _$HealthCheckStepStatusEnumMap[instance.status]!,
      'steps': instance.steps.map((e) => e.toJson()).toList(),
      'startedAt': instance.startedAt.toIso8601String(),
      'finishedAt': instance.finishedAt.toIso8601String(),
      'diagnosis': instance.diagnosis?.toJson(),
    };
