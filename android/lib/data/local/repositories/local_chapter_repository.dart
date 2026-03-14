import 'package:drift/drift.dart';
import '../../../domain/models/chapter.dart';
import '../../../domain/repositories/chapter_repository.dart';
import '../database.dart';

class LocalChapterRepository implements ChapterRepository {
  final AppDatabase _db;
  const LocalChapterRepository(this._db);

  Chapter _fromRow(ChaptersTableData row) => Chapter(
        id: row.id, storyId: row.storyId, title: row.title,
        content: row.content, order: row.order,
        status: ChapterStatus.values.firstWhere(
          (s) => s.name == row.status,
          orElse: () => ChapterStatus.planned,
        ),
      );

  @override
  Future<List<Chapter>> getAllForStory(String storyId) async =>
      (await (_db.select(_db.chaptersTable)..where((t) => t.storyId.equals(storyId))).get())
          .map(_fromRow).toList();

  @override
  Future<Chapter?> getById(String id) async {
    final row = await (_db.select(_db.chaptersTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _fromRow(row);
  }

  @override
  Future<Chapter> create(Chapter chapter) async {
    await _db.into(_db.chaptersTable).insert(ChaptersTableCompanion.insert(
      id: chapter.id, storyId: chapter.storyId, title: chapter.title,
      content: Value(chapter.content ?? ''), order: Value(chapter.order),
      status: Value(chapter.status.name),
    ));
    return chapter;
  }

  @override
  Future<Chapter> update(Chapter chapter) async {
    await (_db.update(_db.chaptersTable)..where((t) => t.id.equals(chapter.id)))
        .write(ChaptersTableCompanion(
      title: Value(chapter.title), content: Value(chapter.content ?? ''),
      order: Value(chapter.order), status: Value(chapter.status.name),
    ));
    return chapter;
  }

  @override
  Future<void> delete(String id) async =>
      (_db.delete(_db.chaptersTable)..where((t) => t.id.equals(id))).go();
}
