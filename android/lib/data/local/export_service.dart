import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:drift/drift.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'database.dart';
import '../../core/constants.dart';
import '../../domain/models/story.dart';
import '../../domain/models/character.dart';
import '../../domain/models/location.dart';
import '../../domain/models/plot_event.dart';
import '../../domain/models/chapter.dart';
import '../../domain/models/note.dart';
import '../../domain/models/unresolved_question.dart';
import '../../domain/models/relationship.dart';

class ExportService {
  final AppDatabase _db;
  ExportService(this._db);

  /// Builds a ProjectBundle JSON matching the web app's export format.
  Map<String, dynamic> buildBundle({
    required Story story,
    required List<Character> characters,
    required List<Location> locations,
    required List<PlotEvent> events,
    required List<Chapter> chapters,
    required List<Note> notes,
    required List<UnresolvedQuestion> questions,
    required List<Relationship> relationships,
  }) {
    return {
      'version': AppConstants.projectBundleVersion,
      'appName': AppConstants.appBundleName,
      'savedAt': DateTime.now().millisecondsSinceEpoch,
      'story': story.toJson(),
      'characters': characters.map((c) => c.toJson()).toList(),
      'locations': locations.map((l) => l.toJson()).toList(),
      'events': events.map((e) => e.toJson()).toList(),
      'chapters': chapters.map((c) => c.toJson()).toList(),
      'notes': notes.map((n) => n.toJson()).toList(),
      'unresolvedQuestions': questions.map((q) => q.toJson()).toList(),
      'relationships': relationships.map((r) => r.toJson()).toList(),
    };
  }

  /// Writes bundle to a temp file and opens the system share sheet.
  Future<void> exportToFile(Map<String, dynamic> bundle) async {
    final json = const JsonEncoder.withIndent('  ').convert(bundle);
    final dir = await getTemporaryDirectory();
    final storyTitle = (bundle['story']['title'] as String)
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(' ', '_');
    final file = File('${dir.path}/${storyTitle}_backup.json');
    await file.writeAsString(json);

    // Note: Use Share.shareXFiles for file sharing.
    // The lint suggesting SharePlus.instance.share() is for text only.
    // ignore: deprecated_member_use
    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'application/json')],
      subject: 'Storybook backup: ${bundle['story']['title']}',
    );
  }

  /// Imports a full project bundle into the database.
  Future<void> importBundle(Map<String, dynamic> bundle) async {
    final story = Story.fromJson(bundle['story'] as Map<String, dynamic>);
    final chars = (bundle['characters'] as List)
        .map((e) => Character.fromJson(e as Map<String, dynamic>))
        .toList();
    final locs = (bundle['locations'] as List)
        .map((e) => Location.fromJson(e as Map<String, dynamic>))
        .toList();
    final events = (bundle['events'] as List)
        .map((e) => PlotEvent.fromJson(e as Map<String, dynamic>))
        .toList();
    final chapters = (bundle['chapters'] as List)
        .map((e) => Chapter.fromJson(e as Map<String, dynamic>))
        .toList();
    final notes = (bundle['notes'] as List)
        .map((e) => Note.fromJson(e as Map<String, dynamic>))
        .toList();
    final questions = (bundle['unresolvedQuestions'] as List)
        .map((e) => UnresolvedQuestion.fromJson(e as Map<String, dynamic>))
        .toList();
    final rels = (bundle['relationships'] as List)
        .map((e) => Relationship.fromJson(e as Map<String, dynamic>))
        .toList();

    await _db.transaction(() async {
      // Upsert Story
      await _db.into(_db.storiesTable).insertOnConflictUpdate(
            StoriesTableCompanion.insert(
              id: story.id,
              title: story.title,
              summary: Value(story.summary),
              theme: Value(story.theme),
              coreQuestion: Value(story.coreQuestion),
              createdAt: story.createdAt,
              updatedAt: story.updatedAt,
            ),
          );

      // Upsert Characters
      for (final c in chars) {
        await _db.into(_db.charactersTable).insertOnConflictUpdate(
              CharactersTableCompanion.insert(
                id: c.id,
                storyId: c.storyId,
                name: c.name,
                role: Value(c.role.name),
                description: Value(c.description),
                traitsJson: Value(jsonEncode(c.traits)),
                arcLie: Value(c.arcLie),
                arcTruth: Value(c.arcTruth),
                arcGhost: Value(c.arcGhost),
                avatarUrl: Value(c.avatarUrl),
              ),
            );
      }

      // Upsert Locations
      for (final l in locs) {
        await _db.into(_db.locationsTable).insertOnConflictUpdate(
              LocationsTableCompanion.insert(
                id: l.id,
                storyId: l.storyId,
                name: l.name,
                description: Value(l.description),
                sensorySight: Value(l.sensorySight),
                sensorySound: Value(l.sensorySound),
                sensorySmell: Value(l.sensorySmell),
                sensoryTouch: Value(l.sensoryTouch),
                sensoryTaste: Value(l.sensoryTaste),
              ),
            );
      }

      // Upsert Events
      for (final e in events) {
        await _db.into(_db.plotEventsTable).insertOnConflictUpdate(
              PlotEventsTableCompanion.insert(
                id: e.id,
                storyId: e.storyId,
                title: e.title,
                description: Value(e.description),
                order: Value(e.order),
                chapterId: Value(e.chapterId),
                characterIdsJson: Value(jsonEncode(e.characterIds)),
                locationId: Value(e.locationId),
                status: Value(e.status.name),
                plotThread: Value(e.plotThread),
                emotionalValue: Value(e.emotionalValue),
              ),
            );
      }

      // Upsert Chapters
      for (final c in chapters) {
        await _db.into(_db.chaptersTable).insertOnConflictUpdate(
              ChaptersTableCompanion.insert(
                id: c.id,
                storyId: c.storyId,
                title: c.title,
                content: Value(c.content),
                order: Value(c.order),
                status: Value(c.status.name),
              ),
            );
      }

      // Upsert Notes
      for (final n in notes) {
        await _db.into(_db.notesTable).insertOnConflictUpdate(
              NotesTableCompanion.insert(
                id: n.id,
                storyId: n.storyId,
                content: n.content,
                createdAt: n.createdAt,
              ),
            );
      }

      // Upsert Questions
      for (final q in questions) {
        await _db.into(_db.questionsTable).insertOnConflictUpdate(
              QuestionsTableCompanion.insert(
                id: q.id,
                storyId: q.storyId,
                question: q.question,
                details: Value(q.details),
                isResolved: Value(q.isResolved),
                answer: Value(q.answer),
                createdAt: q.createdAt,
              ),
            );
      }

      // Upsert Relationships
      for (final r in rels) {
        await _db.into(_db.relationshipsTable).insertOnConflictUpdate(
              RelationshipsTableCompanion.insert(
                id: r.id,
                storyId: r.storyId,
                sourceId: r.sourceId,
                targetId: r.targetId,
                type: r.type,
                description: Value(r.description),
              ),
            );
      }
    });
  }

  /// Opens a file picker and returns the parsed JSON map, or null if cancelled.
  Future<Map<String, dynamic>?> importFromFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      withData: true,
    );
    if (result == null || result.files.single.bytes == null) return null;
    final content = utf8.decode(result.files.single.bytes!);
    final json = jsonDecode(content) as Map<String, dynamic>;
    // Basic validation
    if (json['appName'] != AppConstants.appBundleName) {
      throw const FormatException('Not a valid Storybook backup file.');
    }
    return json;
  }
}
