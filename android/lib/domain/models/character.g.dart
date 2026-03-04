// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Character _$CharacterFromJson(Map<String, dynamic> json) => _Character(
      id: json['id'] as String,
      storyId: json['storyId'] as String,
      name: json['name'] as String,
      role: $enumDecodeNullable(_$CharacterRoleEnumMap, json['role']) ??
          CharacterRole.supporting,
      description: json['description'] as String? ?? '',
      traits: (json['traits'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      arcLie: json['arcLie'] as String?,
      arcTruth: json['arcTruth'] as String?,
      arcGhost: json['arcGhost'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
    );

Map<String, dynamic> _$CharacterToJson(_Character instance) =>
    <String, dynamic>{
      'id': instance.id,
      'storyId': instance.storyId,
      'name': instance.name,
      'role': _$CharacterRoleEnumMap[instance.role]!,
      'description': instance.description,
      'traits': instance.traits,
      'arcLie': instance.arcLie,
      'arcTruth': instance.arcTruth,
      'arcGhost': instance.arcGhost,
      'avatarUrl': instance.avatarUrl,
    };

const _$CharacterRoleEnumMap = {
  CharacterRole.protagonist: 'protagonist',
  CharacterRole.antagonist: 'antagonist',
  CharacterRole.supporting: 'supporting',
  CharacterRole.other: 'other',
};
