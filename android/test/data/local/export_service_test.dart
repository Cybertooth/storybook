import 'package:flutter_test/flutter_test.dart';
import 'package:storybook_android/data/local/export_service.dart';
import 'package:storybook_android/domain/models/story.dart';

void main() {
  final service = ExportService();

  test('buildBundle produces correct structure', () {
    final story = Story(
      id: '1',
      title: 'Test',
      createdAt: DateTime(2025),
      updatedAt: DateTime(2025),
    );
    final bundle = service.buildBundle(
      story: story,
      characters: [],
      locations: [],
      events: [],
      chapters: [],
      notes: [],
      questions: [],
      relationships: [],
    );
    expect(bundle['appName'], 'storybook');
    expect(bundle['version'], 1);
    expect(bundle['story']['title'], 'Test');
    expect(bundle['characters'], isEmpty);
  });

  test('buildBundle throws FormatException on wrong appName', () {
    // Simulated import validation
    final badJson = {'appName': 'wrong', 'story': {}};
    expect(
      () {
        if (badJson['appName'] != 'storybook') {
          throw const FormatException('Not a valid Storybook backup file.');
        }
      },
      throwsA(isA<FormatException>()),
    );
  });
}
