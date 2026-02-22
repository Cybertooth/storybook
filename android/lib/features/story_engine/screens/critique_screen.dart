import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/ai_provider.dart';
import '../widgets/ai_no_key_banner.dart';

class CritiqueScreen extends ConsumerStatefulWidget {
  const CritiqueScreen({super.key});
  @override
  ConsumerState<CritiqueScreen> createState() => _State();
}

class _State extends ConsumerState<CritiqueScreen> {
  final _draftCtrl = TextEditingController();
  List<Map<String, dynamic>> _critiques = [];
  Set<int> _selected = {};
  String? _revision;
  bool _loading = false;
  String? _error;

  @override
  void dispose() { _draftCtrl.dispose(); super.dispose(); }

  Color _severityColor(String sev) => switch (sev) {
    'Major' => Colors.red,
    'Medium' => Colors.orange,
    _ => Colors.amber,
  };

  Future<void> _critique() async {
    final ai = ref.read(aiServiceProvider);
    if (ai == null) return;
    setState(() { _loading = true; _critiques = []; _selected = {}; _revision = null; _error = null; });
    try {
      final results = await ai.critique(_draftCtrl.text, '');
      setState(() => _critiques = results);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _revise() async {
    final ai = ref.read(aiServiceProvider);
    if (ai == null || _selected.isEmpty) return;
    final selected = _selected.map((i) => _critiques[i]['text'] as String).toList();
    setState(() { _loading = true; _revision = null; _error = null; });
    try {
      final result = await ai.reviseDraft(_draftCtrl.text, selected);
      setState(() => _revision = result);
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
      appBar: AppBar(title: const Text('AI Critique')),
      body: Column(
        children: [
          if (!hasKey) const AiNoKeyBanner(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextField(
                  controller: _draftCtrl,
                  maxLines: 6,
                  decoration: const InputDecoration(labelText: 'Paste your draft here'),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: (hasKey && !_loading && _draftCtrl.text.isNotEmpty) ? _critique : null,
                  child: const Text('Analyse Draft'),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 8),
                  Text('Error: $_error', style: const TextStyle(color: Colors.red)),
                ],
                if (_critiques.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text('Critiques (select to include in revision):',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ..._critiques.asMap().entries.map((e) => CheckboxListTile(
                    title: Text(e.value['text'] ?? ''),
                    subtitle: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _severityColor(e.value['severity'] ?? '').withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(e.value['severity'] ?? '',
                          style: TextStyle(color: _severityColor(e.value['severity'] ?? ''), fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                    value: _selected.contains(e.key),
                    onChanged: (v) => setState(() {
                      if (v == true) _selected.add(e.key); else _selected.remove(e.key);
                    }),
                    contentPadding: EdgeInsets.zero,
                  )),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: (hasKey && !_loading && _selected.isNotEmpty) ? _revise : null,
                    child: const Text('Revise Selected'),
                  ),
                ],
                if (_revision != null) ...[
                  const SizedBox(height: 16),
                  const Text('Revised Draft:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SelectableText(_revision!),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
