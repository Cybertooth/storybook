import '../models/chapter.dart';

abstract class ChapterRepository {
  Future<List<Chapter>> getAllForStory(String storyId);
  Future<Chapter?> getById(String id);
  Future<Chapter> create(Chapter chapter);
  Future<Chapter> update(Chapter chapter);
  Future<void> delete(String id);
}
