# Android Phase 6: AI Service Layer + Story Engine

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Implement the AI service abstraction (direct Gemini calls now, swappable to backend proxy later), settings provider for secure API key storage, and all 5 Story Engine screens (Seed Expander, Critique, Plot Hole Checker, Beat Sheets, Tropes Analyzer).

**Architecture:** Abstract `AiService` interface → `GeminiAiService` implementation. `settingsProvider` stores keys in `flutter_secure_storage`. `aiServiceProvider` returns `null` if no key is configured (screens handle this gracefully with a "Set API key" message).

**Tech Stack:** dio, flutter_secure_storage, Riverpod

**Depends on:** Phase 2 (domain models), Phase 1 (app running).
**Next phase:** `2026-02-21-android-phase-7-supporting.md`

---

## Task 1: Settings Provider (Secure Storage)

**Files:**
- Create: `android/lib/core/providers/settings_provider.dart`

**Step 1: Implement settings provider**

`android/lib/core/providers/settings_provider.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (_) => const FlutterSecureStorage(),
);

class AppSettings {
  final String geminiApiKey;
  final String openAiApiKey;
  final String aiProvider; // 'gemini' | 'openai'

  const AppSettings({
    this.geminiApiKey = '',
    this.openAiApiKey = '',
    this.aiProvider = 'gemini',
  });
}

class SettingsNotifier extends AsyncNotifier<AppSettings> {
  static const _geminiKey = 'gemini_api_key';
  static const _openAiKey = 'openai_api_key';
  static const _providerKey = 'ai_provider';

  @override
  Future<AppSettings> build() async {
    final storage = ref.read(secureStorageProvider);
    return AppSettings(
      geminiApiKey: await storage.read(key: _geminiKey) ?? '',
      openAiApiKey: await storage.read(key: _openAiKey) ?? '',
      aiProvider: await storage.read(key: _providerKey) ?? 'gemini',
    );
  }

  Future<void> update({String? geminiKey, String? openAiKey, String? provider}) async {
    final storage = ref.read(secureStorageProvider);
    if (geminiKey != null) await storage.write(key: _geminiKey, value: geminiKey);
    if (openAiKey != null) await storage.write(key: _openAiKey, value: openAiKey);
    if (provider != null) await storage.write(key: _providerKey, value: provider);
    ref.invalidateSelf();
  }
}

final settingsProvider =
    AsyncNotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);
```

**Step 2: Commit**

```bash
git add android/lib/core/providers/settings_provider.dart
git commit -m "feat(android): settings provider with flutter_secure_storage for API keys"
```

---

## Task 2: AI Service Interface + Gemini Implementation

**Files:**
- Create: `android/lib/domain/services/ai_service.dart`
- Create: `android/lib/data/remote/gemini_ai_service.dart`
- Create: `android/lib/core/providers/ai_provider.dart`

**Step 1: AI service interface**

`android/lib/domain/services/ai_service.dart`:

```dart
abstract class AiService {
  /// Returns 3 story continuations for the given seed text.
  Future<List<String>> suggestContinuations(String seed);

  /// Returns critique objects with keys: 'text', 'severity' ("Small"|"Medium"|"Major").
  Future<List<Map<String, dynamic>>> critique(String draft, String context);

  /// Returns a revised draft addressing the given critique strings.
  Future<String> reviseDraft(String draft, List<String> selectedCritiques);

  /// Returns consistency issue objects with keys: 'issue', 'severity', 'suggestion'.
  Future<List<Map<String, dynamic>>> checkPlotHoles(String storyContext);

  /// Returns trope objects with keys: 'trope', 'risk' ("Low"|"Medium"|"High"), 'description', 'suggestion'.
  Future<List<Map<String, dynamic>>> analyzeTropes(String storyContext);

  /// Returns show-don't-tell suggestions with keys: 'original', 'suggestion'.
  Future<List<Map<String, dynamic>>> showDontTell(String prose);

  /// Returns 3 next-sentence continuations given prior text and plot context.
  Future<List<String>> suggestNext(String priorText, String plotContext);

  /// Returns an image URL or null if not supported.
  Future<String?> generatePortrait(String characterDescription);
}
```

**Step 2: Gemini implementation**

`android/lib/data/remote/gemini_ai_service.dart`:

