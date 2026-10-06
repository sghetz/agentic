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

_HealthReport _$HealthReportFromJson(Map<String, dynamic> json) =>
    _HealthReport(
      status: $enumDecode(_$HealthCheckStepStatusEnumMap, json['status']),
      steps: (json['steps'] as List<dynamic>)
          .map((e) => HealthCheckStep.fromJson(e as Map<String, dynamic>))
          .toList(),
      startedAt: DateTime.parse(json['startedAt'] as String),
      finishedAt: DateTime.parse(json['finishedAt'] as String),
    );

Map<String, dynamic> _$HealthReportToJson(_HealthReport instance) =>
    <String, dynamic>{
      'status': _$HealthCheckStepStatusEnumMap[instance.status]!,
      'steps': instance.steps.map((e) => e.toJson()).toList(),
      'startedAt': instance.startedAt.toIso8601String(),
      'finishedAt': instance.finishedAt.toIso8601String(),
    };
