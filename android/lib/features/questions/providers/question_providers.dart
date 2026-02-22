import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/providers/active_story_provider.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../domain/models/unresolved_question.dart';

part 'question_providers.g.dart';

@riverpod
class QuestionList extends _$QuestionList {
  @override
  Future<List<UnresolvedQuestion>> build() async {
    final storyId = ref.watch(activeStoryProvider)?.id;
    if (storyId == null) return [];
    final repo = ref.read(questionRepositoryProvider);
    return repo.getAll(storyId);
  }

  Future<void> add(String storyId, String text) async {
    final repo = ref.read(questionRepositoryProvider);
    await repo.create(UnresolvedQuestion(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      storyId: storyId,
      text: text,
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
    await repo.delete(id);
    ref.invalidateSelf();
  }
}