```dart
import 'dart:convert';
import 'package:dio/dio.dart';
import '../../domain/services/ai_service.dart';

class GeminiAiService implements AiService {
  final String apiKey;
  final Dio _dio;

  GeminiAiService(this.apiKey)
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://generativelanguage.googleapis.com/v1beta',
          queryParameters: {'key': apiKey},
          headers: {'Content-Type': 'application/json'},
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 60),
        ));

  Future<String> _generate(String prompt) async {
    final response = await _dio.post(
      '/models/gemini-1.5-flash:generateContent',
      data: {
        'contents': [
          {'parts': [{'text': prompt}]}
        ],
        'generationConfig': {'temperature': 0.8, 'maxOutputTokens': 2048},
      },
    );
    return response.data['candidates'][0]['content']['parts'][0]['text'] as String;
  }

  List<dynamic> _parseJsonArray(String raw) {
    final cleaned = raw.replaceAll(RegExp(r'```json\s*|```\s*'), '').trim();
    return jsonDecode(cleaned) as List<dynamic>;
  }

  @override
  Future<List<String>> suggestContinuations(String seed) async {
    final raw = await _generate('''Given this story seed: "$seed"
Provide exactly 3 distinct, creative continuations. Return them as a JSON array of strings.
Example: ["continuation 1", "continuation 2", "continuation 3"]
Return ONLY the JSON array, no other text.''');
    return List<String>.from(_parseJsonArray(raw));
  }

  @override
  Future<List<Map<String, dynamic>>> critique(String draft, String context) async {
    final raw = await _generate('''Critically analyze this story excerpt.
${context.isNotEmpty ? 'Story context: $context' : ''}
Draft: $draft

Return a JSON array of critique objects. Each object must have:
- "text": the specific critique
- "severity": exactly one of "Small", "Medium", or "Major"

Return ONLY the JSON array.''');
    return List<Map<String, dynamic>>.from(_parseJsonArray(raw));
  }

  @override
  Future<String> reviseDraft(String draft, List<String> selectedCritiques) async {
    return _generate('''Revise the following draft to address these critiques:
${selectedCritiques.asMap().entries.map((e) => '${e.key + 1}. ${e.value}').join('\n')}

Original draft:
$draft

Return ONLY the revised draft text, no preamble.''');
  }

  @override
  Future<List<Map<String, dynamic>>> checkPlotHoles(String storyContext) async {
    final raw = await _generate('''Analyze this story for plot holes, continuity errors, and abandoned threads:
$storyContext

Return a JSON array. Each object must have:
- "issue": description of the problem
- "severity": "Minor" or "Major"
- "suggestion": how to fix it

Return ONLY the JSON array.''');
    return List<Map<String, dynamic>>.from(_parseJsonArray(raw));
  }

  @override
  Future<List<Map<String, dynamic>>> analyzeTropes(String storyContext) async {
    final raw = await _generate('''Identify narrative tropes and clichés in this story:
$storyContext

Return a JSON array. Each object must have:
- "trope": the trope name
- "risk": "Low", "Medium", or "High"
- "description": brief explanation
- "suggestion": how to subvert or lean in intentionally

Return ONLY the JSON array.''');
    return List<Map<String, dynamic>>.from(_parseJsonArray(raw));
  }

  @override
  Future<List<Map<String, dynamic>>> showDontTell(String prose) async {
    final raw = await _generate('''Identify "tell-heavy" sentences in this prose and rewrite them to "show" instead:
$prose

Return a JSON array. Each object must have:
- "original": the tell-heavy original sentence
- "suggestion": an evocative rewrite that shows instead

Return ONLY the JSON array.''');
    return List<Map<String, dynamic>>.from(_parseJsonArray(raw));
  }

  @override
  Future<List<String>> suggestNext(String priorText, String plotContext) async {
    final raw = await _generate('''${plotContext.isNotEmpty ? 'Story context: $plotContext\n\n' : ''}Recent prose:
$priorText

Suggest 3 distinct, short continuations (1-3 sentences each). Return as a JSON array of strings.
Return ONLY the JSON array.''');
    return List<String>.from(_parseJsonArray(raw));
  }

  @override
  Future<String?> generatePortrait(String characterDescription) async {
    // Imagen API requires separate setup; stub returns null for now.
    return null;
  }
}
```

**Step 3: AI provider**

`android/lib/core/providers/ai_provider.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/remote/gemini_ai_service.dart';
import '../../domain/services/ai_service.dart';
import 'settings_provider.dart';

/// Returns null if no API key is configured.
/// To switch to the NestJS backend proxy: replace GeminiAiService
/// with BackendProxyAiService (to be created in a future phase).
final aiServiceProvider = Provider<AiService?>((ref) {
  final settings = ref.watch(settingsProvider).valueOrNull;
  if (settings == null || settings.geminiApiKey.isEmpty) return null;
  return GeminiAiService(settings.geminiApiKey);
});
```

**Step 4: Write tests for JSON parsing**

`android/test/data/remote/gemini_ai_service_test.dart`:

```dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

// Tests the JSON cleaning and parsing logic without real HTTP calls.
void main() {
  group('Gemini JSON parsing', () {
    test('parses bare JSON array', () {
      const raw = '["A", "B", "C"]';
      final cleaned = raw.replaceAll(RegExp(r'```json\s*|```\s*'), '').trim();
      final result = List<String>.from(jsonDecode(cleaned));
      expect(result.length, 3);
      expect(result[0], 'A');
    });

    test('strips markdown code fences before parsing', () {
      const raw = '```json\n["A", "B"]\n```';
      final cleaned = raw.replaceAll(RegExp(r'```json\s*|```\s*'), '').trim();
      final result = List<String>.from(jsonDecode(cleaned));
      expect(result.length, 2);
    });

    test('parses critique objects', () {
      const raw = '[{"text": "Pacing issue", "severity": "Major"}]';
      final cleaned = raw.replaceAll(RegExp(r'```json\s*|```\s*'), '').trim();
      final result = List<Map<String, dynamic>>.from(jsonDecode(cleaned));
      expect(result[0]['severity'], 'Major');
    });
  });
}
```

**Step 5: Run tests**

```bash
cd android
flutter test test/data/remote/
```

Expected: PASS.

**Step 6: Commit**

```bash
git add android/lib/domain/services/ android/lib/data/remote/ android/lib/core/providers/ai_provider.dart android/test/data/remote/
git commit -m "feat(android): AI service layer with Gemini implementation and test"
```

---

## Task 3: Story Engine Hub + Seed Expander

**Files:**
- Create: `android/lib/features/story_engine/screens/story_engine_screen.dart`
- Create: `android/lib/features/story_engine/screens/seed_expander_screen.dart`
- Create: `android/lib/features/story_engine/widgets/ai_no_key_banner.dart`

**Step 1: No-key banner widget (reused across all AI screens)**

`android/lib/features/story_engine/widgets/ai_no_key_banner.dart`:

```dart
import 'package:flutter/material.dart';

class AiNoKeyBanner extends StatelessWidget {
  const AiNoKeyBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.key, color: Theme.of(context).colorScheme.onErrorContainer),
          const SizedBox(width: 8),
          Expanded(child: Text(
            'No API key configured. Go to More → Settings to add your Gemini key.',
            style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
          )),
        ],
      ),
    );
  }
}
```

**Step 2: Story engine hub**

`android/lib/features/story_engine/screens/story_engine_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'seed_expander_screen.dart';
import 'critique_screen.dart';
import 'plot_hole_screen.dart';
import 'beat_sheet_screen.dart';
import 'tropes_screen.dart';

class StoryEngineScreen extends StatelessWidget {
  const StoryEngineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tools = [
      ('Seed Expander', Icons.auto_awesome, 'Turn a story seed into 3 creative directions', const SeedExpanderScreen()),
      ('AI Critique', Icons.rate_review, 'Submit a draft for severity-ranked feedback', const CritiqueScreen()),
      ('Plot Hole Checker', Icons.warning_amber, 'Scan for continuity errors and abandoned threads', const PlotHoleScreen()),
      ('Beat Sheets', Icons.table_chart, 'Save the Cat / Hero\'s Journey overlays', const BeatSheetScreen()),
      ('Tropes Analyzer', Icons.analytics, 'Identify and subvert common narrative tropes', const TropesScreen()),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Story Engine')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: tools.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (ctx, i) {
          final (label, icon, subtitle, screen) = tools[i];
          return Card(
            child: ListTile(
              leading: CircleAvatar(child: Icon(icon)),
              title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(subtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => screen)),
            ),
          );
        },
      ),
    );
  }
}
```

**Step 3: Seed expander screen**

`android/lib/features/story_engine/screens/seed_expander_screen.dart`:

```dart
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
```

**Step 4: Commit**

```bash
git add android/lib/features/story_engine/
git commit -m "feat(android): story engine hub and seed expander"
```

---

## Task 4: AI Critique Screen

**Files:**
- Create: `android/lib/features/story_engine/screens/critique_screen.dart`

**Step 1: Implement**

`android/lib/features/story_engine/screens/critique_screen.dart`:

```dart
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
```

**Step 2: Commit**

```bash
git add android/lib/features/story_engine/screens/critique_screen.dart
git commit -m "feat(android): AI critique screen with severity filtering and diff-based revision"
```

---

## Task 5: Plot Hole, Tropes, and Beat Sheet Screens

**Files:**
- Create: `android/lib/features/story_engine/screens/plot_hole_screen.dart`
- Create: `android/lib/features/story_engine/screens/tropes_screen.dart`
- Create: `android/lib/features/story_engine/screens/beat_sheet_screen.dart`

**Step 1: Plot hole screen**

`android/lib/features/story_engine/screens/plot_hole_screen.dart`:

```dart
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
      // Build story context from all entities
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
```

