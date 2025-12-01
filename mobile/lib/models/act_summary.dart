import 'package:freezed_annotation/freezed_annotation.dart';

part 'act_summary.freezed.dart';
part 'act_summary.g.dart';

@freezed
class ActSummary with _$ActSummary {
  const factory ActSummary({
    required String actId,
    required String title,
    required int sectionCount,
    required List<String> languages,
  }) = _ActSummary;

  factory ActSummary.fromJson(Map<String, dynamic> json) =>
      _$ActSummaryFromJson(json);
}
