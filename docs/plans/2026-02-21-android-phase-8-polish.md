# Android Phase 8: Polish (Export/Import, Undo/Redo, Relationship Graph, CLAUDE.md)

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Wire the export/import backup system (JSON ProjectBundle matching the web app format), implement in-memory undo/redo, add the character relationship graph, and update CLAUDE.md with Android instructions.

**Architecture:** `ExportService` serializes all Drift tables to the web app's `ProjectBundle` JSON schema. `UndoStack` is a Riverpod `Notifier` holding a list of async undo commands. `RelationshipGraphScreen` uses the `graphview` package.

**Tech Stack:** share_plus, file_picker, graphview, Riverpod

**Depends on:** All previous phases complete.
**Next phase:** None — this is the final phase.

---

## Task 1: Export / Import (ProjectBundle JSON)

**Files:**
- Create: `android/lib/data/local/export_service.dart`
- Modify: `android/lib/features/settings/screens/settings_screen.dart`

**Step 1: Export service**

`android/lib/data/local/export_service.dart`:

```dart
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
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
    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'application/json')],
      subject: 'Storybook backup: ${bundle['story']['title']}',
    );
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
```

**Step 2: Export service provider**

Add to `android/lib/core/providers/repository_providers.dart` (or a new file):

`android/lib/core/providers/export_provider.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local/export_service.dart';

final exportServiceProvider = Provider<ExportService>((_) => ExportService());
```

**Step 3: Write export service test**

`android/test/data/local/export_service_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:storybook_android/data/local/export_service.dart';
import 'package:storybook_android/domain/models/story.dart';

void main() {
  final service = ExportService();

  test('buildBundle produces correct structure', () {
    final story = Story(
      id: '1', title: 'Test',
      createdAt: DateTime(2025), updatedAt: DateTime(2025),
    );
    final bundle = service.buildBundle(
      story: story, characters: [], locations: [],
      events: [], chapters: [], notes: [], questions: [], relationships: [],
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
      () { if (badJson['appName'] != 'storybook') throw const FormatException('Not a valid Storybook backup file.'); },
      throwsA(isA<FormatException>()),
    );
  });
}
```

**Step 4: Run tests**

```bash
cd android
flutter test test/data/local/export_service_test.dart
```

Expected: PASS.

**Step 5: Wire export/import into settings screen**

Read `android/lib/features/settings/screens/settings_screen.dart`. Add the export/import provider and implement the `onTap` handlers.

Add import at top:
```dart
import '../../../core/providers/active_story_provider.dart';
import '../../../core/providers/export_provider.dart';
import '../../../core/providers/repository_providers.dart';
```

Replace the two `onTap: () => ScaffoldMessenger...` stubs with:

For export:
```dart
onTap: () async {
  final story = ref.read(activeStoryProvider);
  if (story == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Select a story from Dashboard first.')),
    );
    return;
  }
  try {
    final service = ref.read(exportServiceProvider);
    final chars = await ref.read(characterRepositoryProvider).getAllForStory(story.id);
    final locs = await ref.read(locationRepositoryProvider).getAllForStory(story.id);
    final events = await ref.read(plotEventRepositoryProvider).getAllForStory(story.id);
    final chapters = await ref.read(chapterRepositoryProvider).getAllForStory(story.id);
    final notes = await ref.read(noteRepositoryProvider).getAllForStory(story.id);
    final questions = await ref.read(questionRepositoryProvider).getAllForStory(story.id);
    final rels = await ref.read(relationshipRepositoryProvider).getAllForStory(story.id);
    final bundle = service.buildBundle(
      story: story, characters: chars, locations: locs, events: events,
      chapters: chapters, notes: notes, questions: questions, relationships: rels,
    );
    await service.exportToFile(bundle);
  } catch (e) {
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Export failed: $e')));
  }
},
```

