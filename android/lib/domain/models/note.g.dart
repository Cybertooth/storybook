// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Note _$NoteFromJson(Map<String, dynamic> json) => _Note(
      id: json['id'] as String,
      storyId: json['storyId'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$NoteToJson(_Note instance) => <String, dynamic>{
      'id': instance.id,
      'storyId': instance.storyId,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
    };
