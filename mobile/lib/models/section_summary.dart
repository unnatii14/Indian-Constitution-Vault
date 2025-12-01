import 'package:freezed_annotation/freezed_annotation.dart';

part 'section_summary.freezed.dart';
part 'section_summary.g.dart';

@freezed
class SectionSummary with _$SectionSummary {
  const factory SectionSummary({
    required String sectionNumber,
    required String heading,
    String? preview,
  }) = _SectionSummary;

  factory SectionSummary.fromJson(Map<String, dynamic> json) =>
      _$SectionSummaryFromJson(json);
}
