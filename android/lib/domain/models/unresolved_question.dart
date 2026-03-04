import 'package:freezed_annotation/freezed_annotation.dart';

part 'unresolved_question.freezed.dart';
part 'unresolved_question.g.dart';

@freezed
abstract class UnresolvedQuestion with _$UnresolvedQuestion {
  const factory UnresolvedQuestion({
    required String id,
    required String storyId,
    required String question,
    @Default('') String details,
    @Default(false) bool isResolved,
    String? answer,
    required DateTime createdAt,
  }) = _UnresolvedQuestion;

  factory UnresolvedQuestion.fromJson(Map<String, dynamic> json) =>
      _$UnresolvedQuestionFromJson(json);
}
