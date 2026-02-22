import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/active_story_provider.dart';
import '../../../core/providers/ai_provider.dart';
import '../../../core/providers/repository_providers.dart';
import '../widgets/ai_no_key_banner.dart';

class PlotHoleScreen extends ConsumerStatefulWidget {
  const PlotHoleScreen({super.key});
  @override
  ConsumerState<PlotHoleScreen> createState() => _State();
}

class _State extends ConsumerState<PlotHoleScreen> {
  List<Map<String, dynamic>> _issues = [];
  bool _loading = false;
  String? _error;

  Future<void> _check() async {
    final ai = ref.read(aiServiceProvider);
    final story = ref.read(activeStoryProvider);
    if (ai == null || story == null) return;

    setState(() { _loading = true; _issues = []; _error = null; });
    try {
      final characters = await ref.read(characterRepositoryProvider).getAllForStory(story.id);
      final events = await ref.read(plotEventRepositoryProvider).getAllForStory(story.id);
      final context = '''Story: ${story.title}
Summary: ${story.summary}
Characters: ${characters.map((c) => '${c.name} (${c.role.name})').join(', ')}
Plot events: ${events.map((e) => e.title).join(' → ')}''';
      final results = await ai.checkPlotHoles(context);
      setState(() => _issues = results);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasKey = ref.watch(aiServiceProvider) != null;
    final story = ref.watch(activeStoryProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Plot Hole Checker')),
      body: Column(
        children: [
          if (!hasKey) const AiNoKeyBanner(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(story != null ? 'Story: ${story.title}' : 'No story selected.',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: (hasKey && !_loading && story != null) ? _check : null,
                  icon: _loading
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.search),
                  label: const Text('Check for Plot Holes'),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 8),
                  Text('Error: $_error', style: const TextStyle(color: Colors.red)),
                ],
                const SizedBox(height: 16),
                ..._issues.map((issue) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Icon(
                      issue['severity'] == 'Major' ? Icons.warning : Icons.info_outline,
                      color: issue['severity'] == 'Major' ? Colors.red : Colors.orange,
                    ),
                    title: Text(issue['issue'] ?? ''),
                    subtitle: Text(issue['suggestion'] ?? '', style: const TextStyle(fontSize: 12)),
                    isThreeLine: true,
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
