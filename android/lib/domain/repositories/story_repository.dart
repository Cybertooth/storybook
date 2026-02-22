import '../models/story.dart';

abstract class StoryRepository {
  Future<List<Story>> getAll();
  Future<Story?> getById(String id);
  Future<Story> create(String title);
  Future<Story> update(Story story);
  Future<void> delete(String id);
}