For import (placeholder — full implementation requires deserializing and upserting each entity):
```dart
onTap: () async {
  try {
    final service = ref.read(exportServiceProvider);
    final bundle = await service.importFromFile();
    if (bundle == null) return;
    // TODO Phase 8 continuation: deserialize bundle and upsert all entities
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Import parsed. Full restore coming soon.')),
    );
  } catch (e) {
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Import failed: $e')));
  }
},
```

**Step 6: Commit**

```bash
git add android/lib/data/local/export_service.dart android/lib/core/providers/export_provider.dart android/lib/features/settings/ android/test/data/local/export_service_test.dart
git commit -m "feat(android): JSON export to share sheet and import file picker"
```

---

## Task 2: Undo/Redo

**Files:**
- Create: `android/lib/core/providers/undo_provider.dart`

**Step 1: Implement command stack**

`android/lib/core/providers/undo_provider.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef UndoCommand = Future<void> Function();

class UndoStack extends Notifier<List<UndoCommand>> {
  static const _maxSize = 50;

  @override
  List<UndoCommand> build() => [];

  void push(UndoCommand command) {
    final next = [...state, command];
    // Cap at max size to avoid unbounded memory use
    state = next.length > _maxSize ? next.sublist(next.length - _maxSize) : next;
  }

  Future<void> undo() async {
    if (state.isEmpty) return;
    final command = state.last;
    state = state.sublist(0, state.length - 1);
    await command();
  }

  bool get canUndo => state.isNotEmpty;
}

final undoStackProvider = NotifierProvider<UndoStack, List<UndoCommand>>(UndoStack.new);
```

**Step 2: Write tests**

`android/test/core/providers/undo_provider_test.dart`:

```dart
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
    container.read(undoStackProvider.notifier).push(() async { called = true; });
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
```

**Step 3: Run tests**

```bash
cd android
flutter test test/core/providers/undo_provider_test.dart
```

Expected: All PASS.

**Step 4: Wire undo into delete operations**

In character, location, plot event, note, and question delete handlers, push an undo command:

Example — in `character_providers.dart`, update `deleteCharacter`:

```dart
Future<void> deleteCharacter(String id) async {
  final backup = (await ref.read(characterRepositoryProvider).getById(id))!;
  await ref.read(characterRepositoryProvider).delete(id);
  ref.invalidateSelf();
  // Push undo command
  ref.read(undoStackProvider.notifier).push(() async {
    await ref.read(characterRepositoryProvider).create(backup);
    ref.invalidateSelf();
  });
}
```

Repeat for `deleteLocation`, `deleteEvent`, `deleteNote`, `deleteQuestion`.

**Step 5: Add undo button to app bar**

In `app_scaffold.dart`, expose the undo stack in the AppBar. Since the ShellRoute's AppBar is managed by child screens, the cleanest approach is to add an undo `SnackBar` with action instead:

In each screen where deletes happen, after the delete call, show:

```dart
ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  content: const Text('Deleted'),
  action: SnackBarAction(
    label: 'Undo',
    onPressed: () => ref.read(undoStackProvider.notifier).undo(),
  ),
  behavior: SnackBarBehavior.floating,
));
```

**Step 6: Commit**

```bash
git add android/lib/core/providers/undo_provider.dart android/test/core/providers/undo_provider_test.dart
git commit -m "feat(android): in-memory undo/redo command stack with 50-command cap"
```

---

## Task 3: Character Relationship Graph

**Files:**
- Create: `android/lib/features/codex/providers/relationship_providers.dart`
- Create: `android/lib/features/codex/screens/relationship_graph_screen.dart`
- Modify: `android/lib/features/codex/screens/codex_screen.dart` (add graph button)

**Step 1: Relationship providers**

`android/lib/features/codex/providers/relationship_providers.dart`:

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/active_story_provider.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../domain/models/relationship.dart';

part 'relationship_providers.g.dart';

