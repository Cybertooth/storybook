import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/ai_provider.dart';
import '../widgets/ai_no_key_banner.dart';

class ShowDontTellScreen extends ConsumerStatefulWidget {
  const ShowDontTellScreen({super.key});
  @override
  ConsumerState<ShowDontTellScreen> createState() => _State();
}

class _State extends ConsumerState<ShowDontTellScreen> {
  final _textCtrl = TextEditingController();
  List<Map<String, dynamic>> _results = [];
  bool _loading = false;
  String? _error;

  Future<void> _analyze() async {
    final ai = ref.read(aiServiceProvider);
    if (ai == null || _textCtrl.text.trim().isEmpty) return;

    setState(() {
      _loading = true;
      _results = [];
      _error = null;
    });
    final messenger = ScaffoldMessenger.of(context);
    try {
      final results = await ai.showDontTell(_textCtrl.text);
      setState(() => _results = results);
      if (results.isEmpty) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('No tell-heavy sentences found. Great job!'),
          ),
        );
      }
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
      appBar: AppBar(title: const Text('Show, Don\'t Tell')),
      body: Column(
        children: [
          if (!hasKey) const AiNoKeyBanner(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Paste prose below to identify "tell-heavy" sentences and get "showing" alternatives.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _textCtrl,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    hintText: 'e.g. He was very angry...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: (hasKey && !_loading) ? _analyze : null,
                  icon: _loading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.auto_awesome),
                  label: const Text('Find Tells'),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Error: $_error',
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
                const SizedBox(height: 16),
                ..._results.map(
                  (res) => Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Original (Telling):',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            res['original'] ?? '',
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                          const Divider(height: 16),
                          const Text(
                            'Suggestion (Showing):',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontSize: 12,
                            ),
                          ),
                          Text(res['suggestion'] ?? ''),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
