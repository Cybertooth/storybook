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
  final _geminiCtrl = TextEditingController();
  final _openAiCtrl = TextEditingController();
  bool _showGemini = false;
  bool _showOpenAi = false;
  bool _saving = false;

  @override
  void dispose() {
    _geminiCtrl.dispose();
    _openAiCtrl.dispose();
    super.dispose();
  }

  void _populate(AppSettings s) {
    if (_geminiCtrl.text.isEmpty) _geminiCtrl.text = s.geminiApiKey;
    if (_openAiCtrl.text.isEmpty) _openAiCtrl.text = s.openAiApiKey;
  }

  Future<void> _saveKeys() async {
    setState(() => _saving = true);
    await ref.read(settingsProvider.notifier).update(
          geminiKey: _geminiCtrl.text.trim(),
          openAiKey: _openAiCtrl.text.trim(),
        );
    setState(() => _saving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('API keys saved.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);
    final themeMode = ref.watch(appThemeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (settings) {
          _populate(settings);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ── Appearance ──────────────────────────────────────
              const _SectionHeader('Appearance'),
              SwitchListTile(
                title: const Text('Dark Mode'),
                value: themeMode == ThemeMode.dark,
                onChanged: (_) =>
                    ref.read(appThemeModeProvider.notifier).toggle(),
              ),
              const Divider(height: 24),

              // ── AI Provider ──────────────────────────────────────
              const _SectionHeader('AI Provider'),
              RadioListTile<String>(
                title: const Text('Gemini (Google)'),
                value: 'gemini',
                groupValue: settings.aiProvider,
                onChanged: (v) =>
                    ref.read(settingsProvider.notifier).update(provider: v),
              ),
              RadioListTile<String>(
                title: const Text('OpenAI'),
                value: 'openai',
                groupValue: settings.aiProvider,
                onChanged: (v) =>
                    ref.read(settingsProvider.notifier).update(provider: v),
              ),
              const Divider(height: 24),

              // ── API Keys ─────────────────────────────────────────
              const _SectionHeader('API Keys'),
              const SizedBox(height: 8),
              TextField(
                controller: _geminiCtrl,
                obscureText: !_showGemini,
                decoration: InputDecoration(
                  labelText: 'Gemini API Key',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_showGemini ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _showGemini = !_showGemini),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _openAiCtrl,
                obscureText: !_showOpenAi,
                decoration: InputDecoration(
                  labelText: 'OpenAI API Key',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_showOpenAi ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _showOpenAi = !_showOpenAi),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _saving ? null : _saveKeys,
                child: _saving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Save API Keys'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader(this.label);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
}
