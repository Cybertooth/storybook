# Android Phase 3: Dashboard + Codex (Characters & Locations)

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Implement the Dashboard (story list, stats, active story switching) and the Codex tab (Characters with arc tracking + Locations with sensory fields).

**Architecture:** Riverpod `AsyncNotifier` providers per feature, consuming repository providers from Phase 2. Each feature has `providers/`, `screens/`, `widgets/` sub-folders.

**Tech Stack:** Riverpod, go_router, Flutter widgets

**Depends on:** Phase 2 complete (all repositories available).
**Next phase:** `2026-02-21-android-phase-4-timeline.md`

---

## Task 1: Active Story Provider

**Files:**
- Create: `android/lib/core/providers/active_story_provider.dart`

**Step 1: Write the provider**

`android/lib/core/providers/active_story_provider.dart`:

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/story.dart';
import '../../domain/repositories/story_repository.dart';
import 'repository_providers.dart';

part 'active_story_provider.g.dart';

@riverpod
class StoryList extends _$StoryList {
  @override
  Future<List<Story>> build() async {
    return ref.watch(storyRepositoryProvider).getAll();
  }

  Future<void> createStory(String title) async {
    await ref.read(storyRepositoryProvider).create(title);
    ref.invalidateSelf();
  }

  Future<void> deleteStory(String id) async {
    await ref.read(storyRepositoryProvider).delete(id);
    ref.invalidateSelf();
    if (ref.read(activeStoryProvider)?.id == id) {
      ref.read(activeStoryProvider.notifier).clear();
    }
  }
}

@riverpod
class ActiveStory extends _$ActiveStory {
  @override
  Story? build() => null;

