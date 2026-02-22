import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../dashboard/providers/story_providers.dart';
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

  @override
  Widget build(BuildContext context) {
    final notesAsync = ref.watch(noteListProvider);
    final hasStory = ref.watch(activeStoryProvider) != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Scratchpad')),
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
                if (notes.isEmpty) {
                  return const Center(
                    child: Text('No notes yet. Add one above!'),
                  );
                }
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: notes.map((n) => _NoteCard(note: n)).toList(),
                  ),
                );
              },
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
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final updated = widget.note.copyWith(content: _ctrl.text);
    await ref.read(noteListProvider.notifier).update(updated);
    setState(() => _editing = false);
  }

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.of(context).size.width - 48) / 2;
    return SizedBox(
      width: width.clamp(140, 220),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
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
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => setState(() => _editing = false),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 4),
                    FilledButton(onPressed: _save, child: const Text('Save')),
                  ],
                ),
              ] else ...[
                GestureDetector(
                  onTap: () => setState(() => _editing = true),
                  child: Text(widget.note.content),
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () =>
                        ref.read(noteListProvider.notifier).delete(widget.note.id),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
