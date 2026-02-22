import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/active_story_provider.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../domain/models/relationship.dart';

part 'relationship_providers.g.dart';

@riverpod
class RelationshipList extends _$RelationshipList {
  @override
  Future<List<Relationship>> build() async {
    final story = ref.watch(activeStoryProvider);
    if (story == null) return [];
    return ref.read(relationshipRepositoryProvider).getAllForStory(story.id);
  }

  Future<void> createRelationship({
    required String sourceId,
    required String targetId,
    required String type,
    String description = '',
  }) async {
    final story = ref.read(activeStoryProvider);
    if (story == null) return;
    final rel = Relationship(
      id: const Uuid().v4(),
      storyId: story.id,
      sourceId: sourceId,
      targetId: targetId,
      type: type,
      description: description,
    );
    await ref.read(relationshipRepositoryProvider).create(rel);
    ref.invalidateSelf();
  }

  Future<void> deleteRelationship(String id) async {
    await ref.read(relationshipRepositoryProvider).delete(id);
    ref.invalidateSelf();
  }
}
