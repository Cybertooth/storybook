import 'package:drift/drift.dart';
import '../../../domain/models/note.dart';
import '../../../domain/repositories/note_repository.dart';
import '../database.dart';

class LocalNoteRepository implements NoteRepository {
  final AppDatabase _db;
  const LocalNoteRepository(this._db);

  Note _fromRow(NotesTableData row) => Note(
        id: row.id, storyId: row.storyId,
        content: row.content, createdAt: row.createdAt,
      );

  @override
  Future<List<Note>> getAllForStory(String storyId) async =>
      (await (_db.select(_db.notesTable)..where((t) => t.storyId.equals(storyId))).get())
          .map(_fromRow).toList();

  @override
  Future<Note?> getById(String id) async {
    final row = await (_db.select(_db.notesTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _fromRow(row);
  }

  @override
  Future<Note> create(Note note) async {
    await _db.into(_db.notesTable).insert(NotesTableCompanion.insert(
      id: note.id, storyId: note.storyId, content: note.content,
      createdAt: note.createdAt,
    ));
    return (await getById(note.id))!;
  }

  @override
  Future<Note> update(Note note) async {
    await (_db.update(_db.notesTable)..where((t) => t.id.equals(note.id)))
        .write(NotesTableCompanion(content: Value(note.content)));
    return note;
  }

  @override
  Future<void> delete(String id) async =>
      (_db.delete(_db.notesTable)..where((t) => t.id.equals(id))).go();
}
