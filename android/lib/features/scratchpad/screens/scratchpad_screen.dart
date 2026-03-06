import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/note_providers.dart';
import '../../../core/providers/active_story_provider.dart';
import '../../../domain/models/note.dart';

class ScratchpadScreen extends ConsumerStatefulWidget {
  const ScratchpadScreen({super.key});
  @override
  ConsumerState<ScratchpadScreen> createState() => _State();
}

class _State extends ConsumerState<ScratchpadScreen> {
  final _quickAddCtrl = TextEditingController();

  @override
  void dispose() {
    _quickAddCtrl.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final text = _quickAddCtrl.text.trim();
    if (text.isEmpty) return;
    final storyId = ref.read(activeStoryProvider)?.id;
    if (storyId == null) return;
    await ref.read(noteListProvider.notifier).add(storyId, text);
    _quickAddCtrl.clear();
  }

  List<Widget> _buildActions(BuildContext context, WidgetRef ref) {
    return [
      IconButton(
        icon: const Icon(Icons.settings),
        tooltip: 'Settings',
        onPressed: () => context.push('/settings'),
      ),
      IconButton(
        icon: const Icon(Icons.library_books),
        tooltip: 'Switch Project',
        onPressed: () {
          ref.read(activeStoryProvider.notifier).clear();
          context.go('/projects');
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final notesAsync = ref.watch(noteListProvider);
    final hasStory = ref.watch(activeStoryProvider) != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scratchpad'),
        actions: _buildActions(context, ref),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _quickAddCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Quick note…',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _add(),
                    enabled: hasStory,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: hasStory ? _add : null,
                  icon: const Icon(Icons.add),
                  tooltip: 'Add note',
                ),
              ],
            ),
          ),
          if (!hasStory)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Select a story from Dashboard to add notes.'),
            ),
          Expanded(
            child: notesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (notes) {
                final activeFilter = ref.watch(noteFilterProvider);
                final filteredNotes = activeFilter == null
                    ? notes
                    : notes.where((n) => n.label == activeFilter).toList();

                // Get all unique labels to show in chips
                final allLabels = notes
                    .map((n) => n.label)
                    .whereType<String>()
                    .toSet()
                    .toList()
                  ..sort();

                return Column(
                  children: [
                    if (allLabels.isNotEmpty)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            ChoiceChip(
                              label: const Text('All'),
                              selected: activeFilter == null,
                              onSelected: (_) => ref
                                  .read(noteFilterProvider.notifier)
                                  .setFilter(null),
                            ),
                            const SizedBox(width: 8),
                            ...allLabels.map((label) => Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: ChoiceChip(
                                    label: Text(label),
                                    selected: activeFilter == label,
                                    onSelected: (_) => ref
                                        .read(noteFilterProvider.notifier)
                                        .setFilter(label),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    Expanded(
                      child: filteredNotes.isEmpty
                          ? const Center(
                              child: Text('No notes found.'),
                            )
                          : ReorderableListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                              itemCount: filteredNotes.length,
                              onReorder: (oldIndex, newIndex) {
                                // If filtered, we shouldn't really reorder directly, or we can find original indices
                                // For simplicity, if we are filtered, disable reordering or map it back.
                                // Best to only reorder when 'All' is selected.
                                if (activeFilter != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Clear filter to reorder notes.')));
                                  return;
                                }
                                ref
                                    .read(noteListProvider.notifier)
                                    .reorderNotes(oldIndex, newIndex);
                              },
                              itemBuilder: (context, index) {
                                final n = filteredNotes[index];
                                return Padding(
                                  key: ValueKey(n.id),
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: _NoteListTile(note: n),
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NoteListTile extends ConsumerStatefulWidget {
  final Note note;
  const _NoteListTile({required this.note});

  @override
  ConsumerState<_NoteListTile> createState() => _NoteListTileState();
}

class _NoteListTileState extends ConsumerState<_NoteListTile> {
  bool _editing = false;
  late final TextEditingController _ctrl;
  final List<String> _suggestedLabels = [
    'Idea',
    'Draft',
    'Todo',
    'Research',
    'Plot point',
    'Character'
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.note.content);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final updated = widget.note.copyWith(content: _ctrl.text);
    await ref.read(noteListProvider.notifier).updateNote(updated);
    setState(() => _editing = false);
  }

  Future<void> _setLabel(String? label) async {
    final updated = widget.note.copyWith(label: label);
    await ref.read(noteListProvider.notifier).updateNote(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context)
              .colorScheme
              .outlineVariant
              .withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_editing) ...[
              TextField(
                controller: _ctrl,
                maxLines: null,
                autofocus: true,
                decoration: const InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => setState(() => _editing = false),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.tonal(
                      onPressed: _save, child: const Text('Save')),
                ],
              ),
            ] else ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.drag_indicator,
                      color: Colors.grey, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _editing = true),
                      child: Text(
                        widget.note.content,
                        style: const TextStyle(fontSize: 15, height: 1.4),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const SizedBox(width: 28), // align with text
                  if (widget.note.label != null)
                    InputChip(
                      label: Text(widget.note.label!),
                      onDeleted: () => _setLabel(null),
                      visualDensity: VisualDensity.compact,
                    )
                  else
                    PopupMenuButton<String>(
                      tooltip: 'Add Label',
                      icon: const Icon(Icons.label_outline, size: 18),
                      onSelected: _setLabel,
                      itemBuilder: (context) => _suggestedLabels
                          .map((l) => PopupMenuItem(value: l, child: Text(l)))
                          .toList(),
                    ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18),
                    tooltip: 'Delete Note',
                    onPressed: () => ref
                        .read(noteListProvider.notifier)
                        .delete(widget.note.id),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
