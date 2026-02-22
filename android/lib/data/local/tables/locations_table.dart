import 'package:drift/drift.dart';
import 'stories_table.dart';

class LocationsTable extends Table {
  TextColumn get id => text()();
  TextColumn get storyId => text().references(StoriesTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get sensorySight => text().nullable()();
  TextColumn get sensorySound => text().nullable()();
  TextColumn get sensorySmell => text().nullable()();
  TextColumn get sensoryTouch => text().nullable()();
  TextColumn get sensoryTaste => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
