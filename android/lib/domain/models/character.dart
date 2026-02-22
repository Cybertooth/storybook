import 'package:freezed_annotation/freezed_annotation.dart';

part 'character.freezed.dart';
part 'character.g.dart';

enum CharacterRole { protagonist, antagonist, supporting, other }

@freezed
class Character with _$Character {
  const factory Character({
    required String id,
    required String storyId,
    required String name,
    @Default(CharacterRole.supporting) CharacterRole role,
    @Default('') String description,
    @Default([]) List<String> traits,
    String? arcLie,
    String? arcTruth,
    String? arcGhost,
    String? avatarUrl,
  }) = _Character;

  factory Character.fromJson(Map<String, dynamic> json) => _$CharacterFromJson(json);
}
