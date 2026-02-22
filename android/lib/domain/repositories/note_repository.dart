import '../models/note.dart';

abstract class NoteRepository {
  Future<List<Note>> getAllForStory(String storyId);
  Future<Note?> getById(String id);
  Future<Note> create(Note note);
  Future<Note> update(Note note);
  Future<void> delete(String id);
}
