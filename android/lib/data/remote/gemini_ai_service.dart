import 'dart:convert';
import 'package:dio/dio.dart';
import '../../domain/services/ai_service.dart';

class GeminiAiService implements AiService {
  final String apiKey;
  final Dio _dio;

  GeminiAiService(this.apiKey)
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://generativelanguage.googleapis.com/v1beta',
          queryParameters: {'key': apiKey},
          headers: {'Content-Type': 'application/json'},
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 60),
        ));

  Future<String> _generate(String prompt) async {
    final response = await _dio.post(
      '/models/gemini-1.5-flash:generateContent',
      data: {
        'contents': [
          {'parts': [{'text': prompt}]}
        ],
        'generationConfig': {'temperature': 0.8, 'maxOutputTokens': 2048},
      },
    );
    final data = response.data;
    final candidates = data?['candidates'] as List<dynamic>?;
    if (candidates == null || candidates.isEmpty) {
      throw Exception(
          'AI returned no response. This may be due to a safety filter or quota limit.');
    }
    return candidates[0]['content']['parts'][0]['text'] as String;
  }

  List<dynamic> _parseJsonArray(String raw) {
    // Strip markdown code fences (```json ... ``` or ``` ... ```)
    final cleaned =
        raw.replaceAll(RegExp(r'```(?:json)?\s*'), '').replaceAll('```', '').trim();
    final decoded = jsonDecode(cleaned);
    if (decoded is List) return decoded;
    throw FormatException(
        'Expected a JSON array from AI but received ${decoded.runtimeType}');
  }

  @override
  Future<List<String>> suggestContinuations(String seed) async {
    final raw = await _generate('''Given this story seed: "$seed"
Provide exactly 3 distinct, creative continuations. Return them as a JSON array of strings.
Example: ["continuation 1", "continuation 2", "continuation 3"]
Return ONLY the JSON array, no other text.''');
    return List<String>.from(_parseJsonArray(raw));
  }

  @override
  Future<List<Map<String, dynamic>>> critique(String draft, String context) async {
    final raw = await _generate('''Critically analyze this story excerpt.
${context.isNotEmpty ? 'Story context: $context' : ''}
Draft: $draft

Return a JSON array of critique objects. Each object must have:
- "text": the specific critique
- "severity": exactly one of "Small", "Medium", or "Major"

Return ONLY the JSON array.''');
    return List<Map<String, dynamic>>.from(_parseJsonArray(raw));
  }

  @override
  Future<String> reviseDraft(String draft, List<String> selectedCritiques) async {
    return _generate('''Revise the following draft to address these critiques:
${selectedCritiques.asMap().entries.map((e) => '${e.key + 1}. ${e.value}').join('\n')}

Original draft:
$draft

Return ONLY the revised draft text, no preamble.''');
  }

  @override
  Future<List<Map<String, dynamic>>> checkPlotHoles(String storyContext) async {
    final raw = await _generate('''Analyze this story for plot holes, continuity errors, and abandoned threads:
$storyContext

Return a JSON array. Each object must have:
- "issue": description of the problem
- "severity": "Minor" or "Major"
- "suggestion": how to fix it

Return ONLY the JSON array.''');
    return List<Map<String, dynamic>>.from(_parseJsonArray(raw));
  }

  @override
  Future<List<Map<String, dynamic>>> analyzeTropes(String storyContext) async {
    final raw = await _generate('''Identify narrative tropes and clichés in this story:
$storyContext

Return a JSON array. Each object must have:
- "trope": the trope name
- "risk": "Low", "Medium", or "High"
- "description": brief explanation
- "suggestion": how to subvert or lean in intentionally

Return ONLY the JSON array.''');
    return List<Map<String, dynamic>>.from(_parseJsonArray(raw));
  }

  @override
  Future<List<Map<String, dynamic>>> showDontTell(String prose) async {
    final raw = await _generate('''Identify "tell-heavy" sentences in this prose and rewrite them to "show" instead:
$prose

Return a JSON array. Each object must have:
- "original": the tell-heavy original sentence
- "suggestion": an evocative rewrite that shows instead

Return ONLY the JSON array.''');
    return List<Map<String, dynamic>>.from(_parseJsonArray(raw));
  }

  @override
  Future<List<String>> suggestNext(String priorText, String plotContext) async {
    final raw = await _generate('''${plotContext.isNotEmpty ? 'Story context: $plotContext\n\n' : ''}Recent prose:
$priorText

Suggest 3 distinct, short continuations (1-3 sentences each). Return as a JSON array of strings.
Return ONLY the JSON array.''');
    return List<String>.from(_parseJsonArray(raw));
  }

  @override
  Future<String?> generatePortrait(String characterDescription) async {
    // Imagen API requires separate setup; stub returns null for now.
    return null;
  }
}
