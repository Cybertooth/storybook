import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/story.dart';
import '../../domain/models/character.dart';
import '../../domain/models/location.dart';
import '../../domain/models/plot_event.dart';
import '../../domain/models/chapter.dart';
import '../../domain/models/note.dart';
import '../../domain/models/relationship.dart';
import '../../domain/models/unresolved_question.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/database_provider.dart';
import '../local/database.dart';
import '../remote/api_client.dart';

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(
    ref.watch(apiClientProvider),
    ref.watch(databaseProvider),
    ref,
  );
});

class SyncService {
  final ApiClient _api;
  final AppDatabase _db;
  final Ref _ref;

  SyncService(this._api, this._db, this._ref);

  Future<bool> _isOnline() async {
    try {
      final auth = await _ref.read(authProvider.future);
      return auth.isAuthenticated;
    } catch (_) {
      return false;
    }
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }

  /// Maps the backend's 'final' status string to the local EventStatus.finalEvent enum name.
  static String _mapRemoteEventStatus(String? s) {
    if (s == 'final') return EventStatus.finalEvent.name;
    return s ?? EventStatus.idea.name;
  }

  /// Maps the local EventStatus enum to the backend's expected string value.
  static String _mapLocalEventStatus(EventStatus status) {
    if (status == EventStatus.finalEvent) return 'final';
    return status.name;
  }

  // ── PULL: Remote → Local (server wins, uses upsert) ──────────────────────

