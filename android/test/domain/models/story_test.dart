import 'package:flutter_test/flutter_test.dart';
import 'package:storybook_android/domain/models/story.dart';

void main() {
  group('Story', () {
    test('copyWith updates only specified fields', () {
      final story = Story(
        id: '1', title: 'My Story',
        createdAt: DateTime(2025), updatedAt: DateTime(2025),
      );
      final updated = story.copyWith(title: 'New Title');
      expect(updated.title, 'New Title');
      expect(updated.id, '1');
    });

    test('serializes to/from JSON', () {
      final story = Story(
        id: '1', title: 'Test',
        createdAt: DateTime(2025, 1, 1), updatedAt: DateTime(2025, 1, 1),
      );
      final restored = Story.fromJson(story.toJson());
      expect(restored, story);
    });
  });
}
