# Android Phase 5: Draft Editor

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Implement the Draft tab — a chapter list drawer, a distraction-free markdown editor, and a reference slide-in drawer showing characters/locations/events.

**Architecture:** `ChapterList` + `ActiveChapter` Riverpod notifiers. Editor auto-saves on every keystroke via debounced write. Reference drawer is a DraggableScrollableSheet.

**Tech Stack:** Riverpod, flutter_markdown (for preview toggle), TextField (for editing)

**Depends on:** Phase 2 (chapter repository), Phase 3 (character/location providers available).
**Next phase:** `2026-02-21-android-phase-6-ai-engine.md`

---

## Task 1: Draft Providers

**Files:**
- Create: `android/lib/features/draft/providers/draft_providers.dart`

**Step 1: Write providers**

`android/lib/features/draft/providers/draft_providers.dart`:

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/active_story_provider.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../domain/models/chapter.dart';

part 'draft_providers.g.dart';

@riverpod
class ChapterList extends _$ChapterList {
  @override
  Future<List<Chapter>> build() async {
    final story = ref.watch(activeStoryProvider);
    if (story == null) return [];
    final chapters = await ref.watch(chapterRepositoryProvider).getAllForStory(story.id);
    chapters.sort((a, b) => a.order.compareTo(b.order));
    return chapters;
  }

  Future<Chapter> createChapter(String title) async {
    final story = ref.read(activeStoryProvider)!;
    final existing = await ref.read(chapterRepositoryProvider).getAllForStory(story.id);
    final chapter = Chapter(
      id: const Uuid().v4(),
      storyId: story.id,
      title: title,
      order: existing.length,
    );
    final created = await ref.read(chapterRepositoryProvider).create(chapter);
    ref.invalidateSelf();
    return created;
  }

  Future<void> saveContent(Chapter chapter, String content) async {
    await ref.read(chapterRepositoryProvider).update(chapter.copyWith(content: content));
    // Don't invalidateSelf here — it would cause re-render while typing.
    // The active chapter state is the source of truth during editing.
  }

  Future<void> deleteChapter(String id) async {
    await ref.read(chapterRepositoryProvider).delete(id);
    ref.invalidateSelf();
  }
}

@riverpod
class ActiveChapter extends _$ActiveChapter {
  @override
  Chapter? build() => null;

  void set(Chapter c) => state = c;
  void clear() => state = null;
}
```

**Step 2: Run code generation**

```bash
cd android
dart run build_runner build --delete-conflicting-outputs
```

**Step 3: Commit**

```bash
git add android/lib/features/draft/providers/
git commit -m "feat(android): draft chapter list and active chapter providers"
```

---

## Task 2: Reference Drawer Widget

**Files:**
- Create: `android/lib/features/draft/widgets/reference_drawer.dart`

**Step 1: Implement reference drawer**

`android/lib/features/draft/widgets/reference_drawer.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../codex/providers/character_providers.dart';
import '../../locations/providers/location_providers.dart';
import '../../timeline/providers/timeline_providers.dart';

class ReferenceDrawer extends ConsumerStatefulWidget {
  const ReferenceDrawer({super.key});

  @override
  ConsumerState<ReferenceDrawer> createState() => _State();
}

class _State extends ConsumerState<ReferenceDrawer> {
  final Set<String> _pinned = {};