  /// Pulls all stories from the backend and merges them into the local DB.
  Future<void> pullAllStories() async {
    if (!await _isOnline()) return;
    try {
      final resp = await _api.getStories();
      if (resp == null || resp['success'] != true) return;
      final list = resp['data'] as List<dynamic>? ?? [];
      for (final s in list) {
        await _upsertStory(s as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('SyncService.pullAllStories failed: $e');
    }
  }

  /// Pulls all child entities for a given story. Call this when a story is opened.
  Future<void> pullStoryData(String storyId) async {
    if (!await _isOnline()) return;
    // Run independent entities in parallel, chapters separately (needs draft fetch)
    await Future.wait([
      pullCharacters(storyId),
      pullLocations(storyId),
      pullEvents(storyId),
      pullNotes(storyId),
      pullRelationships(storyId),
      pullQuestions(storyId),
    ]);
    await pullChapters(storyId);
  }

  Future<void> pullCharacters(String storyId) async {
    if (!await _isOnline()) return;
    try {
      final resp = await _api.getCharacters(storyId);
      if (resp == null || resp['success'] != true) return;
      final list = resp['data'] as List<dynamic>? ?? [];
      for (final item in list) {
        final m = item as Map<String, dynamic>;
        final traits = m['traits'] as List<dynamic>? ?? [];
        await _db.into(_db.charactersTable).insertOnConflictUpdate(
          CharactersTableCompanion(
            id: Value(m['id'] as String),
            storyId: Value(storyId),
            name: Value(m['name'] as String? ?? ''),
            role: Value(m['role'] as String? ?? 'supporting'),
            description: Value(m['description'] as String? ?? ''),
            traitsJson: Value(jsonEncode(traits)),
            arcLie: Value(m['arcLie'] as String?),
            arcTruth: Value(m['arcTruth'] as String?),
            arcGhost: Value(m['arcGhost'] as String?),
            avatarUrl: Value(m['avatarUrl'] as String?),
          ),
        );
      }
    } catch (e) {
      debugPrint('SyncService.pullCharacters failed: $e');
    }
  }

  Future<void> pullLocations(String storyId) async {
    if (!await _isOnline()) return;
    try {
      final resp = await _api.getLocations(storyId);
      if (resp == null || resp['success'] != true) return;
      final list = resp['data'] as List<dynamic>? ?? [];
      for (final item in list) {
        final m = item as Map<String, dynamic>;
        await _db.into(_db.locationsTable).insertOnConflictUpdate(
          LocationsTableCompanion(
            id: Value(m['id'] as String),
            storyId: Value(storyId),
            name: Value(m['name'] as String? ?? ''),
            description: Value(m['description'] as String? ?? ''),
            sensorySight: Value(m['sensorySight'] as String?),
            sensorySound: Value(m['sensorySound'] as String?),
            sensorySmell: Value(m['sensorySmell'] as String?),
            sensoryTouch: Value(m['sensoryTouch'] as String?),
            sensoryTaste: Value(m['sensoryTaste'] as String?),
          ),
        );
      }
    } catch (e) {
      debugPrint('SyncService.pullLocations failed: $e');
    }
  }

  Future<void> pullEvents(String storyId) async {
    if (!await _isOnline()) return;
    try {
      final resp = await _api.getEvents(storyId);
      if (resp == null || resp['success'] != true) return;
      final list = resp['data'] as List<dynamic>? ?? [];
      for (final item in list) {
        final m = item as Map<String, dynamic>;
        final charIds = m['characterIds'] as List<dynamic>? ?? [];
        await _db.into(_db.plotEventsTable).insertOnConflictUpdate(
          PlotEventsTableCompanion(
            id: Value(m['id'] as String),
            storyId: Value(storyId),
            title: Value(m['title'] as String? ?? ''),
            description: Value(m['description'] as String? ?? ''),
            order: Value((m['order'] as num?)?.toInt() ?? 0),
            chapterId: Value(m['chapterId'] as String?),
            characterIdsJson: Value(jsonEncode(charIds)),
            locationId: Value(m['locationId'] as String?),
            status: Value(_mapRemoteEventStatus(m['status'] as String?)),
            plotThread: Value(m['plotThread'] as String? ?? 'Main Plot'),
            emotionalValue:
                Value((m['emotionalValue'] as num?)?.toInt() ?? 0),
          ),
        );
      }
    } catch (e) {
      debugPrint('SyncService.pullEvents failed: $e');
    }
  }

  Future<void> pullChapters(String storyId) async {
    if (!await _isOnline()) return;
    try {
      final resp = await _api.getChapters(storyId);
      if (resp == null || resp['success'] != true) return;
      final list = resp['data'] as List<dynamic>? ?? [];
      for (final item in list) {
        final m = item as Map<String, dynamic>;
        final chapterId = m['id'] as String;

        // GET /chapters/:id/draft fetches the full content separately.
        // Try it, fall back to whatever content is in the list response.
        String content = m['content'] as String? ?? '';
        if (content.isEmpty) {
          try {
            final draftResp = await _api.getChapterDraft(chapterId);
            if (draftResp != null && draftResp['success'] == true) {
              final draftData = draftResp['data'];
              if (draftData is Map) {
                content = draftData['content'] as String? ?? '';
              }
            }
          } catch (_) {}
        }

        await _db.into(_db.chaptersTable).insertOnConflictUpdate(
          ChaptersTableCompanion(
            id: Value(chapterId),
            storyId: Value(storyId),
            title: Value(m['title'] as String? ?? ''),
            content: Value(content),
            order: Value((m['order'] as num?)?.toInt() ?? 0),
            status: Value(m['status'] as String? ?? 'planned'),
          ),
        );
      }
    } catch (e) {
      debugPrint('SyncService.pullChapters failed: $e');
    }
  }

  Future<void> pullNotes(String storyId) async {
    if (!await _isOnline()) return;
    try {
      final resp = await _api.getNotes(storyId);
      if (resp == null || resp['success'] != true) return;
      final list = resp['data'] as List<dynamic>? ?? [];
      for (int i = 0; i < list.length; i++) {
        final m = list[i] as Map<String, dynamic>;
        await _db.into(_db.notesTable).insertOnConflictUpdate(
          NotesTableCompanion(
            id: Value(m['id'] as String),
            storyId: Value(storyId),
            content: Value(m['content'] as String? ?? ''),
            createdAt: Value(_parseDate(m['createdAt'])),
            orderIndex: Value(i),
            label: const Value(null),
          ),
        );
      }
    } catch (e) {
      debugPrint('SyncService.pullNotes failed: $e');
    }
  }

  Future<void> pullRelationships(String storyId) async {
    if (!await _isOnline()) return;
    try {
      final resp = await _api.getRelationships(storyId);
      if (resp == null || resp['success'] != true) return;
      final list = resp['data'] as List<dynamic>? ?? [];
      for (final item in list) {
        final m = item as Map<String, dynamic>;
        await _db.into(_db.relationshipsTable).insertOnConflictUpdate(
          RelationshipsTableCompanion(
            id: Value(m['id'] as String),
            storyId: Value(storyId),
            sourceId: Value(m['sourceId'] as String? ?? ''),
            targetId: Value(m['targetId'] as String? ?? ''),
            type: Value(m['type'] as String? ?? ''),
            description: Value(m['description'] as String? ?? ''),
          ),
        );
      }
    } catch (e) {
      debugPrint('SyncService.pullRelationships failed: $e');
    }
  }

  Future<void> pullQuestions(String storyId) async {
    if (!await _isOnline()) return;
    try {
      final resp = await _api.getQuestions(storyId);
      if (resp == null || resp['success'] != true) return;
      final list = resp['data'] as List<dynamic>? ?? [];
      for (final item in list) {
        final m = item as Map<String, dynamic>;
        await _db.into(_db.questionsTable).insertOnConflictUpdate(
          QuestionsTableCompanion(
            id: Value(m['id'] as String),
            storyId: Value(storyId),
            question: Value(m['question'] as String? ?? ''),
            details: Value(m['details'] as String? ?? ''),
            isResolved: Value(m['isResolved'] as bool? ?? false),
            answer: Value(m['answer'] as String?),
            createdAt: Value(_parseDate(m['createdAt'])),
          ),
        );
      }
    } catch (e) {
      debugPrint('SyncService.pullQuestions failed: $e');
    }
  }

  Future<void> _upsertStory(Map<String, dynamic> m) async {
    await _db.into(_db.storiesTable).insertOnConflictUpdate(
      StoriesTableCompanion(
        id: Value(m['id'] as String),
        title: Value(m['title'] as String? ?? ''),
        summary: Value(m['summary'] as String? ?? ''),
        theme: Value(m['theme'] as String? ?? ''),
        coreQuestion: Value(m['coreQuestion'] as String? ?? ''),
        createdAt: Value(_parseDate(m['createdAt'])),
        updatedAt: Value(_parseDate(m['updatedAt'])),
      ),
    );
  }

  // ── PUSH: Local → Remote (fire-and-forget) ────────────────────────────────

  // Stories

  Future<void> pushStoryCreate(Story story) async {
    if (!await _isOnline()) return;
    try {
      final resp = await _api.createStory({
        'id': story.id,
        'title': story.title,
        'summary': story.summary,
        'theme': story.theme,
        'coreQuestion': story.coreQuestion,
      });
      if (resp != null && resp['success'] != true) {
        // Entity may already exist on server; fall back to update.
        await pushStoryUpdate(story);
      }
    } catch (e) {
      debugPrint('SyncService.pushStoryCreate failed: $e');
    }
  }

  Future<void> pushStoryUpdate(Story story) async {
    if (!await _isOnline()) return;
    try {
      await _api.updateStory(story.id, {
        'title': story.title,
        'summary': story.summary,
        'theme': story.theme,
        'coreQuestion': story.coreQuestion,
        'updatedAt': story.updatedAt.toIso8601String(),
      });
    } catch (e) {
      debugPrint('SyncService.pushStoryUpdate failed: $e');
    }
  }

  Future<void> pushStoryDelete(String id) async {
    if (!await _isOnline()) return;
    try {
      await _api.deleteStory(id);
    } catch (e) {
      debugPrint('SyncService.pushStoryDelete failed: $e');
    }
  }

  // Characters

  Future<void> pushCharacterCreate(Character c) async {
    if (!await _isOnline()) return;
    try {
      final resp =
          await _api.createCharacter(c.storyId, _characterToJson(c));
      if (resp != null && resp['success'] != true) {
        await pushCharacterUpdate(c);
      }
    } catch (e) {
      debugPrint('SyncService.pushCharacterCreate failed: $e');
    }
  }

  Future<void> pushCharacterUpdate(Character c) async {
    if (!await _isOnline()) return;
    try {
      await _api.updateCharacter(c.id, _characterToJson(c));
    } catch (e) {
      debugPrint('SyncService.pushCharacterUpdate failed: $e');
    }
  }

  Future<void> pushCharacterDelete(String id) async {
    if (!await _isOnline()) return;
    try {
      await _api.deleteCharacter(id);
    } catch (e) {
      debugPrint('SyncService.pushCharacterDelete failed: $e');
    }
  }

  Map<String, dynamic> _characterToJson(Character c) => {
        'id': c.id,
        'name': c.name,
        'role': c.role.name,
        'description': c.description,
        'traits': c.traits,
        'arcLie': c.arcLie,
        'arcTruth': c.arcTruth,
        'arcGhost': c.arcGhost,
        'avatarUrl': c.avatarUrl,
      };

  // Locations

  Future<void> pushLocationCreate(Location l) async {
    if (!await _isOnline()) return;
    try {
      final resp =
          await _api.createLocation(l.storyId, _locationToJson(l));
      if (resp != null && resp['success'] != true) {
        await pushLocationUpdate(l);
      }
    } catch (e) {
      debugPrint('SyncService.pushLocationCreate failed: $e');
    }
  }

  Future<void> pushLocationUpdate(Location l) async {
    if (!await _isOnline()) return;
    try {
      await _api.updateLocation(l.id, _locationToJson(l));
    } catch (e) {
      debugPrint('SyncService.pushLocationUpdate failed: $e');
    }
  }

  Future<void> pushLocationDelete(String id) async {
    if (!await _isOnline()) return;
    try {
      await _api.deleteLocation(id);
    } catch (e) {
      debugPrint('SyncService.pushLocationDelete failed: $e');
    }
  }

  Map<String, dynamic> _locationToJson(Location l) => {
        'id': l.id,
        'name': l.name,
        'description': l.description,
        'sensorySight': l.sensorySight,
        'sensorySound': l.sensorySound,
        'sensorySmell': l.sensorySmell,
        'sensoryTouch': l.sensoryTouch,
        'sensoryTaste': l.sensoryTaste,
      };

  // Plot Events

  Future<void> pushEventCreate(PlotEvent event) async {
    if (!await _isOnline()) return;
    try {
      final resp =
          await _api.createEvent(event.storyId, _eventToJson(event));
      if (resp != null && resp['success'] != true) {
        await pushEventUpdate(event);
      }
    } catch (e) {
      debugPrint('SyncService.pushEventCreate failed: $e');
    }
  }

  Future<void> pushEventUpdate(PlotEvent event) async {
    if (!await _isOnline()) return;
    try {
      await _api.updateEvent(event.id, _eventToJson(event));
    } catch (e) {
      debugPrint('SyncService.pushEventUpdate failed: $e');
    }
  }

  Future<void> pushEventDelete(String id) async {
    if (!await _isOnline()) return;
    try {
      await _api.deleteEvent(id);
    } catch (e) {
      debugPrint('SyncService.pushEventDelete failed: $e');
    }
  }

  Map<String, dynamic> _eventToJson(PlotEvent e) => {
        'id': e.id,
        'title': e.title,
        'description': e.description,
        'order': e.order,
        'chapterId': e.chapterId,
        'characterIds': e.characterIds,
        'locationId': e.locationId,
        'status': _mapLocalEventStatus(e.status),
        'plotThread': e.plotThread,
        'emotionalValue': e.emotionalValue,
      };

  // Chapters

  Future<void> pushChapterCreate(Chapter ch) async {
    if (!await _isOnline()) return;
    try {
      final resp =
          await _api.createChapter(ch.storyId, _chapterMetaToJson(ch));
      if (resp != null && resp['success'] != true) {
        await pushChapterUpdate(ch);
      } else if (ch.content != null && ch.content!.isNotEmpty) {
        // Push content separately via draft endpoint
        await _api.saveChapterDraft(ch.id, ch.content!);
      }
    } catch (e) {
      debugPrint('SyncService.pushChapterCreate failed: $e');
    }
  }

  Future<void> pushChapterUpdate(Chapter ch) async {
    if (!await _isOnline()) return;
    try {
      await _api.updateChapter(ch.id, _chapterMetaToJson(ch));
    } catch (e) {
      debugPrint('SyncService.pushChapterUpdate failed: $e');
    }
  }

  Future<void> pushChapterDraft(String chapterId, String content) async {
    if (!await _isOnline()) return;
    try {
      await _api.saveChapterDraft(chapterId, content);
    } catch (e) {
      debugPrint('SyncService.pushChapterDraft failed: $e');
    }
  }

  Future<void> pushChapterDelete(String id) async {
    if (!await _isOnline()) return;
    try {
      await _api.deleteChapter(id);
    } catch (e) {
      debugPrint('SyncService.pushChapterDelete failed: $e');
    }
  }

  Map<String, dynamic> _chapterMetaToJson(Chapter ch) => {
        'id': ch.id,
        'title': ch.title,
        'order': ch.order,
        'status': ch.status.name,
      };

  // Notes

  Future<void> pushNoteCreate(Note n) async {
    if (!await _isOnline()) return;
    try {
      final resp = await _api.createNote(n.storyId, _noteToJson(n));
      if (resp != null && resp['success'] != true) {
        await pushNoteUpdate(n);
      }
    } catch (e) {
      debugPrint('SyncService.pushNoteCreate failed: $e');
    }
  }

  Future<void> pushNoteUpdate(Note n) async {
    if (!await _isOnline()) return;
    try {
      await _api.updateNote(n.id, _noteToJson(n));
    } catch (e) {
      debugPrint('SyncService.pushNoteUpdate failed: $e');
    }
  }

  Future<void> pushNoteDelete(String id) async {
    if (!await _isOnline()) return;
    try {
      await _api.deleteNote(id);
    } catch (e) {
      debugPrint('SyncService.pushNoteDelete failed: $e');
    }
  }

  Map<String, dynamic> _noteToJson(Note n) => {
        'id': n.id,
        'content': n.content,
      };

  // Relationships

  Future<void> pushRelationshipCreate(Relationship r) async {
    if (!await _isOnline()) return;
    try {
      final resp =
          await _api.createRelationship(r.storyId, _relationshipToJson(r));
      if (resp != null && resp['success'] != true) {
        await pushRelationshipUpdate(r);
      }
    } catch (e) {
      debugPrint('SyncService.pushRelationshipCreate failed: $e');
    }
  }

  Future<void> pushRelationshipUpdate(Relationship r) async {
    if (!await _isOnline()) return;
    try {
      await _api.updateRelationship(r.id, _relationshipToJson(r));
    } catch (e) {
      debugPrint('SyncService.pushRelationshipUpdate failed: $e');
    }
  }

  Future<void> pushRelationshipDelete(String id) async {
    if (!await _isOnline()) return;
    try {
      await _api.deleteRelationship(id);
    } catch (e) {
      debugPrint('SyncService.pushRelationshipDelete failed: $e');
    }
  }

  Map<String, dynamic> _relationshipToJson(Relationship r) => {
        'id': r.id,
        'sourceId': r.sourceId,
        'targetId': r.targetId,
        'type': r.type,
        'description': r.description,
      };

  // Unresolved Questions

  Future<void> pushQuestionCreate(UnresolvedQuestion q) async {
    if (!await _isOnline()) return;
    try {
      final resp = await _api.createQuestion(q.storyId, _questionToJson(q));
      if (resp != null && resp['success'] != true) {
        await pushQuestionUpdate(q);
      }
    } catch (e) {
      debugPrint('SyncService.pushQuestionCreate failed: $e');
    }
  }

  Future<void> pushQuestionUpdate(UnresolvedQuestion q) async {
    if (!await _isOnline()) return;
    try {
      await _api.updateQuestion(q.id, _questionToJson(q));
    } catch (e) {
      debugPrint('SyncService.pushQuestionUpdate failed: $e');
    }
  }

  Future<void> pushQuestionDelete(String id) async {
    if (!await _isOnline()) return;
    try {
      await _api.deleteQuestion(id);
    } catch (e) {
      debugPrint('SyncService.pushQuestionDelete failed: $e');
    }
  }

  Map<String, dynamic> _questionToJson(UnresolvedQuestion q) => {
        'id': q.id,
        'question': q.question,
        'details': q.details,
        'isResolved': q.isResolved,
        'answer': q.answer,
      };

  /// Backward-compatible alias kept so existing call-sites still compile.
  Future<void> pushStoryToRemote(Story story) => pushStoryCreate(story);
}
