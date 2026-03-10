import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/active_story_provider.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/providers/undo_provider.dart';
import '../../../data/sync/sync_service.dart';
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
    final question = UnresolvedQuestion(
      id: const Uuid().v4(),
      storyId: storyId,
      question: text,
      isResolved: false,
      createdAt: DateTime.now(),
    );
    final repo = ref.read(questionRepositoryProvider);
    await repo.create(question);
    ref.invalidateSelf();
    ref.read(syncServiceProvider).pushQuestionCreate(question).ignore();
  }

  Future<void> resolve(UnresolvedQuestion q) async {
    final resolved = q.copyWith(isResolved: true);
    final repo = ref.read(questionRepositoryProvider);
    await repo.update(resolved);
    ref.invalidateSelf();
    ref.read(syncServiceProvider).pushQuestionUpdate(resolved).ignore();
  }

  Future<void> delete(String id) async {
    final repo = ref.read(questionRepositoryProvider);
    final backup = await repo.getById(id);
    await repo.delete(id);
    ref.invalidateSelf();
    ref.read(syncServiceProvider).pushQuestionDelete(id).ignore();
    if (backup != null) {
      ref.read(undoStackProvider.notifier).push(() async {
        await ref.read(questionRepositoryProvider).create(backup);
        ref.invalidateSelf();
        ref.read(syncServiceProvider).pushQuestionCreate(backup).ignore();
      });
    }
  }
}
