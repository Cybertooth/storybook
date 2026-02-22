import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/models/story.dart';
import '../../../domain/repositories/story_repository.dart';
import '../database.dart';

class LocalStoryRepository implements StoryRepository {
  final AppDatabase _db;
  const LocalStoryRepository(this._db);

  Story _fromRow(StoriesTableData row) => Story(
        id: row.id, title: row.title, summary: row.summary,
        theme: row.theme, coreQuestion: row.coreQuestion,
        createdAt: row.createdAt, updatedAt: row.updatedAt,
      );

  @override
  Future<List<Story>> getAll() async =>
      (await _db.select(_db.storiesTable).get()).map(_fromRow).toList();

  @override
  Future<Story?> getById(String id) async {
    final row = await (_db.select(_db.storiesTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _fromRow(row);
  }

  @override
  Future<Story> create(String title) async {
    final now = DateTime.now();
    final id = const Uuid().v4();
    await _db.into(_db.storiesTable).insert(StoriesTableCompanion.insert(
      id: id, title: title, createdAt: now, updatedAt: now,
    ));
    return (await getById(id))!;
  }

  @override
  Future<Story> update(Story story) async {
    final updated = story.copyWith(updatedAt: DateTime.now());
    await (_db.update(_db.storiesTable)..where((t) => t.id.equals(story.id)))
        .write(StoriesTableCompanion(
      title: Value(updated.title), summary: Value(updated.summary),
      theme: Value(updated.theme), coreQuestion: Value(updated.coreQuestion),
      updatedAt: Value(updated.updatedAt),
    ));
    return updated;
  }

  @override
  Future<void> delete(String id) async =>
      (_db.delete(_db.storiesTable)..where((t) => t.id.equals(id))).go();
}
