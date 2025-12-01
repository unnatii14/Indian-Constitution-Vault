// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'section_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SectionDetailImpl _$$SectionDetailImplFromJson(Map<String, dynamic> json) =>
    _$SectionDetailImpl(
      actId: json['act_id'] as String,
      sectionNumber: json['section_number'] as String,
      heading: json['heading'] as String,
      content: json['content'] as String,
      contentHi: json['content_hi'] as String?,
    );

Map<String, dynamic> _$$SectionDetailImplToJson(_$SectionDetailImpl instance) =>
    <String, dynamic>{
      'act_id': instance.actId,
      'section_number': instance.sectionNumber,
      'heading': instance.heading,
      'content': instance.content,
      'content_hi': instance.contentHi,
    };
