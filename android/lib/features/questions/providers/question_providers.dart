import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/active_story_provider.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/providers/undo_provider.dart';
import '../../../domain/models/unresolved_question.dart';

part 'question_providers.g.dart';

@Riverpod(keepAlive: true)
class QuestionList extends _$QuestionList {
  @override
  Future<List<UnresolvedQuestion>> build() async {
    final storyId = ref.watch(activeStoryProvider)?.id;
    if (storyId == null) return [];
    final repo = ref.read(questionRepositoryProvider);
    return repo.getAllForStory(storyId);
  }

  Future<void> add(String storyId, String text) async {
    final repo = ref.read(questionRepositoryProvider);
    await repo.create(UnresolvedQuestion(
      id: const Uuid().v4(),
      storyId: storyId,
      question: text,
      isResolved: false,
      createdAt: DateTime.now(),
    ));
    ref.invalidateSelf();
  }

  Future<void> resolve(UnresolvedQuestion q) async {
    final repo = ref.read(questionRepositoryProvider);
    await repo.update(q.copyWith(isResolved: true));
    ref.invalidateSelf();
  }

  Future<void> delete(String id) async {
    final repo = ref.read(questionRepositoryProvider);
    final backup = await repo.getById(id);
    await repo.delete(id);
    ref.invalidateSelf();
    if (backup != null) {
      ref.read(undoStackProvider.notifier).push(() async {
        await ref.read(questionRepositoryProvider).create(backup);
        ref.invalidateSelf();
      });
    }
  }
}
