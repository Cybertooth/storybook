import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/active_story_provider.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../domain/models/character.dart';

part 'character_providers.g.dart';

@riverpod
class CharacterList extends _$CharacterList {
  @override
  Future<List<Character>> build() async {
    final story = ref.watch(activeStoryProvider);
    if (story == null) return [];
    return ref.watch(characterRepositoryProvider).getAllForStory(story.id);
  }

  Future<void> createCharacter(String name) async {
    final story = ref.read(activeStoryProvider);
    if (story == null) return;
    final character = Character(id: const Uuid().v4(), storyId: story.id, name: name);
    await ref.read(characterRepositoryProvider).create(character);
    ref.invalidateSelf();
  }

  Future<void> updateCharacter(Character character) async {
    await ref.read(characterRepositoryProvider).update(character);
    ref.invalidateSelf();
  }

  Future<void> deleteCharacter(String id) async {
    await ref.read(characterRepositoryProvider).delete(id);
    ref.invalidateSelf();
  }
}