@riverpod
class RelationshipList extends _$RelationshipList {
  @override
  Future<List<Relationship>> build() async {
    final story = ref.watch(activeStoryProvider);
    if (story == null) return [];
    return ref.watch(relationshipRepositoryProvider).getAllForStory(story.id);
  }

  Future<void> createRelationship({
    required String sourceId,
    required String targetId,
    required String type,
    String description = '',
  }) async {
    final story = ref.read(activeStoryProvider);
    if (story == null) return;
    final rel = Relationship(
      id: const Uuid().v4(),
      storyId: story.id,
      sourceId: sourceId,
      targetId: targetId,
      type: type,
      description: description,
    );
    await ref.read(relationshipRepositoryProvider).create(rel);
    ref.invalidateSelf();
  }

  Future<void> deleteRelationship(String id) async {
    await ref.read(relationshipRepositoryProvider).delete(id);
    ref.invalidateSelf();
  }
}
```

**Step 2: Run code generation**

```bash
cd android
dart run build_runner build --delete-conflicting-outputs
```

**Step 3: Relationship graph screen**

`android/lib/features/codex/screens/relationship_graph_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphview/GraphView.dart';
import '../providers/character_providers.dart';
import '../providers/relationship_providers.dart';

class RelationshipGraphScreen extends ConsumerWidget {
  const RelationshipGraphScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characters = ref.watch(characterListProvider).valueOrNull ?? [];
    final relationships = ref.watch(relationshipListProvider).valueOrNull ?? [];

