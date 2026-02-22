import 'package:drift/drift.dart';
import '../../../domain/models/unresolved_question.dart';
import '../../../domain/repositories/question_repository.dart';
import '../database.dart';

class LocalQuestionRepository implements QuestionRepository {
  final AppDatabase _db;
  const LocalQuestionRepository(this._db);

  UnresolvedQuestion _fromRow(QuestionsTableData row) => UnresolvedQuestion(
        id: row.id, storyId: row.storyId, question: row.question,
        details: row.details, isResolved: row.isResolved,
        answer: row.answer, createdAt: row.createdAt,
      );

  @override
  Future<List<UnresolvedQuestion>> getAllForStory(String storyId) async =>
      (await (_db.select(_db.questionsTable)..where((t) => t.storyId.equals(storyId))).get())
          .map(_fromRow).toList();

  @override
  Future<UnresolvedQuestion?> getById(String id) async {
    final row = await (_db.select(_db.questionsTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _fromRow(row);
  }

  @override
  Future<UnresolvedQuestion> create(UnresolvedQuestion question) async {
    await _db.into(_db.questionsTable).insert(QuestionsTableCompanion.insert(
      id: question.id, storyId: question.storyId, question: question.question,
      details: Value(question.details), isResolved: Value(question.isResolved),
      answer: Value(question.answer), createdAt: question.createdAt,
    ));
    return question;
  }

  @override
  Future<UnresolvedQuestion> update(UnresolvedQuestion question) async {
    await (_db.update(_db.questionsTable)..where((t) => t.id.equals(question.id)))
        .write(QuestionsTableCompanion(
      question: Value(question.question), details: Value(question.details),
      isResolved: Value(question.isResolved), answer: Value(question.answer),
    ));
    return question;
  }

  @override
  Future<void> delete(String id) async =>
      (_db.delete(_db.questionsTable)..where((t) => t.id.equals(id))).go();
}
