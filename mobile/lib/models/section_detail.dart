import 'package:freezed_annotation/freezed_annotation.dart';

part 'section_detail.freezed.dart';
part 'section_detail.g.dart';

@freezed
class SectionDetail with _$SectionDetail {
  const factory SectionDetail({
    required String actId,
    required String sectionNumber,
    required String heading,
    required String textEn,
    String? textHi,
  }) = _SectionDetail;

  factory SectionDetail.fromJson(Map<String, dynamic> json) =>
      _$SectionDetailFromJson(json);
}
