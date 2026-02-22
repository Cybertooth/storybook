import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storybook_android/core/providers/undo_provider.dart';

void main() {
  late ProviderContainer container;

  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  test('canUndo is false when stack is empty', () {
    expect(container.read(undoStackProvider.notifier).canUndo, false);
  });

  test('canUndo is true after push', () {
    container.read(undoStackProvider.notifier).push(() async {});
    expect(container.read(undoStackProvider.notifier).canUndo, true);
  });

  test('undo calls the last pushed command', () async {
    bool called = false;
    container
        .read(undoStackProvider.notifier)
        .push(() async { called = true; });
    await container.read(undoStackProvider.notifier).undo();
    expect(called, true);
    expect(container.read(undoStackProvider.notifier).canUndo, false);
  });

  test('undo removes only the last command', () async {
    int callCount = 0;
    container.read(undoStackProvider.notifier).push(() async { callCount++; });
    container.read(undoStackProvider.notifier).push(() async { callCount += 10; });
    await container.read(undoStackProvider.notifier).undo();
    expect(callCount, 10); // Only second command called
    expect(container.read(undoStackProvider.notifier).canUndo, true); // First still in stack
  });
}