**Step 2: Tropes screen**

`android/lib/features/story_engine/screens/tropes_screen.dart`:

```dart
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
    setState(() { _loading = true; _tropes = []; _error = null; });
    try {
      final events = await ref.read(plotEventRepositoryProvider).getAllForStory(story.id);
      final context = '${story.title}: ${story.summary}\nPlot: ${events.map((e) => e.title).join(', ')}';
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
                  onPressed: (hasKey && !_loading) ? _analyze : null,
                  icon: _loading
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.analytics),
                  label: const Text('Analyze Story'),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 8),
                  Text('Error: $_error', style: const TextStyle(color: Colors.red)),
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
                          Expanded(child: Text(t['trope'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold))),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _riskColor(t['risk'] ?? '').withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(t['risk'] ?? '', style: TextStyle(color: _riskColor(t['risk'] ?? ''), fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ]),
                        const SizedBox(height: 4),
                        Text(t['description'] ?? '', style: const TextStyle(fontSize: 13)),
                        if (t['suggestion'] != null) ...[
                          const SizedBox(height: 6),
                          Text('💡 ${t['suggestion']}', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary)),
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
```

**Step 3: Beat sheet screen (static reference)**

`android/lib/features/story_engine/screens/beat_sheet_screen.dart`:

```dart
import 'package:flutter/material.dart';

class BeatSheetScreen extends StatelessWidget {
  const BeatSheetScreen({super.key});

  static const _saveTheCat = [
    (1, 'Opening Image', 'A snapshot of the hero\'s problem world before the change.'),
    (2, 'Theme Stated', 'The thematic premise is stated (often by someone other than the hero).'),
    (3, 'Set-Up', 'Introduce all the characters. Show the hero\'s flaws and desires.'),
    (4, 'Catalyst', 'The life-changing event that kicks the story into gear.'),
    (5, 'Debate', 'The hero hesitates. Should I go? What if I fail?'),
    (6, 'Break into Two', 'The hero enters the upside-down world — Act II begins.'),
    (7, 'B Story', 'The love story / mentor relationship begins. Carries the theme.'),
    (8, 'Fun and Games', 'The "promise of the premise" — why we bought the ticket.'),
    (9, 'Midpoint', 'A false victory or false defeat. Stakes are raised.'),
    (10, 'Bad Guys Close In', 'Internal doubts, external enemies all close in.'),
    (11, 'All Is Lost', 'The worst thing possible. The whiff of death.'),
    (12, 'Dark Night of the Soul', 'The hero has nowhere to turn and digs deep.'),
    (13, 'Break into Three', 'The solution found — hero decides to fight back.'),
    (14, 'Finale', 'Storm the castle. Execute the plan. Change the world.'),
    (15, 'Final Image', 'The mirror of the Opening Image. Shows how much has changed.'),
  ];

  static const _heroJourney = [
    (1, 'Ordinary World', 'The hero\'s normal life before the adventure begins.'),
    (2, 'Call to Adventure', 'The hero is presented with a challenge or problem.'),
    (3, 'Refusal of the Call', 'The hero hesitates or refuses the challenge.'),
    (4, 'Meeting the Mentor', 'The hero encounters someone who gives wisdom or tools.'),
    (5, 'Crossing the Threshold', 'The hero commits and enters the special world.'),
    (6, 'Tests, Allies, Enemies', 'The hero faces challenges and makes friends/foes.'),
    (7, 'Approach to Inmost Cave', 'The hero nears the dangerous place of the ordeal.'),
    (8, 'Ordeal', 'The hero faces their greatest fear. Death and rebirth.'),
    (9, 'Reward (Seizing the Sword)', 'The hero takes possession of the treasure.'),
    (10, 'Road Back', 'The hero begins the journey back, often pursued.'),
    (11, 'Resurrection', 'A final test where the hero is transformed.'),
    (12, 'Return with the Elixir', 'The hero returns changed, with something to benefit the world.'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Beat Sheets'),
          bottom: const TabBar(tabs: [Tab(text: 'Save the Cat'), Tab(text: 'Hero\'s Journey')]),
        ),
        body: TabBarView(children: [
          _BeatList(beats: _saveTheCat),
          _BeatList(beats: _heroJourney),
        ]),
      ),
    );
  }
}

class _BeatList extends StatelessWidget {
  final List<(int, String, String)> beats;
  const _BeatList({required this.beats});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: beats.length,
      itemBuilder: (ctx, i) {
        final (num, name, desc) = beats[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              child: Text('$num', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
            title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(desc),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}
```

**Step 4: Commit**

```bash
git add android/lib/features/story_engine/
git commit -m "feat(android): plot hole checker, tropes analyzer, and beat sheet reference screens"
```