  void set(Story story) => state = story;
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
git add android/lib/core/providers/active_story_provider.dart
git commit -m "feat(android): active story and story list providers"
```

---

## Task 2: Dashboard Screen

**Files:**
- Create: `android/lib/features/dashboard/screens/dashboard_screen.dart` (replace stub)
- Create: `android/lib/features/dashboard/widgets/story_card.dart`

**Step 1: StoryCard widget**

`android/lib/features/dashboard/widgets/story_card.dart`:

```dart
import 'package:flutter/material.dart';
import '../../../domain/models/story.dart';

class StoryCard extends StatelessWidget {
  final Story story;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const StoryCard({
    super.key,
    required this.story,
    required this.isActive,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      color: isActive ? cs.primaryContainer : null,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(story.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: story.summary.isNotEmpty ? Text(story.summary, maxLines: 2, overflow: TextOverflow.ellipsis) : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isActive) Icon(Icons.check_circle, color: cs.primary),
            IconButton(icon: const Icon(Icons.delete_outline), onPressed: onDelete),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
```

**Step 2: Dashboard screen**

`android/lib/features/dashboard/screens/dashboard_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/active_story_provider.dart';
import '../widgets/story_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stories = ref.watch(storyListProvider);
    final active = ref.watch(activeStoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Stories')),
      body: stories.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (list) => list.isEmpty
            ? const Center(child: Text('No stories yet. Tap + to create one.'))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                itemBuilder: (ctx, i) => StoryCard(
                  story: list[i],
                  isActive: list[i].id == active?.id,
                  onTap: () => ref.read(activeStoryProvider.notifier).set(list[i]),
                  onDelete: () => _confirmDelete(ctx, ref, list[i].id),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreate(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreate(BuildContext context, WidgetRef ref) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Story'),
        content: TextField(controller: ctrl, autofocus: true, decoration: const InputDecoration(labelText: 'Title')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                ref.read(storyListProvider.notifier).createStory(ctrl.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete story?'),
        content: const Text('This will delete all characters, locations, events, and chapters.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              ref.read(storyListProvider.notifier).deleteStory(id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
```

**Step 3: Run the app and verify**

```bash
cd android && flutter run
```

Expected: Dashboard shows story list. FAB creates stories. Tap a story → it becomes active (check icon). Delete shows confirmation.

**Step 4: Commit**

```bash
git add android/lib/features/dashboard/
git commit -m "feat(android): dashboard with story list, create, delete, and active selection"
```

---

## Task 3: Characters Feature

**Files:**
- Create: `android/lib/features/codex/providers/character_providers.dart`
- Create: `android/lib/features/codex/screens/codex_screen.dart` (replace stub)
- Create: `android/lib/features/codex/screens/character_detail_screen.dart`
- Create: `android/lib/features/codex/widgets/character_card.dart`

**Step 1: Character providers**

`android/lib/features/codex/providers/character_providers.dart`:

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/active_story_provider.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../domain/models/character.dart';

part 'character_providers.g.dart';

@riverpod
class CharacterList extends _$CharacterList {
  @override
  Future<List<Character>> build() async {
    final story = ref.watch(activeStoryProvider);
    if (story == null) return [];
    return ref.watch(characterRepositoryProvider).getAllForStory(story.id);
  }

  Future<void> createCharacter(String name) async {
    final story = ref.read(activeStoryProvider);
    if (story == null) return;
    final character = Character(id: const Uuid().v4(), storyId: story.id, name: name);
    await ref.read(characterRepositoryProvider).create(character);
    ref.invalidateSelf();
  }

  Future<void> updateCharacter(Character character) async {
    await ref.read(characterRepositoryProvider).update(character);
    ref.invalidateSelf();
  }

  Future<void> deleteCharacter(String id) async {
    await ref.read(characterRepositoryProvider).delete(id);
    ref.invalidateSelf();
  }
}
```

**Step 2: Run code generation**

```bash
cd android
dart run build_runner build --delete-conflicting-outputs
```

**Step 3: CharacterCard widget**

`android/lib/features/codex/widgets/character_card.dart`:

```dart
import 'package:flutter/material.dart';
import '../../../domain/models/character.dart';

class CharacterCard extends StatelessWidget {
  final Character character;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const CharacterCard({super.key, required this.character, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(child: Text(character.name[0].toUpperCase())),
        title: Text(character.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(character.role.name),
        trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: onDelete),
        onTap: onTap,
      ),
    );
  }
}
```

**Step 4: Character detail screen**

`android/lib/features/codex/screens/character_detail_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/character.dart';
import '../providers/character_providers.dart';

class CharacterDetailScreen extends ConsumerStatefulWidget {
  final Character character;
  const CharacterDetailScreen({super.key, required this.character});

  @override
  ConsumerState<CharacterDetailScreen> createState() => _State();
}

class _State extends ConsumerState<CharacterDetailScreen> {
  late Character _char;
  late final TextEditingController _name, _desc, _arcLie, _arcTruth, _arcGhost;

  @override
  void initState() {
    super.initState();
    _char = widget.character;
    _name = TextEditingController(text: _char.name);
    _desc = TextEditingController(text: _char.description);
    _arcLie = TextEditingController(text: _char.arcLie ?? '');
    _arcTruth = TextEditingController(text: _char.arcTruth ?? '');
    _arcGhost = TextEditingController(text: _char.arcGhost ?? '');
  }

  @override
  void dispose() {
    _name.dispose(); _desc.dispose(); _arcLie.dispose(); _arcTruth.dispose(); _arcGhost.dispose();
    super.dispose();
  }

  void _save() {
    ref.read(characterListProvider.notifier).updateCharacter(_char.copyWith(
      name: _name.text, description: _desc.text,
      arcLie: _arcLie.text.isEmpty ? null : _arcLie.text,
      arcTruth: _arcTruth.text.isEmpty ? null : _arcTruth.text,
      arcGhost: _arcGhost.text.isEmpty ? null : _arcGhost.text,
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Character'),
        actions: [IconButton(onPressed: _save, icon: const Icon(Icons.save))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: _name, decoration: const InputDecoration(labelText: 'Name')),
          const SizedBox(height: 12),
          DropdownButtonFormField<CharacterRole>(
            value: _char.role,
            items: CharacterRole.values
                .map((r) => DropdownMenuItem(value: r, child: Text(r.name)))
                .toList(),
            onChanged: (r) => setState(() => _char = _char.copyWith(role: r!)),
            decoration: const InputDecoration(labelText: 'Role'),
          ),
          const SizedBox(height: 12),
          TextField(controller: _desc, decoration: const InputDecoration(labelText: 'Description'), maxLines: 4),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text('Character Arc', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          TextField(controller: _arcLie, decoration: const InputDecoration(labelText: 'The Lie (flaw)')),
          const SizedBox(height: 12),
          TextField(controller: _arcTruth, decoration: const InputDecoration(labelText: 'The Truth (growth)')),
          const SizedBox(height: 12),
          TextField(controller: _arcGhost, decoration: const InputDecoration(labelText: 'The Ghost (backstory wound)')),
        ],
      ),
    );
  }
}
```

**Step 5: Codex screen (Characters tab portion)**

`android/lib/features/codex/screens/codex_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/active_story_provider.dart';
import '../providers/character_providers.dart';
import '../widgets/character_card.dart';
import 'character_detail_screen.dart';
import '../../locations/screens/location_list_screen.dart'; // created in Task 4

class CodexScreen extends ConsumerWidget {
  const CodexScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activeStoryProvider);
    if (active == null) {
      return const Scaffold(body: Center(child: Text('Select a story from the Dashboard first.')));
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(active.title),
          bottom: const TabBar(tabs: [Tab(text: 'Characters'), Tab(text: 'Locations')]),
        ),
        body: const TabBarView(children: [_CharactersTab(), LocationListScreen()]),
      ),
    );
  }
}

class _CharactersTab extends ConsumerWidget {
  const _CharactersTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chars = ref.watch(characterListProvider);
    return chars.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (list) => Scaffold(
        body: list.isEmpty
            ? const Center(child: Text('No characters yet.'))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                itemBuilder: (ctx, i) => CharacterCard(
                  character: list[i],
                  onTap: () => Navigator.push(ctx, MaterialPageRoute(
                    builder: (_) => CharacterDetailScreen(character: list[i]),
                  )),
                  onDelete: () => ref.read(characterListProvider.notifier).deleteCharacter(list[i].id),
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showCreate(context, ref),
          child: const Icon(Icons.person_add),
        ),
      ),
    );
  }

  void _showCreate(BuildContext context, WidgetRef ref) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Character'),
        content: TextField(controller: ctrl, autofocus: true, decoration: const InputDecoration(labelText: 'Name')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                ref.read(characterListProvider.notifier).createCharacter(ctrl.text.trim());
                Navigator.pop(context);
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

**Step 6: Commit**

```bash
git add android/lib/features/codex/
git commit -m "feat(android): characters list and detail with arc tracking"
```

---

## Task 4: Locations Feature

**Files:**
- Create: `android/lib/features/locations/providers/location_providers.dart`
- Create: `android/lib/features/locations/screens/location_list_screen.dart`
- Create: `android/lib/features/locations/screens/location_detail_screen.dart`

**Step 1: Location providers**

`android/lib/features/locations/providers/location_providers.dart`:

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/active_story_provider.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../domain/models/location.dart';

part 'location_providers.g.dart';

@riverpod
class LocationList extends _$LocationList {
  @override
  Future<List<Location>> build() async {
    final story = ref.watch(activeStoryProvider);
    if (story == null) return [];
    return ref.watch(locationRepositoryProvider).getAllForStory(story.id);
  }

  Future<void> createLocation(String name) async {
    final story = ref.read(activeStoryProvider);
    if (story == null) return;
    final location = Location(id: const Uuid().v4(), storyId: story.id, name: name);
    await ref.read(locationRepositoryProvider).create(location);
    ref.invalidateSelf();
  }

  Future<void> updateLocation(Location location) async {
    await ref.read(locationRepositoryProvider).update(location);
    ref.invalidateSelf();
  }

  Future<void> deleteLocation(String id) async {
    await ref.read(locationRepositoryProvider).delete(id);
    ref.invalidateSelf();
  }
}
```

**Step 2: Location list screen**

`android/lib/features/locations/screens/location_list_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/location_providers.dart';
import 'location_detail_screen.dart';

class LocationListScreen extends ConsumerWidget {
  const LocationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locs = ref.watch(locationListProvider);
    return locs.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (list) => Scaffold(
        body: list.isEmpty
            ? const Center(child: Text('No locations yet.'))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                itemBuilder: (ctx, i) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.place),
                    title: Text(list[i].name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: list[i].description.isNotEmpty ? Text(list[i].description, maxLines: 1) : null,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => ref.read(locationListProvider.notifier).deleteLocation(list[i].id),
                    ),
                    onTap: () => Navigator.push(ctx, MaterialPageRoute(
                      builder: (_) => LocationDetailScreen(location: list[i]),
                    )),
                  ),
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showCreate(context, ref),
          child: const Icon(Icons.add_location),
        ),
      ),
    );
  }

  void _showCreate(BuildContext context, WidgetRef ref) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Location'),
        content: TextField(controller: ctrl, autofocus: true, decoration: const InputDecoration(labelText: 'Name')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                ref.read(locationListProvider.notifier).createLocation(ctrl.text.trim());
                Navigator.pop(context);
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

**Step 3: Location detail screen (with sensory fields)**

`android/lib/features/locations/screens/location_detail_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/location.dart';
import '../providers/location_providers.dart';

class LocationDetailScreen extends ConsumerStatefulWidget {
  final Location location;
  const LocationDetailScreen({super.key, required this.location});

  @override
  ConsumerState<LocationDetailScreen> createState() => _State();
}

class _State extends ConsumerState<LocationDetailScreen> {
  late final TextEditingController _name, _desc, _sight, _sound, _smell, _touch, _taste;

  @override
  void initState() {
    super.initState();
    final l = widget.location;
    _name = TextEditingController(text: l.name);
    _desc = TextEditingController(text: l.description);
    _sight = TextEditingController(text: l.sensorySight ?? '');
    _sound = TextEditingController(text: l.sensorySound ?? '');
    _smell = TextEditingController(text: l.sensorySmell ?? '');
    _touch = TextEditingController(text: l.sensoryTouch ?? '');
    _taste = TextEditingController(text: l.sensoryTaste ?? '');
  }

  @override
  void dispose() {
    _name.dispose(); _desc.dispose(); _sight.dispose(); _sound.dispose();
    _smell.dispose(); _touch.dispose(); _taste.dispose();
    super.dispose();
  }

  void _save() {
    ref.read(locationListProvider.notifier).updateLocation(widget.location.copyWith(
      name: _name.text, description: _desc.text,
      sensorySight: _sight.text.isEmpty ? null : _sight.text,
      sensorySound: _sound.text.isEmpty ? null : _sound.text,
      sensorySmell: _smell.text.isEmpty ? null : _smell.text,
      sensoryTouch: _touch.text.isEmpty ? null : _touch.text,
      sensoryTaste: _taste.text.isEmpty ? null : _taste.text,
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
        actions: [IconButton(onPressed: _save, icon: const Icon(Icons.save))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: _name, decoration: const InputDecoration(labelText: 'Name')),
          const SizedBox(height: 12),
          TextField(controller: _desc, decoration: const InputDecoration(labelText: 'Description'), maxLines: 4),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text('Sensory Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          for (final (ctrl, label) in [
            (_sight, '👁 Sight'), (_sound, '👂 Sound'), (_smell, '👃 Smell'),
            (_touch, '🖐 Touch'), (_taste, '👅 Taste'),
          ]) ...[
            TextField(controller: ctrl, decoration: InputDecoration(labelText: label), maxLines: 2),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}
```

**Step 4: Run code generation and verify**

```bash
cd android
dart run build_runner build --delete-conflicting-outputs
flutter run
```

Expected: Codex tab shows Characters and Locations tabs. Both support create/edit/delete. Location detail shows 5 sensory fields.

**Step 5: Commit**

```bash
git add android/lib/features/locations/ android/lib/features/codex/
git commit -m "feat(android): locations list and detail with sensory fields; complete Codex tab"
```
