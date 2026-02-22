import 'package:drift/drift.dart';
import '../../../domain/models/relationship.dart';
import '../../../domain/repositories/relationship_repository.dart';
import '../database.dart';

class LocalRelationshipRepository implements RelationshipRepository {
  final AppDatabase _db;
  const LocalRelationshipRepository(this._db);

  Relationship _fromRow(RelationshipsTableData row) => Relationship(
        id: row.id, storyId: row.storyId,
        sourceId: row.sourceId, targetId: row.targetId,
        type: row.type, description: row.description,
      );

  @override
  Future<List<Relationship>> getAllForStory(String storyId) async =>
      (await (_db.select(_db.relationshipsTable)..where((t) => t.storyId.equals(storyId))).get())
          .map(_fromRow).toList();

  @override
  Future<Relationship?> getById(String id) async {
    final row = await (_db.select(_db.relationshipsTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _fromRow(row);
  }

  @override
  Future<Relationship> create(Relationship relationship) async {
    await _db.into(_db.relationshipsTable).insert(RelationshipsTableCompanion.insert(
      id: relationship.id, storyId: relationship.storyId,
      sourceId: relationship.sourceId, targetId: relationship.targetId,
      type: relationship.type, description: Value(relationship.description),
    ));
    return (await getById(relationship.id))!;
  }

  @override
  Future<Relationship> update(Relationship relationship) async {
    await (_db.update(_db.relationshipsTable)..where((t) => t.id.equals(relationship.id)))
        .write(RelationshipsTableCompanion(
      sourceId: Value(relationship.sourceId), targetId: Value(relationship.targetId),
      type: Value(relationship.type), description: Value(relationship.description),
    ));
    return relationship;
  }

  @override
  Future<void> delete(String id) async =>
      (_db.delete(_db.relationshipsTable)..where((t) => t.id.equals(id))).go();
}
