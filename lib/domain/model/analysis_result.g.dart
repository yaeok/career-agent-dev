// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analysis_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AnalysisResult _$AnalysisResultFromJson(Map<String, dynamic> json) =>
    _AnalysisResult(
      strengths:
          (json['strengths'] as List<dynamic>).map((e) => e as String).toList(),
      weaknesses:
          (json['weaknesses'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      selfPR: json['selfPR'] as String,
    );

Map<String, dynamic> _$AnalysisResultToJson(_AnalysisResult instance) =>
    <String, dynamic>{
      'strengths': instance.strengths,
      'weaknesses': instance.weaknesses,
      'selfPR': instance.selfPR,
    };
