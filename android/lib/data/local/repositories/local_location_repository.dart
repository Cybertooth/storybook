import 'package:drift/drift.dart';
import '../../../domain/models/location.dart';
import '../../../domain/repositories/location_repository.dart';
import '../database.dart';

class LocalLocationRepository implements LocationRepository {
  final AppDatabase _db;
  const LocalLocationRepository(this._db);

  Location _fromRow(LocationsTableData row) => Location(
        id: row.id, storyId: row.storyId, name: row.name,
        description: row.description,
        sensorySight: row.sensorySight, sensorySound: row.sensorySound,
        sensorySmell: row.sensorySmell, sensoryTouch: row.sensoryTouch,
        sensoryTaste: row.sensoryTaste,
      );

  @override
  Future<List<Location>> getAllForStory(String storyId) async =>
      (await (_db.select(_db.locationsTable)..where((t) => t.storyId.equals(storyId))).get())
          .map(_fromRow).toList();

  @override
  Future<Location?> getById(String id) async {
    final row = await (_db.select(_db.locationsTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _fromRow(row);
  }

  @override
  Future<Location> create(Location location) async {
    await _db.into(_db.locationsTable).insert(LocationsTableCompanion.insert(
      id: location.id, storyId: location.storyId, name: location.name,
      description: Value(location.description),
      sensorySight: Value(location.sensorySight),
      sensorySound: Value(location.sensorySound),
      sensorySmell: Value(location.sensorySmell),
      sensoryTouch: Value(location.sensoryTouch),
      sensoryTaste: Value(location.sensoryTaste),
    ));
    return location;
  }

  @override
  Future<Location> update(Location location) async {
    await (_db.update(_db.locationsTable)..where((t) => t.id.equals(location.id)))
        .write(LocationsTableCompanion(
      name: Value(location.name), description: Value(location.description),
      sensorySight: Value(location.sensorySight),
      sensorySound: Value(location.sensorySound),
      sensorySmell: Value(location.sensorySmell),
      sensoryTouch: Value(location.sensoryTouch),
      sensoryTaste: Value(location.sensoryTaste),
    ));
    return location;
  }

  @override
  Future<void> delete(String id) async =>
      (_db.delete(_db.locationsTable)..where((t) => t.id.equals(id))).go();
}
