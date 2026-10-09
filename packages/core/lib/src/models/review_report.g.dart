// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReviewReport _$ReviewReportFromJson(Map<String, dynamic> json) =>
    _ReviewReport(
      summary: json['summary'] as String,
      acceptanceCriteriaMet:
          (json['acceptanceCriteriaMet'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      acceptanceCriteriaUnmet:
          (json['acceptanceCriteriaUnmet'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      requirementIdsCovered:
          (json['requirementIdsCovered'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      requirementIdsMissing:
          (json['requirementIdsMissing'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      codeQualityIssues:
          (json['codeQualityIssues'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      missingTests:
          (json['missingTests'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ReviewReportToJson(_ReviewReport instance) =>
    <String, dynamic>{
      'summary': instance.summary,
      'acceptanceCriteriaMet': instance.acceptanceCriteriaMet,
      'acceptanceCriteriaUnmet': instance.acceptanceCriteriaUnmet,
      'requirementIdsCovered': instance.requirementIdsCovered,
      'requirementIdsMissing': instance.requirementIdsMissing,
      'codeQualityIssues': instance.codeQualityIssues,
      'missingTests': instance.missingTests,
    };
