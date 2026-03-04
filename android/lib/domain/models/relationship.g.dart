// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relationship.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Relationship _$RelationshipFromJson(Map<String, dynamic> json) =>
    _Relationship(
      id: json['id'] as String,
      storyId: json['storyId'] as String,
      sourceId: json['sourceId'] as String,
      targetId: json['targetId'] as String,
      type: json['type'] as String,
      description: json['description'] as String? ?? '',
    );

Map<String, dynamic> _$RelationshipToJson(_Relationship instance) =>
    <String, dynamic>{
      'id': instance.id,
      'storyId': instance.storyId,
      'sourceId': instance.sourceId,
      'targetId': instance.targetId,
      'type': instance.type,
      'description': instance.description,
    };
