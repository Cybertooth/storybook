import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/providers/active_story_provider.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../domain/models/note.dart';

part 'note_providers.g.dart';

@riverpod
class NoteList extends _$NoteList {
  @override
  Future<List<Note>> build() async {
    final storyId = ref.watch(activeStoryProvider)?.id;
    if (storyId == null) return [];
    final repo = ref.read(noteRepositoryProvider);
    return repo.getAll(storyId);
  }

  Future<void> add(String storyId, String content) async {
    final repo = ref.read(noteRepositoryProvider);
    await repo.create(Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      storyId: storyId,
      content: content,
      createdAt: DateTime.now(),
    ));
    ref.invalidateSelf();
  }

  Future<void> update(Note note) async {
    final repo = ref.read(noteRepositoryProvider);
    await repo.update(note);
    ref.invalidateSelf();
  }

  Future<void> delete(String id) async {
    final repo = ref.read(noteRepositoryProvider);
    await repo.delete(id);
    ref.invalidateSelf();
  }
}
