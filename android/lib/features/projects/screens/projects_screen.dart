import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/active_story_provider.dart';
import '../widgets/project_card.dart';

import '../../../data/sync/sync_service.dart';

class ProjectsScreen extends ConsumerStatefulWidget {
  const ProjectsScreen({super.key});

  @override
  ConsumerState<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends ConsumerState<ProjectsScreen> {
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _performSync();
    });
  }

  Future<void> _performSync() async {
    if (_isSyncing) return;
    setState(() => _isSyncing = true);
    try {
      await ref.read(syncServiceProvider).pullAllStories();
      // Invalidate so the UI picks up any newly-pulled stories.
      ref.invalidate(storyListProvider);
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final stories = ref.watch(storyListProvider);
    final active = ref.watch(activeStoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        actions: [
          IconButton(
            icon: _isSyncing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.sync),
            tooltip: 'Sync with Backend',
            onPressed: _isSyncing ? null : _performSync,
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Select a project to continue writing, or tap + to create a new one.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: stories.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (list) => list.isEmpty
                  ? const Center(
                      child: Text('No projects yet. Tap + to create one.'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: list.length,
                      itemBuilder: (ctx, i) => ProjectCard(
                        story: list[i],
                        isActive: list[i].id == active?.id,
                        onTap: () {
                          final story = list[i];
                          ref.read(activeStoryProvider.notifier).set(story);
                          // Pull child entities in background when going online.
                          ref
                              .read(syncServiceProvider)
                              .pullStoryData(story.id)
                              .ignore();
                          context.go('/scratchpad');
                        },
                        onDelete: () => _confirmDelete(ctx, ref, list[i].id),
                      ),
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreate(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showCreate(BuildContext context, WidgetRef ref) async {
    final ctrl = TextEditingController();
    try {
      await showDialog(
        context: context,
        builder: (dialogCtx) => AlertDialog(
          title: const Text('New Story'),
          content: TextField(
              controller: ctrl,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Title')),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(dialogCtx),
                child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                if (ctrl.text.trim().isNotEmpty) {
                  ref
                      .read(storyListProvider.notifier)
                      .createStory(ctrl.text.trim());
                  Navigator.pop(dialogCtx);
                }
              },
              child: const Text('Create'),
            ),
          ],
        ),
      );
    } finally {
      ctrl.dispose();
    }
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Delete story?'),
        content: const Text(
            'This will delete all characters, locations, events, and chapters.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              ref.read(storyListProvider.notifier).deleteStory(id);
              Navigator.pop(dialogCtx);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
