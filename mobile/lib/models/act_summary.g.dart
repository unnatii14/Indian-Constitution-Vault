// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'act_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActSummaryImpl _$$ActSummaryImplFromJson(Map<String, dynamic> json) =>
    _$ActSummaryImpl(
      actId: json['act_id'] as String,
      title: json['title'] as String,
      sectionCount: (json['section_count'] as num).toInt(),
      languages: (json['languages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$ActSummaryImplToJson(_$ActSummaryImpl instance) =>
    <String, dynamic>{
      'act_id': instance.actId,
      'title': instance.title,
      'section_count': instance.sectionCount,
      'languages': instance.languages,
    };
