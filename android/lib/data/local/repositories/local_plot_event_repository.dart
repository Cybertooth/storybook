import 'dart:convert';
import 'package:drift/drift.dart';
import '../../../domain/models/plot_event.dart';
import '../../../domain/repositories/plot_event_repository.dart';
import '../database.dart';

class LocalPlotEventRepository implements PlotEventRepository {
  final AppDatabase _db;
  const LocalPlotEventRepository(this._db);

  PlotEvent _fromRow(PlotEventsTableData row) => PlotEvent(
        id: row.id, storyId: row.storyId, title: row.title,
        description: row.description, order: row.order,
        chapterId: row.chapterId,
        characterIds: List<String>.from(jsonDecode(row.characterIdsJson)),
        locationId: row.locationId,
        status: EventStatus.values.firstWhere(
          (s) => s.name == row.status,
          orElse: () => EventStatus.idea,
        ),
        plotThread: row.plotThread, emotionalValue: row.emotionalValue,
      );

  @override
  Future<List<PlotEvent>> getAllForStory(String storyId) async =>
      (await (_db.select(_db.plotEventsTable)..where((t) => t.storyId.equals(storyId))).get())
          .map(_fromRow).toList();

  @override
  Future<PlotEvent?> getById(String id) async {
    final row = await (_db.select(_db.plotEventsTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _fromRow(row);
  }

  @override
  Future<PlotEvent> create(PlotEvent event) async {
    await _db.into(_db.plotEventsTable).insert(PlotEventsTableCompanion.insert(
      id: event.id, storyId: event.storyId, title: event.title,
      description: Value(event.description), order: Value(event.order),
      chapterId: Value(event.chapterId),
      characterIdsJson: Value(jsonEncode(event.characterIds)),
      locationId: Value(event.locationId),
      status: Value(event.status.name),
      plotThread: Value(event.plotThread),
      emotionalValue: Value(event.emotionalValue),
    ));
    return (await getById(event.id))!;
  }

  @override
  Future<PlotEvent> update(PlotEvent event) async {
    await (_db.update(_db.plotEventsTable)..where((t) => t.id.equals(event.id)))
        .write(PlotEventsTableCompanion(
      title: Value(event.title), description: Value(event.description),
      order: Value(event.order), chapterId: Value(event.chapterId),
      characterIdsJson: Value(jsonEncode(event.characterIds)),
      locationId: Value(event.locationId), status: Value(event.status.name),
      plotThread: Value(event.plotThread), emotionalValue: Value(event.emotionalValue),
    ));
    return event;
  }

  @override
  Future<void> delete(String id) async =>
      (_db.delete(_db.plotEventsTable)..where((t) => t.id.equals(id))).go();
}
