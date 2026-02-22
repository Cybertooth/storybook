import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/ai_provider.dart';
import '../widgets/ai_no_key_banner.dart';

class SeedExpanderScreen extends ConsumerStatefulWidget {
  const SeedExpanderScreen({super.key});
  @override
  ConsumerState<SeedExpanderScreen> createState() => _State();
}

class _State extends ConsumerState<SeedExpanderScreen> {
  final _ctrl = TextEditingController();
  List<String> _suggestions = [];
  bool _loading = false;
  String? _error;

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  Future<void> _expand() async {
    final ai = ref.read(aiServiceProvider);
    if (ai == null) return;
    setState(() { _loading = true; _suggestions = []; _error = null; });
    try {
      final results = await ai.suggestContinuations(_ctrl.text);
      setState(() => _suggestions = results);
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
      appBar: AppBar(title: const Text('Seed Expander')),
      body: Column(
        children: [
          if (!hasKey) const AiNoKeyBanner(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextField(
                  controller: _ctrl,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Your story seed or idea',
                    hintText: 'e.g. A detective discovers the murderer is their own future self...',
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: (hasKey && !_loading && _ctrl.text.isNotEmpty) ? _expand : null,
                  icon: _loading
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.auto_awesome),
                  label: const Text('Expand Seed'),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text('Error: $_error', style: const TextStyle(color: Colors.red)),
                ],
                const SizedBox(height: 16),
                ..._suggestions.asMap().entries.map((e) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Option ${e.key + 1}', style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        )),
                        const SizedBox(height: 6),
                        SelectableText(e.value),
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
