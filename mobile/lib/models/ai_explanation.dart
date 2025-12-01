import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_explanation.freezed.dart';
part 'ai_explanation.g.dart';

@freezed
class AiExplanation with _$AiExplanation {
  const factory AiExplanation({
    @JsonKey(name: 'simple_explanation') required String simpleExplanation,
    String? examples,
  }) = _AiExplanation;

  factory AiExplanation.fromJson(Map<String, dynamic> json) =>
      _$AiExplanationFromJson(json);
}
