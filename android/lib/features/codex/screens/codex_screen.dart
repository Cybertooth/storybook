import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/active_story_provider.dart';
import '../providers/character_providers.dart';
import '../widgets/character_card.dart';
import 'character_detail_screen.dart';
import '../../locations/screens/location_list_screen.dart';

class CodexScreen extends ConsumerWidget {
  const CodexScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activeStoryProvider);
    if (active == null) {
      return const Scaffold(
          body:
              Center(child: Text('Select a story from the Dashboard first.')));
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(active.title),
          bottom: const TabBar(
              tabs: [Tab(text: 'Characters'), Tab(text: 'Locations')]),
        ),
        body: const TabBarView(
            children: [_CharactersTab(), LocationListScreen()]),
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
                  onTap: () => Navigator.push(
                      ctx,
                      MaterialPageRoute(
                        builder: (_) =>
                            CharacterDetailScreen(character: list[i]),
                      )),
                  onDelete: () => ref
                      .read(characterListProvider.notifier)
                      .deleteCharacter(list[i].id),
                ),
              ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: FloatingActionButton(
            heroTag: 'codex_add',
            onPressed: () => _showAddDialog(context, ref),
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('New Character'),
        content: TextField(
            controller: ctrl,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Name')),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                ref
                    .read(characterListProvider.notifier)
                    .createCharacter(ctrl.text.trim());
                Navigator.pop(dialogCtx);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
