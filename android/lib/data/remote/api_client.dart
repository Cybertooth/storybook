import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/providers/auth_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final settings = await ref.read(settingsProvider.future);
      options.baseUrl = settings.backendUrl;

      final authState = await ref.read(authProvider.future);
      if (authState.isAuthenticated) {
        options.headers['Authorization'] = 'Bearer ${authState.token}';
      }

      return handler.next(options);
    },
  ));

  if (kDebugMode) {
    dio.interceptors.add(LogInterceptor(
      request: false,
      requestHeader: false,
      requestBody: true,
      responseHeader: false,
      responseBody: true,
      error: true,
    ));
  }

  return dio;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref.watch(dioProvider));
});

class ApiClient {
  final Dio _dio;
  ApiClient(this._dio);

  Dio get dio => _dio;

  // ── AUTH ──────────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>?> login(String email, String password) async =>
      _post('/auth/login', {'email': email, 'password': password});

  Future<Map<String, dynamic>?> register(String email, String password) async =>
      _post('/auth/register', {'email': email, 'password': password});

  Future<Map<String, dynamic>?> getMe() async => _get('/auth/me');

  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
    } catch (_) {}
  }

  // ── STORIES ───────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>?> getStories() async => _get('/stories');

  Future<Map<String, dynamic>?> createStory(Map<String, dynamic> data) async =>
      _post('/stories', data);

  Future<Map<String, dynamic>?> updateStory(
          String id, Map<String, dynamic> data) async =>
      _put('/stories/$id', data);

  Future<void> deleteStory(String id) async => _delete('/stories/$id');

  // ── CHARACTERS ────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>?> getCharacters(String storyId) async =>
      _get('/stories/$storyId/characters');

  Future<Map<String, dynamic>?> createCharacter(
          String storyId, Map<String, dynamic> data) async =>
      _post('/stories/$storyId/characters', data);

  Future<Map<String, dynamic>?> updateCharacter(
          String id, Map<String, dynamic> data) async =>
      _put('/characters/$id', data);

  Future<void> deleteCharacter(String id) async => _delete('/characters/$id');

  // ── LOCATIONS ─────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>?> getLocations(String storyId) async =>
      _get('/stories/$storyId/locations');

  Future<Map<String, dynamic>?> createLocation(
          String storyId, Map<String, dynamic> data) async =>
      _post('/stories/$storyId/locations', data);

  Future<Map<String, dynamic>?> updateLocation(
          String id, Map<String, dynamic> data) async =>
      _put('/locations/$id', data);

  Future<void> deleteLocation(String id) async => _delete('/locations/$id');

  // ── PLOT EVENTS ───────────────────────────────────────────────────────────

  Future<Map<String, dynamic>?> getEvents(String storyId) async =>
      _get('/stories/$storyId/events');

  Future<Map<String, dynamic>?> createEvent(
          String storyId, Map<String, dynamic> data) async =>
      _post('/stories/$storyId/events', data);

  Future<Map<String, dynamic>?> updateEvent(
          String id, Map<String, dynamic> data) async =>
      _put('/events/$id', data);

  Future<void> deleteEvent(String id) async => _delete('/events/$id');

  // ── CHAPTERS ──────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>?> getChapters(String storyId) async =>
      _get('/stories/$storyId/chapters');

  Future<Map<String, dynamic>?> createChapter(
          String storyId, Map<String, dynamic> data) async =>
      _post('/stories/$storyId/chapters', data);

  Future<Map<String, dynamic>?> updateChapter(
          String id, Map<String, dynamic> data) async =>
      _put('/chapters/$id', data);

  Future<Map<String, dynamic>?> getChapterDraft(String id) async =>
      _get('/chapters/$id/draft');

  Future<Map<String, dynamic>?> saveChapterDraft(
          String id, String content) async =>
      _put('/chapters/$id/draft', {'content': content});

  Future<void> deleteChapter(String id) async => _delete('/chapters/$id');

  // ── NOTES ─────────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>?> getNotes(String storyId) async =>
      _get('/stories/$storyId/notes');

  Future<Map<String, dynamic>?> createNote(
          String storyId, Map<String, dynamic> data) async =>
      _post('/stories/$storyId/notes', data);

  Future<Map<String, dynamic>?> updateNote(
          String id, Map<String, dynamic> data) async =>
      _put('/notes/$id', data);

  Future<void> deleteNote(String id) async => _delete('/notes/$id');

  // ── RELATIONSHIPS ─────────────────────────────────────────────────────────

  Future<Map<String, dynamic>?> getRelationships(String storyId) async =>
      _get('/stories/$storyId/relationships');

  Future<Map<String, dynamic>?> createRelationship(
          String storyId, Map<String, dynamic> data) async =>
      _post('/stories/$storyId/relationships', data);

  Future<Map<String, dynamic>?> updateRelationship(
          String id, Map<String, dynamic> data) async =>
      _put('/relationships/$id', data);

  Future<void> deleteRelationship(String id) async =>
      _delete('/relationships/$id');

  // ── QUESTIONS ─────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>?> getQuestions(String storyId) async =>
      _get('/stories/$storyId/questions');

  Future<Map<String, dynamic>?> createQuestion(
          String storyId, Map<String, dynamic> data) async =>
      _post('/stories/$storyId/questions', data);

  Future<Map<String, dynamic>?> updateQuestion(
          String id, Map<String, dynamic> data) async =>
      _put('/questions/$id', data);

  Future<void> deleteQuestion(String id) async => _delete('/questions/$id');

  // ── AI PROXY ──────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>?> aiGeneratePortrait(
          String characterDescription) async =>
      _post('/ai/generate-portrait',
          {'characterDescription': characterDescription});

  Future<Map<String, dynamic>?> aiAnalyzeTropes(String storyContext) async =>
      _post('/ai/analyze-tropes', {'storyContext': storyContext});

  Future<Map<String, dynamic>?> aiPlotHoleCheck(String storyContext) async =>
      _post('/ai/plot-hole-check', {'storyContext': storyContext});

  Future<Map<String, dynamic>?> aiExpandPlot(String currentPlot) async =>
      _post('/ai/expand-plot', {'currentPlot': currentPlot});

  Future<Map<String, dynamic>?> aiCritique(
          String draft, String context) async =>
      _post('/ai/critique', {'draft': draft, 'context': context});

  Future<Map<String, dynamic>?> aiReviseDraft(
          String draft, List<String> maxims) async =>
      _post('/ai/revise-draft', {'draft': draft, 'maxims': maxims});

  Future<Map<String, dynamic>?> aiShowDontTell(String prose) async =>
      _post('/ai/show-dont-tell', {'prose': prose});

  Future<Map<String, dynamic>?> aiSuggestNext(
          String priorText, String plotContext) async =>
      _post('/ai/suggest-next',
          {'priorText': priorText, 'plotContext': plotContext});

  // ── PRIVATE HELPERS ───────────────────────────────────────────────────────

  Future<Map<String, dynamic>?> _get(String path) async {
    try {
      final r = await _dio.get(path);
      return r.data as Map<String, dynamic>?;
    } on DioException catch (e) {
      debugPrint('GET $path failed: ${e.message}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> _post(
      String path, Map<String, dynamic> data) async {
    try {
      final r = await _dio.post(path, data: data);
      return r.data as Map<String, dynamic>?;
    } on DioException catch (e) {
      return e.response?.data is Map<String, dynamic>
          ? e.response!.data as Map<String, dynamic>
          : {'success': false, 'message': e.message};
    }
  }

  Future<Map<String, dynamic>?> _put(
      String path, Map<String, dynamic> data) async {
    try {
      final r = await _dio.put(path, data: data);
      return r.data as Map<String, dynamic>?;
    } on DioException catch (e) {
      debugPrint('PUT $path failed: ${e.message}');
      return null;
    }
  }

  Future<void> _delete(String path) async {
    try {
      await _dio.delete(path);
    } on DioException catch (e) {
      debugPrint('DELETE $path failed: ${e.message}');
    }
  }
}
