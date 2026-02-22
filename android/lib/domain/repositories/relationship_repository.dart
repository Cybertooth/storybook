import '../models/relationship.dart';

abstract class RelationshipRepository {
  Future<List<Relationship>> getAllForStory(String storyId);
  Future<Relationship?> getById(String id);
  Future<Relationship> create(Relationship relationship);
  Future<Relationship> update(Relationship relationship);
  Future<void> delete(String id);
}
