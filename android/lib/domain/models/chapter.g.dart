// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Chapter _$ChapterFromJson(Map<String, dynamic> json) => _Chapter(
      id: json['id'] as String,
      storyId: json['storyId'] as String,
      title: json['title'] as String,
      content: json['content'] as String? ?? '',
      order: (json['order'] as num?)?.toInt() ?? 0,
      status: $enumDecodeNullable(_$ChapterStatusEnumMap, json['status']) ??
          ChapterStatus.planned,
    );

Map<String, dynamic> _$ChapterToJson(_Chapter instance) => <String, dynamic>{
      'id': instance.id,
      'storyId': instance.storyId,
      'title': instance.title,
      'content': instance.content,
      'order': instance.order,
      'status': _$ChapterStatusEnumMap[instance.status]!,
    };

const _$ChapterStatusEnumMap = {
  ChapterStatus.planned: 'planned',
  ChapterStatus.drafting: 'drafting',
  ChapterStatus.completed: 'completed',
};
