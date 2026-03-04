import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/active_story_provider.dart';
import '../../../core/providers/export_provider.dart';
import '../../../core/providers/repository_providers.dart';
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
  bool _populated = false;

  @override
  void dispose() {
    _geminiCtrl.dispose();
    _openAiCtrl.dispose();
    super.dispose();
  }

  void _populate(AppSettings s) {
    if (!_populated) {
      _populated = true;
      // Defer to post-frame to avoid mutating controller state during build.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _geminiCtrl.text = s.geminiApiKey;
          _openAiCtrl.text = s.openAiApiKey;
        }
      });
    }
  }

  Future<void> _saveKeys() async {
    final sm = ScaffoldMessenger.of(context);
    setState(() => _saving = true);
    await ref.read(settingsProvider.notifier).updateSettings(
          geminiKey: _geminiCtrl.text.trim(),
          openAiKey: _openAiCtrl.text.trim(),
        );
    setState(() => _saving = false);
    sm.showSnackBar(
      const SnackBar(content: Text('API keys saved.')),
    );
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
                onChanged: (v) async {
                  try {
                    await ref
                        .read(settingsProvider.notifier)
                        .updateSettings(provider: v);
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to save provider: $e')),
                      );
                    }
                  }
                },
              ),
              RadioListTile<String>(
                title: const Text('OpenAI'),
                value: 'openai',
                groupValue: settings.aiProvider,
                onChanged: (v) async {
                  try {
                    await ref
                        .read(settingsProvider.notifier)
                        .updateSettings(provider: v);
                  } catch (e) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to save provider: $e')),
                    );
                  }
                },
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
                    icon: Icon(
                        _showGemini ? Icons.visibility_off : Icons.visibility),
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
                    icon: Icon(
                        _showOpenAi ? Icons.visibility_off : Icons.visibility),
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
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Save API Keys'),
              ),
              const Divider(height: 32),

              // ── Export / Import ──────────────────────────────────
              const _SectionHeader('Data'),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.upload_file),
                title: const Text('Export Story'),
                subtitle: const Text('Share current story as JSON backup'),
                contentPadding: EdgeInsets.zero,
                onTap: () async {
                  final story = ref.read(activeStoryProvider);
                  if (story == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Select a story from Dashboard first.')),
                    );
                    return;
                  }
                  try {
                    final service = ref.read(exportServiceProvider);
                    final chars = await ref
                        .read(characterRepositoryProvider)
                        .getAllForStory(story.id);
                    final locs = await ref
                        .read(locationRepositoryProvider)
                        .getAllForStory(story.id);
                    final events = await ref
                        .read(plotEventRepositoryProvider)
                        .getAllForStory(story.id);
                    final chapters = await ref
                        .read(chapterRepositoryProvider)
                        .getAllForStory(story.id);
                    final notes = await ref
                        .read(noteRepositoryProvider)
                        .getAllForStory(story.id);
                    final questions = await ref
                        .read(questionRepositoryProvider)
                        .getAllForStory(story.id);
                    final rels = await ref
                        .read(relationshipRepositoryProvider)
                        .getAllForStory(story.id);
                    final bundle = service.buildBundle(
                      story: story,
                      characters: chars,
                      locations: locs,
                      events: events,
                      chapters: chapters,
                      notes: notes,
                      questions: questions,
                      relationships: rels,
                    );
                    await service.exportToFile(bundle);
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Export failed: $e')),
                      );
                    }
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.download),
                title: const Text('Import Story'),
                subtitle: const Text('Restore from a JSON backup file'),
                contentPadding: EdgeInsets.zero,
                onTap: () async {
                  try {
                    final service = ref.read(exportServiceProvider);
                    final bundle = await service.importFromFile();
                    if (bundle == null) return;

                    await service.importBundle(bundle);

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Story imported successfully.')),
                      );
                      // Force refresh dashboard/active story if needed
                      ref.invalidate(activeStoryProvider);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Import failed: $e')),
                      );
                    }
                  }
                },
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
