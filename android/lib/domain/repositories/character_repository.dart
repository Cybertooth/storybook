import '../models/character.dart';

abstract class CharacterRepository {
  Future<List<Character>> getAllForStory(String storyId);
  Future<Character?> getById(String id);
  Future<Character> create(Character character);
  Future<Character> update(Character character);
  Future<void> delete(String id);
}
