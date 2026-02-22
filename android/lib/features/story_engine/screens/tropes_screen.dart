import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/active_story_provider.dart';
import '../../../core/providers/ai_provider.dart';
import '../../../core/providers/repository_providers.dart';
import '../widgets/ai_no_key_banner.dart';

class TropesScreen extends ConsumerStatefulWidget {
  const TropesScreen({super.key});
  @override
  ConsumerState<TropesScreen> createState() => _State();
}

class _State extends ConsumerState<TropesScreen> {
  List<Map<String, dynamic>> _tropes = [];
  bool _loading = false;
  String? _error;

  Color _riskColor(String risk) => switch (risk) {
        'High' => Colors.red,
        'Medium' => Colors.orange,
        _ => Colors.green,
      };

  Future<void> _analyze() async {
    final ai = ref.read(aiServiceProvider);
    final story = ref.read(activeStoryProvider);
    if (ai == null || story == null) return;
    setState(() {
      _loading = true;
      _tropes = [];
      _error = null;
    });
    try {
      final events =
          await ref.read(plotEventRepositoryProvider).getAllForStory(story.id);
      final context =
          '${story.title}: ${story.summary}\nPlot: ${events.map((e) => e.title).join(', ')}';
      final results = await ai.analyzeTropes(context);
      setState(() => _tropes = results);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasKey = ref.watch(aiServiceProvider) != null;
    return Scaffold(
      appBar: AppBar(title: const Text('Tropes Analyzer')),
      body: Column(
        children: [
          if (!hasKey) const AiNoKeyBanner(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                FilledButton.icon(
                  onPressed: (hasKey && !_loading && ref.watch(activeStoryProvider) != null)
                      ? _analyze
                      : null,
                  icon: _loading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.analytics),
                  label: const Text('Analyze Story'),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 8),
                  Text('Error: $_error',
                      style: const TextStyle(color: Colors.red)),
                ],
                const SizedBox(height: 16),
                ..._tropes.map((t) => Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Expanded(
                                  child: Text(t['trope'] ?? '',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold))),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: _riskColor(t['risk'] ?? '')
                                      .withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(t['risk'] ?? '',
                                    style: TextStyle(
                                        color: _riskColor(t['risk'] ?? ''),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ]),
                            const SizedBox(height: 4),
                            Text(t['description'] ?? '',
                                style: const TextStyle(fontSize: 13)),
                            if (t['suggestion'] != null) ...[
                              const SizedBox(height: 6),
                              Text('💡 ${t['suggestion']}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary)),
                            ],
                          ],
                        ),
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
