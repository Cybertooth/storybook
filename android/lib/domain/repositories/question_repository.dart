import '../models/unresolved_question.dart';

abstract class QuestionRepository {
  Future<List<UnresolvedQuestion>> getAllForStory(String storyId);
  Future<UnresolvedQuestion?> getById(String id);
  Future<UnresolvedQuestion> create(UnresolvedQuestion question);
  Future<UnresolvedQuestion> update(UnresolvedQuestion question);
  Future<void> delete(String id);
}
