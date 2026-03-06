import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables/stories_table.dart';
import 'tables/characters_table.dart';
import 'tables/locations_table.dart';
import 'tables/plot_events_table.dart';
import 'tables/chapters_table.dart';
import 'tables/notes_table.dart';
import 'tables/questions_table.dart';
import 'tables/relationships_table.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  StoriesTable,
  CharactersTable,
  LocationsTable,
  PlotEventsTable,
  ChaptersTable,
  NotesTable,
  QuestionsTable,
  RelationshipsTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.connection);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.addColumn(notesTable, notesTable.orderIndex);
            await m.addColumn(notesTable, notesTable.label);
          }
        },
      );

  static QueryExecutor _openConnection() => driftDatabase(name: 'storybook_db');
}
