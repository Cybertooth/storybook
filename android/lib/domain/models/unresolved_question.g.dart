// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unresolved_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UnresolvedQuestionImpl _$$UnresolvedQuestionImplFromJson(
        Map<String, dynamic> json) =>
    _$UnresolvedQuestionImpl(
      id: json['id'] as String,
      storyId: json['storyId'] as String,
      question: json['question'] as String,
      details: json['details'] as String? ?? '',
      isResolved: json['isResolved'] as bool? ?? false,
      answer: json['answer'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$UnresolvedQuestionImplToJson(
        _$UnresolvedQuestionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'storyId': instance.storyId,
      'question': instance.question,
      'details': instance.details,
      'isResolved': instance.isResolved,
      'answer': instance.answer,
      'createdAt': instance.createdAt.toIso8601String(),
    };