  @override
  Widget build(BuildContext context) {
    final characters = ref.watch(characterListProvider).valueOrNull ?? [];
    final locations = ref.watch(locationListProvider).valueOrNull ?? [];
    final events = ref.watch(eventListProvider).valueOrNull ?? [];

    final pinnedChars = characters.where((c) => _pinned.contains(c.id)).toList();
    final pinnedLocs = locations.where((l) => _pinned.contains(l.id)).toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, controller) => Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          if (pinnedChars.isNotEmpty || pinnedLocs.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(children: [
                const Icon(Icons.push_pin, size: 14),
                const SizedBox(width: 4),
                const Text('Pinned', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ]),
            ),
            SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  ...pinnedChars.map((c) => _PinnedChip(
                    label: c.name,
                    onRemove: () => setState(() => _pinned.remove(c.id)),
                  )),
                  ...pinnedLocs.map((l) => _PinnedChip(
                    label: l.name,
                    onRemove: () => setState(() => _pinned.remove(l.id)),
                  )),
                ],
              ),
            ),
            const Divider(),
          ],
          Expanded(
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  const TabBar(tabs: [
                    Tab(text: 'Characters'),
                    Tab(text: 'Locations'),
                    Tab(text: 'Events'),
                  ]),
                  Expanded(
                    child: TabBarView(children: [
                      // Characters tab
                      ListView(controller: controller, children: characters.map((c) => ListTile(
                        leading: CircleAvatar(child: Text(c.name[0])),
                        title: Text(c.name),
                        subtitle: c.description.isNotEmpty ? Text(c.description, maxLines: 1) : null,
                        trailing: IconButton(
                          icon: Icon(_pinned.contains(c.id) ? Icons.push_pin : Icons.push_pin_outlined, size: 18),
                          onPressed: () => setState(() {
                            if (_pinned.contains(c.id)) _pinned.remove(c.id); else _pinned.add(c.id);
                          }),
                        ),
                      )).toList()),
                      // Locations tab
                      ListView(children: locations.map((l) => ListTile(
                        leading: const Icon(Icons.place),
                        title: Text(l.name),
                        subtitle: l.description.isNotEmpty ? Text(l.description, maxLines: 1) : null,
                        trailing: IconButton(
                          icon: Icon(_pinned.contains(l.id) ? Icons.push_pin : Icons.push_pin_outlined, size: 18),
                          onPressed: () => setState(() {
                            if (_pinned.contains(l.id)) _pinned.remove(l.id); else _pinned.add(l.id);
                          }),
                        ),
                      )).toList()),
                      // Events tab
                      ListView(children: events.map((e) => ListTile(
                        leading: const Icon(Icons.event),
                        title: Text(e.title),
                        subtitle: e.description.isNotEmpty ? Text(e.description, maxLines: 1) : null,
                      )).toList()),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PinnedChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;
  const _PinnedChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      deleteIcon: const Icon(Icons.close, size: 14),
      onDeleted: onRemove,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
```

**Step 2: Commit**

```bash
git add android/lib/features/draft/widgets/reference_drawer.dart
git commit -m "feat(android): reference drawer with pinning for characters and locations"
```

---

## Task 3: Draft Screen

**Files:**
- Create: `android/lib/features/draft/screens/draft_screen.dart` (replace stub)

**Step 1: Implement draft screen**

`android/lib/features/draft/screens/draft_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/active_story_provider.dart';
import '../providers/draft_providers.dart';
import '../widgets/reference_drawer.dart';

class DraftScreen extends ConsumerStatefulWidget {
  const DraftScreen({super.key});

  @override
  ConsumerState<DraftScreen> createState() => _DraftScreenState();
}

class _DraftScreenState extends ConsumerState<DraftScreen> {
  final _controller = TextEditingController();
  bool _focusMode = false;
  bool _previewMode = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final active = ref.watch(activeStoryProvider);
    final activeChapter = ref.watch(activeChapterProvider);
    final chaptersAsync = ref.watch(chapterListProvider);

    // Keep editor in sync with active chapter
    if (activeChapter != null && _controller.text != activeChapter.content) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _controller.text = activeChapter.content;
      });
    }

    if (active == null) {
      return const Scaffold(body: Center(child: Text('Select a story from the Dashboard first.')));
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: _focusMode ? null : AppBar(
        title: Text(activeChapter?.title ?? 'Draft', overflow: TextOverflow.ellipsis),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: Icon(_previewMode ? Icons.edit : Icons.preview),
            tooltip: _previewMode ? 'Edit' : 'Preview',
            onPressed: () => setState(() => _previewMode = !_previewMode),
          ),
          IconButton(
            icon: const Icon(Icons.menu_book),
            tooltip: 'Reference',
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => const ReferenceDrawer(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.fullscreen),
            tooltip: 'Focus Mode',
            onPressed: () => setState(() => _focusMode = true),
          ),
        ],
      ),
      drawer: _buildChapterDrawer(context, chaptersAsync),
      body: _buildBody(context, activeChapter),
      floatingActionButton: _focusMode
          ? FloatingActionButton.small(
              onPressed: () => setState(() => _focusMode = false),
              child: const Icon(Icons.fullscreen_exit),
            )
          : null,
    );
  }

  Widget _buildBody(BuildContext context, dynamic activeChapter) {
    if (activeChapter == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('No chapter selected.'),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              child: const Text('Open Chapter List'),
            ),
          ],
        ),
      );
    }
    if (_previewMode) {
      return Markdown(
        data: _controller.text,
        padding: const EdgeInsets.all(16),
      );
    }
    return TextField(
      controller: _controller,
      maxLines: null,
      expands: true,
      keyboardType: TextInputType.multiline,
      style: const TextStyle(fontSize: 16, height: 1.6),
      decoration: const InputDecoration(
        hintText: 'Begin writing...',
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(16),
      ),
      onChanged: (content) {
        final chapter = ref.read(activeChapterProvider);
        if (chapter != null) {
          ref.read(chapterListProvider.notifier).saveContent(chapter, content);
          // Update active chapter state to keep it in sync
          ref.read(activeChapterProvider.notifier).set(chapter.copyWith(content: content));
        }
      },
    );
  }

  Widget? _buildChapterDrawer(BuildContext context, AsyncValue chaptersAsync) {
    return chaptersAsync.when(
      loading: () => null,
      error: (_, __) => null,
      data: (chapters) => Drawer(
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Chapters', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              Expanded(
                child: ListView(
                  children: chapters.map<Widget>((c) {
                    final active = ref.read(activeChapterProvider);
                    return ListTile(
                      title: Text(c.title),
                      selected: c.id == active?.id,
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, size: 18),
                        onPressed: () {
                          ref.read(chapterListProvider.notifier).deleteChapter(c.id);
                          if (ref.read(activeChapterProvider)?.id == c.id) {
                            ref.read(activeChapterProvider.notifier).clear();
                          }
                        },
                      ),
                      onTap: () {
                        ref.read(activeChapterProvider.notifier).set(c);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton.icon(
                  onPressed: () => _createChapter(context),
                  icon: const Icon(Icons.add),
                  label: const Text('New Chapter'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createChapter(BuildContext context) async {
    final ctrl = TextEditingController();
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Chapter'),
        content: TextField(controller: ctrl, autofocus: true, decoration: const InputDecoration(labelText: 'Title')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              if (ctrl.text.trim().isNotEmpty) {
                final chapter = await ref.read(chapterListProvider.notifier).createChapter(ctrl.text.trim());
                ref.read(activeChapterProvider.notifier).set(chapter);
                if (mounted) Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
```

**Step 2: Run the app and verify**

```bash
cd android && flutter run
```

Expected:
- Draft tab → open drawer to create/select chapters
- Editor allows writing; changes persist on returning to chapter
- Preview mode renders markdown
- Focus mode hides app bar; tap FAB to exit
- Reference button opens drawer with Characters/Locations/Events tabs and pinning

**Step 3: Commit**

```bash
git add android/lib/features/draft/
git commit -m "feat(android): draft editor with chapter drawer, focus mode, preview, and reference sidebar"
```