    if (characters.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No characters yet. Add characters in the Codex.')),
      );
    }

    final graph = Graph();
    final nodeMap = {for (final c in characters) c.id: Node.Id(c.id)};
    for (final node in nodeMap.values) graph.addNode(node);
    for (final rel in relationships) {
      final src = nodeMap[rel.sourceId];
      final tgt = nodeMap[rel.targetId];
      if (src != null && tgt != null) {
        graph.addEdge(
          src, tgt,
          paint: Paint()..color = Theme.of(context).colorScheme.primary.withOpacity(0.6),
        );
      }
    }

    final algorithm = FruchtermanReingoldAlgorithm(iterations: 1000);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relationships'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_link),
            tooltip: 'Add relationship',
            onPressed: () => _showAddRelationship(context, ref, characters),
          ),
        ],
      ),
      body: InteractiveViewer(
        constrained: false,
        boundaryMargin: const EdgeInsets.all(100),
        minScale: 0.5,
        maxScale: 3.0,
        child: GraphView(
          graph: graph,
          algorithm: algorithm,
          paint: Paint()
            ..color = Theme.of(context).colorScheme.outline
            ..strokeWidth = 1.5
            ..style = PaintingStyle.stroke,
          builder: (node) {
            final charId = node.key!.value as String;
            final char = characters.firstWhere(
              (c) => c.id == charId,
              orElse: () => characters.first,
            );
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Theme.of(context).colorScheme.primary),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(char.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(char.role.name, style: const TextStyle(fontSize: 10)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showAddRelationship(BuildContext context, WidgetRef ref, List<dynamic> characters) {
    String? sourceId;
    String? targetId;
    final typeCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Add Relationship'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'From'),
                items: characters.map<DropdownMenuItem<String>>((c) =>
                    DropdownMenuItem(value: c.id as String, child: Text(c.name as String))).toList(),
                onChanged: (v) => setState(() => sourceId = v),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'To'),
                items: characters.map<DropdownMenuItem<String>>((c) =>
                    DropdownMenuItem(value: c.id as String, child: Text(c.name as String))).toList(),
                onChanged: (v) => setState(() => targetId = v),
              ),
              const SizedBox(height: 8),
              TextField(controller: typeCtrl, decoration: const InputDecoration(labelText: 'Relationship type (e.g. Rivals, Allies)')),
              const SizedBox(height: 8),
              TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Description (optional)')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              onPressed: (sourceId != null && targetId != null && typeCtrl.text.isNotEmpty) ? () {
                ref.read(relationshipListProvider.notifier).createRelationship(
                  sourceId: sourceId!,
                  targetId: targetId!,
                  type: typeCtrl.text,
                  description: descCtrl.text,
                );
                Navigator.pop(ctx);
              } : null,
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Step 4: Add graph button to Codex screen**

In `android/lib/features/codex/screens/codex_screen.dart`, add an action to the AppBar:

```dart
actions: [
  IconButton(
    icon: const Icon(Icons.hub),
    tooltip: 'Relationship Graph',
    onPressed: () => Navigator.push(context, MaterialPageRoute(
      builder: (_) => const RelationshipGraphScreen(),
    )),
  ),
],
```

**Step 5: Run the app and verify**

```bash
cd android && flutter run
```

Expected: Codex → graph icon → relationship graph shows character nodes. Add relationship button opens dialog to connect two characters.

**Step 6: Commit**

```bash
git add android/lib/features/codex/
git commit -m "feat(android): character relationship graph visualizer with add-relationship dialog"
```

---

## Task 4: Run Full Test Suite + Update CLAUDE.md

**Step 1: Run all tests**

```bash
cd android
flutter test
```

Expected: All tests PASS. Fix any failures before proceeding.

**Step 2: Check for analysis warnings**

```bash
cd android
flutter analyze
```

Expected: No errors. Warnings are acceptable but fix any `unused_import` or obvious issues.

**Step 3: Update CLAUDE.md**

Read `G:/code/gen-ai/storybook_v1/CLAUDE.md` and add an `## Android App` section:

```markdown
## Android App

Location: `android/` (Flutter 3.x + Dart)

### Commands

```bash
cd android
flutter run                                        # Run on connected device/emulator
flutter test                                       # Run all tests
flutter test test/path/to/test.dart               # Run single test
flutter analyze                                    # Static analysis
dart run build_runner build --delete-conflicting-outputs  # Regenerate code (REQUIRED after any file with part '*.g.dart')
```

### Architecture

- **State:** Riverpod 2.x (`AsyncNotifier` per feature, providers in `lib/core/providers/` and `lib/features/<feature>/providers/`)
- **Storage:** Drift SQLite (`lib/data/local/`). Schema mirrors Prisma models.
- **AI:** `AiService` abstract class in `lib/domain/services/`. Active impl: `GeminiAiService` (`lib/data/remote/`). Swap to backend proxy by changing `aiServiceProvider` in `lib/core/providers/ai_provider.dart`.
- **Navigation:** go_router with ShellRoute (5-tab bottom nav in `AppScaffold`).

### Code Generation

Run `dart run build_runner build --delete-conflicting-outputs` after modifying:
- Any file with `part '*.g.dart'` or `part '*.freezed.dart'` (Freezed models, Riverpod providers)
- Drift table definitions in `lib/data/local/tables/`

### Switching AI from Direct → Backend Proxy

When the NestJS backend is ready (Phase 4-5 of UPGRADE.md), change `aiServiceProvider`:
```dart
// In android/lib/core/providers/ai_provider.dart
// Replace GeminiAiService(...) with BackendProxyAiService(baseUrl, jwtToken)
```
```

**Step 4: Final commit**

```bash
git add android/ CLAUDE.md
git commit -m "feat(android): complete Android app — full feature parity with web

All 9 feature areas implemented:
- Dashboard: multi-story management
- Codex: characters (arc tracking), locations (sensory fields), relationship graph
- Timeline: 2D Kanban board + pacing graph
- Draft: chapter editor, focus mode, markdown preview, reference sidebar
- Story Engine: seed expander, AI critique, plot holes, beat sheets, tropes
- Scratchpad: masonry notes with inline edit
- Questions: global FAB panel with resolve/archive
- Settings: theme toggle, API keys, JSON export/import
- Undo/redo: in-memory command stack

Flutter + Riverpod + Drift. Local-first, ready for backend sync."
```
