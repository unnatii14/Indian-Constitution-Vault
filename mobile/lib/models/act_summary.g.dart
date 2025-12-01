// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'act_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActSummaryImpl _$$ActSummaryImplFromJson(Map<String, dynamic> json) =>
    _$ActSummaryImpl(
      actId: json['actId'] as String,
      title: json['title'] as String,
      sectionCount: (json['sectionCount'] as num).toInt(),
      languages: (json['languages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$ActSummaryImplToJson(_$ActSummaryImpl instance) =>
    <String, dynamic>{
      'actId': instance.actId,
      'title': instance.title,
      'sectionCount': instance.sectionCount,
      'languages': instance.languages,
    };
