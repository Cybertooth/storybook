import 'dart:convert';
import 'package:drift/drift.dart';
import '../../../domain/models/character.dart';
import '../../../domain/repositories/character_repository.dart';
import '../database.dart';

class LocalCharacterRepository implements CharacterRepository {
  final AppDatabase _db;
  const LocalCharacterRepository(this._db);

  Character _fromRow(CharactersTableData row) => Character(
        id: row.id, storyId: row.storyId, name: row.name,
        role: CharacterRole.values.firstWhere(
          (r) => r.name == row.role,
          orElse: () => CharacterRole.supporting,
        ),
        description: row.description,
        traits: List<String>.from(jsonDecode(row.traitsJson)),
        arcLie: row.arcLie, arcTruth: row.arcTruth, arcGhost: row.arcGhost,
        avatarUrl: row.avatarUrl,
      );

  @override
  Future<List<Character>> getAllForStory(String storyId) async =>
      (await (_db.select(_db.charactersTable)..where((t) => t.storyId.equals(storyId))).get())
          .map(_fromRow).toList();

  @override
  Future<Character?> getById(String id) async {
    final row = await (_db.select(_db.charactersTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _fromRow(row);
  }

  @override
  Future<Character> create(Character character) async {
    await _db.into(_db.charactersTable).insert(CharactersTableCompanion.insert(
      id: character.id, storyId: character.storyId, name: character.name,
      role: Value(character.role.name),
      description: Value(character.description),
      traitsJson: Value(jsonEncode(character.traits)),
      arcLie: Value(character.arcLie), arcTruth: Value(character.arcTruth),
      arcGhost: Value(character.arcGhost), avatarUrl: Value(character.avatarUrl),
    ));
    return character;
  }

  @override
  Future<Character> update(Character character) async {
    await (_db.update(_db.charactersTable)..where((t) => t.id.equals(character.id)))
        .write(CharactersTableCompanion(
      name: Value(character.name), role: Value(character.role.name),
      description: Value(character.description),
      traitsJson: Value(jsonEncode(character.traits)),
      arcLie: Value(character.arcLie), arcTruth: Value(character.arcTruth),
      arcGhost: Value(character.arcGhost), avatarUrl: Value(character.avatarUrl),
    ));
    return character;
  }

  @override
  Future<void> delete(String id) async =>
      (_db.delete(_db.charactersTable)..where((t) => t.id.equals(id))).go();
}
