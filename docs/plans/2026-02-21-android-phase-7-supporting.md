# Android Phase 7: Supporting Features (Scratchpad, Questions, Settings, More)

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Implement the Scratchpad (masonry notes), Unresolved Questions global FAB panel, Settings screen (theme toggle + API key management), and wire the More tab to navigate to all three.

**Architecture:** Each feature follows the same Riverpod notifier → repository → screen pattern. The global FAB is added to `AppScaffold`. Settings writes to `SettingsNotifier` (Phase 6).

**Tech Stack:** Riverpod, flutter_secure_storage (already added in Phase 6)

**Depends on:** Phase 2 (note/question repositories), Phase 6 (settings provider).
**Next phase:** `2026-02-21-android-phase-8-polish.md`

---

## Task 1: Scratchpad

**Files:**
- Create: `android/lib/features/scratchpad/providers/note_providers.dart`
- Create: `android/lib/features/scratchpad/screens/scratchpad_screen.dart`

**Step 1: Note providers**

`android/lib/features/scratchpad/providers/note_providers.dart`:

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/active_story_provider.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../domain/models/note.dart';

part 'note_providers.g.dart';

@riverpod
class NoteList extends _$NoteList {
  @override
  Future<List<Note>> build() async {
    final story = ref.watch(activeStoryProvider);
    if (story == null) return [];
    final notes = await ref.watch(noteRepositoryProvider).getAllForStory(story.id);
    notes.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // newest first
    return notes;
  }

  Future<void> createNote(String content) async {
    final story = ref.read(activeStoryProvider);
    if (story == null) return;
    final note = Note(
      id: const Uuid().v4(),
      storyId: story.id,
      content: content,
      createdAt: DateTime.now(),
    );
    await ref.read(noteRepositoryProvider).create(note);
    ref.invalidateSelf();
  }

  Future<void> updateNote(Note note) async {
    await ref.read(noteRepositoryProvider).update(note);
    ref.invalidateSelf();
  }

  Future<void> deleteNote(String id) async {
    await ref.read(noteRepositoryProvider).delete(id);
    ref.invalidateSelf();
  }
}
```

**Step 2: Run code generation**

```bash
cd android
dart run build_runner build --delete-conflicting-outputs
```

**Step 3: Scratchpad screen**

`android/lib/features/scratchpad/screens/scratchpad_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/active_story_provider.dart';
import '../../../domain/models/note.dart';
import '../providers/note_providers.dart';

class ScratchpadScreen extends ConsumerStatefulWidget {
  const ScratchpadScreen({super.key});
  @override
  ConsumerState<ScratchpadScreen> createState() => _State();
}

