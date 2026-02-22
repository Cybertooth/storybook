import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

// Tests the JSON cleaning and parsing logic without real HTTP calls.
void main() {
  group('Gemini JSON parsing', () {
    test('parses bare JSON array', () {
      const raw = '["A", "B", "C"]';
      final cleaned = raw.replaceAll(RegExp(r'```json\s*|```\s*'), '').trim();
      final result = List<String>.from(jsonDecode(cleaned));
      expect(result.length, 3);
      expect(result[0], 'A');
    });

    test('strips markdown code fences before parsing', () {
      const raw = '```json\n["A", "B"]\n```';
      final cleaned = raw.replaceAll(RegExp(r'```json\s*|```\s*'), '').trim();
      final result = List<String>.from(jsonDecode(cleaned));
      expect(result.length, 2);
    });

    test('parses critique objects', () {
      const raw = '[{"text": "Pacing issue", "severity": "Major"}]';
      final cleaned = raw.replaceAll(RegExp(r'```json\s*|```\s*'), '').trim();
      final result = List<Map<String, dynamic>>.from(jsonDecode(cleaned));
      expect(result[0]['severity'], 'Major');
    });
  });
}
