import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../domain/services/ai_service.dart';
import 'api_client.dart';

/// AiService implementation that proxies all AI requests through the NestJS backend.
/// Used when the user is authenticated so that API keys are never stored on device.
class BackendProxyAiService implements AiService {
  final ApiClient _api;

  const BackendProxyAiService(this._api);

  /// Extracts a List from the backend response's `data` field.
  /// Handles both pre-parsed lists and JSON-string-encoded lists.
  List<dynamic> _parseListResult(Map<String, dynamic>? resp) {
    if (resp == null || resp['success'] != true) return [];
    final data = resp['data'];
    if (data is List) return data;
    if (data is String) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is List) return decoded;
      } catch (_) {}
    }
    return [];
  }

  /// Extracts a String from the backend response's `data` field.
  String _parseStringResult(Map<String, dynamic>? resp) {
    if (resp == null || resp['success'] != true) return '';
    final data = resp['data'];
    if (data is String) return data;
    if (data is Map) return data['text'] as String? ?? '';
    return '';
  }

  @override
  Future<List<String>> suggestContinuations(String seed) async {
    try {
      final resp = await _api.aiExpandPlot(seed);
      return _parseListResult(resp).map((e) => e.toString()).toList();
    } catch (e) {
      debugPrint('BackendProxy.suggestContinuations failed: $e');
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> critique(
      String draft, String context) async {
    try {
      final resp = await _api.aiCritique(draft, context);
      return _parseListResult(resp)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    } catch (e) {
      debugPrint('BackendProxy.critique failed: $e');
      rethrow;
    }
  }

  @override
  Future<String> reviseDraft(
      String draft, List<String> selectedCritiques) async {
    try {
      final resp = await _api.aiReviseDraft(draft, selectedCritiques);
      return _parseStringResult(resp);
    } catch (e) {
      debugPrint('BackendProxy.reviseDraft failed: $e');
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> checkPlotHoles(
      String storyContext) async {
    try {
      final resp = await _api.aiPlotHoleCheck(storyContext);
      return _parseListResult(resp)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    } catch (e) {
      debugPrint('BackendProxy.checkPlotHoles failed: $e');
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> analyzeTropes(
      String storyContext) async {
    try {
      final resp = await _api.aiAnalyzeTropes(storyContext);
      return _parseListResult(resp)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    } catch (e) {
      debugPrint('BackendProxy.analyzeTropes failed: $e');
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> showDontTell(String prose) async {
    try {
      final resp = await _api.aiShowDontTell(prose);
      return _parseListResult(resp)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    } catch (e) {
      debugPrint('BackendProxy.showDontTell failed: $e');
      rethrow;
    }
  }

  @override
  Future<List<String>> suggestNext(
      String priorText, String plotContext) async {
    try {
      final resp = await _api.aiSuggestNext(priorText, plotContext);
      return _parseListResult(resp).map((e) => e.toString()).toList();
    } catch (e) {
      debugPrint('BackendProxy.suggestNext failed: $e');
      rethrow;
    }
  }

  @override
  Future<String?> generatePortrait(String characterDescription) async {
    try {
      final resp = await _api.aiGeneratePortrait(characterDescription);
      if (resp == null || resp['success'] != true) return null;
      final data = resp['data'];
      if (data is Map) return data['url'] as String?;
      if (data is String) return data;
      return null;
    } catch (e) {
      debugPrint('BackendProxy.generatePortrait failed: $e');
      return null;
    }
  }
}
