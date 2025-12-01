import 'package:freezed_annotation/freezed_annotation.dart';

part 'section_detail.freezed.dart';
part 'section_detail.g.dart';

@freezed
class SectionDetail with _$SectionDetail {
  const factory SectionDetail({
    @JsonKey(name: 'act_id') required String actId,
    @JsonKey(name: 'section_number') required String sectionNumber,
    required String heading,
    required String content,
    @JsonKey(name: 'content_hi') String? contentHi,
  }) = _SectionDetail;

  factory SectionDetail.fromJson(Map<String, dynamic> json) =>
      _$SectionDetailFromJson(json);
}
