// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screen_spec.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScreenSpec _$ScreenSpecFromJson(Map<String, dynamic> json) => _ScreenSpec(
  name: json['name'] as String,
  purpose: json['purpose'] as String,
  states:
      (json['states'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$ScreenUiStateEnumMap, e))
          .toList() ??
      const [],
  navigatesTo:
      (json['navigatesTo'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$ScreenSpecToJson(_ScreenSpec instance) =>
    <String, dynamic>{
      'name': instance.name,
      'purpose': instance.purpose,
      'states': instance.states.map((e) => _$ScreenUiStateEnumMap[e]!).toList(),
      'navigatesTo': instance.navigatesTo,
    };

const _$ScreenUiStateEnumMap = {
  ScreenUiState.empty: 'empty',
  ScreenUiState.loading: 'loading',
  ScreenUiState.error: 'error',
  ScreenUiState.success: 'success',
};