class _State extends ConsumerState<ScratchpadScreen> {
  final _ctrl = TextEditingController();

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _add() {
    if (_ctrl.text.trim().isNotEmpty) {
      ref.read(noteListProvider.notifier).createNote(_ctrl.text.trim());
      _ctrl.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final story = ref.watch(activeStoryProvider);
    final notes = ref.watch(noteListProvider).valueOrNull ?? [];

    if (story == null) {
      return const Scaffold(
        appBar: null,
        body: Center(child: Text('Select a story from the Dashboard first.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Scratchpad')),
      body: Column(
        children: [
          // Quick-add bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    decoration: const InputDecoration(
                      hintText: 'Jot a quick thought, snippet, or idea...',
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onSubmitted: (_) => _add(),
                    textInputAction: TextInputAction.done,
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(onPressed: _add, child: const Icon(Icons.add)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Masonry-style notes grid using Wrap
          Expanded(
            child: notes.isEmpty
                ? const Center(child: Text('No notes yet. Jot something above.'))
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: notes.map((n) => _NoteCard(note: n)).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _NoteCard extends ConsumerStatefulWidget {
  final Note note;
  const _NoteCard({required this.note});

  @override
  ConsumerState<_NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends ConsumerState<_NoteCard> {
  bool _editing = false;
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.note.content);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    // Each card takes up roughly half the screen width
    final width = (MediaQuery.of(context).size.width - 36) / 2;
    return Container(
      width: width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_editing)
            TextField(
              controller: _ctrl,
              maxLines: null,
              decoration: const InputDecoration(border: InputBorder.none, isDense: true),
              autofocus: true,
              onSubmitted: (_) => _save(),
            )
          else
            GestureDetector(
              onTap: () => setState(() => _editing = true),
              child: Text(widget.note.content, style: const TextStyle(fontSize: 13)),
            ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (_editing)
                GestureDetector(
                  onTap: _save,
                  child: const Icon(Icons.check, size: 16),
                )
              else
                GestureDetector(
                  onTap: () => ref.read(noteListProvider.notifier).deleteNote(widget.note.id),
                  child: const Icon(Icons.delete_outline, size: 16),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _save() {
    if (_ctrl.text.trim().isNotEmpty) {
      ref.read(noteListProvider.notifier).updateNote(widget.note.copyWith(content: _ctrl.text.trim()));
    }
    setState(() => _editing = false);
  }
}
```

**Step 4: Commit**

```bash
git add android/lib/features/scratchpad/
git commit -m "feat(android): scratchpad with masonry notes, quick-add, and inline edit"
```

---

## Task 2: Unresolved Questions (Global FAB)

**Files:**
- Create: `android/lib/features/questions/providers/question_providers.dart`
- Create: `android/lib/features/questions/screens/questions_bottom_sheet.dart`
- Modify: `android/lib/shared/widgets/app_scaffold.dart`

**Step 1: Question providers**

`android/lib/features/questions/providers/question_providers.dart`:

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/active_story_provider.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../domain/models/unresolved_question.dart';

part 'question_providers.g.dart';

@riverpod
class QuestionList extends _$QuestionList {
  @override
  Future<List<UnresolvedQuestion>> build() async {
    final story = ref.watch(activeStoryProvider);
    if (story == null) return [];
    final questions = await ref.watch(questionRepositoryProvider).getAllForStory(story.id);
    questions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return questions;
  }

  Future<void> createQuestion(String question) async {
    final story = ref.read(activeStoryProvider);
    if (story == null) return;
    final q = UnresolvedQuestion(
      id: const Uuid().v4(),
      storyId: story.id,
      question: question,
      createdAt: DateTime.now(),
    );
    await ref.read(questionRepositoryProvider).create(q);
    ref.invalidateSelf();
  }

  Future<void> resolve(UnresolvedQuestion question, String answer) async {
    await ref.read(questionRepositoryProvider).update(
      question.copyWith(isResolved: true, answer: answer),
    );
    ref.invalidateSelf();
  }

  Future<void> deleteQuestion(String id) async {
    await ref.read(questionRepositoryProvider).delete(id);
    ref.invalidateSelf();
  }
}
```

**Step 2: Run code generation**

```bash
cd android
dart run build_runner build --delete-conflicting-outputs
```

**Step 3: Questions bottom sheet**

`android/lib/features/questions/screens/questions_bottom_sheet.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/active_story_provider.dart';
import '../../../domain/models/unresolved_question.dart';
import '../providers/question_providers.dart';

class QuestionsBottomSheet extends ConsumerStatefulWidget {
  const QuestionsBottomSheet({super.key});
  @override
  ConsumerState<QuestionsBottomSheet> createState() => _State();
}

class _State extends ConsumerState<QuestionsBottomSheet> {
  final _ctrl = TextEditingController();
  bool _showResolved = false;

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final story = ref.watch(activeStoryProvider);
    final questions = ref.watch(questionListProvider).valueOrNull ?? [];
    final open = questions.where((q) => !q.isResolved).toList();
    final resolved = questions.where((q) => q.isResolved).toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, controller) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: [
            // Drag handle + title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.help_outline),
                  const SizedBox(width: 8),
                  const Text('Unresolved Questions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const Spacer(),
                  Text('${open.length} open', style: TextStyle(color: Theme.of(context).colorScheme.outline)),
                ],
              ),
            ),
            const Divider(height: 1),
            // Quick-add
            if (story != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _ctrl,
                        decoration: const InputDecoration(
                          hintText: 'Log a mystery or required payoff...',
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        onSubmitted: (_) => _add(),
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(onPressed: _add, child: const Icon(Icons.add)),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            // List
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  if (open.isEmpty && story != null)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No open questions. Great!', textAlign: TextAlign.center),
                    ),
                  ...open.map((q) => _QuestionTile(question: q, onResolve: () => _showResolveDialog(context, q))),
                  if (resolved.isNotEmpty) ...[
                    const Divider(),
                    GestureDetector(
                      onTap: () => setState(() => _showResolved = !_showResolved),
                      child: Row(
                        children: [
                          const Icon(Icons.archive_outlined, size: 16),
                          const SizedBox(width: 4),
                          Text('${resolved.length} Resolved', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const Spacer(),
                          Icon(_showResolved ? Icons.expand_less : Icons.expand_more),
                        ],
                      ),
                    ),
                    if (_showResolved)
                      ...resolved.map((q) => _QuestionTile(question: q, onResolve: null)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _add() {
    if (_ctrl.text.trim().isNotEmpty) {
      ref.read(questionListProvider.notifier).createQuestion(_ctrl.text.trim());
      _ctrl.clear();
    }
  }

  void _showResolveDialog(BuildContext context, UnresolvedQuestion question) {
    final answerCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(question.question, style: const TextStyle(fontSize: 16)),
        content: TextField(
          controller: answerCtrl,
          autofocus: true,
          maxLines: 3,
          decoration: const InputDecoration(labelText: 'Answer / Resolution'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              ref.read(questionListProvider.notifier).resolve(question, answerCtrl.text);
              Navigator.pop(context);
            },
            child: const Text('Mark Resolved'),
          ),
        ],
      ),
    );
  }
}

class _QuestionTile extends ConsumerWidget {
  final UnresolvedQuestion question;
  final VoidCallback? onResolve;
  const _QuestionTile({required this.question, required this.onResolve});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        question.isResolved ? Icons.check_circle : Icons.radio_button_unchecked,
        color: question.isResolved ? Colors.green : null,
      ),
      title: Text(question.question,
          style: TextStyle(decoration: question.isResolved ? TextDecoration.lineThrough : null)),
      subtitle: question.answer != null ? Text('✓ ${question.answer}', style: const TextStyle(color: Colors.green, fontSize: 12)) : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onResolve != null)
            TextButton(onPressed: onResolve, child: const Text('Resolve')),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18),
            onPressed: () => ref.read(questionListProvider.notifier).deleteQuestion(question.id),
          ),
        ],
      ),
    );
  }
}
```

**Step 4: Add global FAB to AppScaffold**

Read the current content of `android/lib/shared/widgets/app_scaffold.dart`, then add a `floatingActionButton` to the `Scaffold`:

Modify the `build` method's return value. Change:

```dart
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
```

To:

```dart
    return Scaffold(
      body: child,
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => const QuestionsBottomSheet(),
        ),
        tooltip: 'Unresolved Questions',
        child: const Text('?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: NavigationBar(
```

Also add the import at the top of `app_scaffold.dart`:

```dart
import '../../features/questions/screens/questions_bottom_sheet.dart';
```

**Step 5: Run the app and verify**

```bash
cd android && flutter run
```

Expected: "?" FAB visible on all 5 tabs. Tapping opens the questions bottom sheet. Can add/resolve/delete questions.

**Step 6: Commit**

```bash
git add android/lib/features/questions/ android/lib/shared/widgets/app_scaffold.dart
git commit -m "feat(android): unresolved questions panel as global FAB accessible from all screens"
```

---

## Task 3: Settings Screen

**Files:**
- Create: `android/lib/features/settings/screens/settings_screen.dart`

**Step 1: Implement settings screen**

`android/lib/features/settings/screens/settings_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/providers/theme_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _State();
}

class _State extends ConsumerState<SettingsScreen> {
  late TextEditingController _geminiCtrl;
  late TextEditingController _openAiCtrl;
  bool _geminiObscured = true;
  bool _openAiObscured = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsProvider).valueOrNull;
    _geminiCtrl = TextEditingController(text: settings?.geminiApiKey ?? '');
    _openAiCtrl = TextEditingController(text: settings?.openAiApiKey ?? '');
  }

  @override
  void dispose() { _geminiCtrl.dispose(); _openAiCtrl.dispose(); super.dispose(); }

  Future<void> _saveKeys() async {
    setState(() => _saving = true);
    await ref.read(settingsProvider.notifier).update(
      geminiKey: _geminiCtrl.text,
      openAiKey: _openAiCtrl.text,
    );
    setState(() => _saving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('API keys saved.'), behavior: SnackBarBehavior.floating),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(appThemeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // — Theme —
          const _SectionHeader('Appearance'),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Use dark theme'),
            value: themeMode == ThemeMode.dark,
            onChanged: (_) => ref.read(appThemeModeProvider.notifier).toggle(),
          ),
          const Divider(),

          // — AI —
          const _SectionHeader('AI Configuration'),
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text('Your API keys are stored securely on-device and never transmitted except to the AI provider.',
                style: TextStyle(fontSize: 12)),
          ),
          TextField(
            controller: _geminiCtrl,
            obscureText: _geminiObscured,
            decoration: InputDecoration(
              labelText: 'Gemini API Key',
              hintText: 'AIza...',
              suffixIcon: IconButton(
                icon: Icon(_geminiObscured ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _geminiObscured = !_geminiObscured),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _openAiCtrl,
            obscureText: _openAiObscured,
            decoration: InputDecoration(
              labelText: 'OpenAI API Key (optional)',
              hintText: 'sk-...',
              suffixIcon: IconButton(
                icon: Icon(_openAiObscured ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _openAiObscured = !_openAiObscured),
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _saving ? null : _saveKeys,
            child: _saving
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Save API Keys'),
          ),
          const Divider(),

          // — Data —
          const _SectionHeader('Data Management'),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text('Export Backup (JSON)'),
            subtitle: const Text('Download the active story as a .json file'),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Export available in Phase 8.')),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Import Backup'),
            subtitle: const Text('Restore a story from a .json backup file'),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Import available in Phase 8.')),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
    );
  }
}
```

**Step 2: Commit**

```bash
git add android/lib/features/settings/
git commit -m "feat(android): settings screen with theme toggle and secure API key storage"
```

---

## Task 4: More Screen (Navigation Hub)

**Files:**
- Create: `android/lib/features/more/screens/more_screen.dart` (replace stub)

**Step 1: Implement more screen**

`android/lib/features/more/screens/more_screen.dart`:

```dart
import 'package:flutter/material.dart';
import '../../scratchpad/screens/scratchpad_screen.dart';
import '../../story_engine/screens/story_engine_screen.dart';
import '../../settings/screens/settings_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        icon: Icons.note_alt,
        label: 'Scratchpad',
        subtitle: 'Quick notes, snippets, and unformed ideas',
        screen: const ScratchpadScreen(),
      ),
      (
        icon: Icons.auto_fix_high,
        label: 'Story Engine',
        subtitle: 'AI-powered tools: seed expander, critique, plot analysis',
        screen: const StoryEngineScreen(),
      ),
      (
        icon: Icons.settings,
        label: 'Settings',
        subtitle: 'API keys, theme, data export/import',
        screen: const SettingsScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (ctx, i) {
          final item = items[i];
          return Card(
            child: ListTile(
              leading: CircleAvatar(child: Icon(item.icon)),
              title: Text(item.label, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(item.subtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => item.screen)),
            ),
          );
        },
      ),
    );
  }
}
```

**Step 2: Run the app and do a full navigation check**

```bash
cd android && flutter run
```

Verify:
- More tab → Scratchpad, Story Engine, Settings all navigate correctly
- Settings: toggle dark mode → app theme changes immediately
- Settings: enter Gemini API key → save → Story Engine → Seed Expander shows input (no banner)
- Questions FAB visible on every tab

**Step 3: Commit**

```bash
git add android/lib/features/more/
git commit -m "feat(android): More screen wiring Scratchpad, Story Engine, and Settings"
```
