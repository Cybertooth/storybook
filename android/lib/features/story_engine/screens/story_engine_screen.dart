import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/active_story_provider.dart';
import 'seed_expander_screen.dart';
import 'critique_screen.dart';
import 'plot_hole_screen.dart';
import 'beat_sheet_screen.dart';
import 'tropes_screen.dart';

class StoryEngineScreen extends ConsumerWidget {
  const StoryEngineScreen({super.key});

  List<Widget> _buildActions(BuildContext context, WidgetRef ref) {
    return [
      IconButton(
        icon: const Icon(Icons.settings),
        tooltip: 'Settings',
        onPressed: () => context.push('/settings'),
      ),
      IconButton(
        icon: const Icon(Icons.library_books),
        tooltip: 'Switch Project',
        onPressed: () {
          ref.read(activeStoryProvider.notifier).clear();
          context.go('/projects');
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tools = [
      (
        'Seed Expander',
        Icons.auto_awesome,
        'Turn a story seed into 3 creative directions',
        const SeedExpanderScreen()
      ),
      (
        'AI Critique',
        Icons.rate_review,
        'Submit a draft for severity-ranked feedback',
        const CritiqueScreen()
      ),
      (
        'Plot Hole Checker',
        Icons.warning_amber,
        'Scan for continuity errors and abandoned threads',
        const PlotHoleScreen()
      ),
      (
        'Beat Sheets',
        Icons.table_chart,
        'Save the Cat / Hero\'s Journey overlays',
        const BeatSheetScreen()
      ),
      (
        'Tropes Analyzer',
        Icons.analytics,
        'Identify and subvert common narrative tropes',
        const TropesScreen()
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Engine'),
        actions: _buildActions(context, ref),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: tools.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (ctx, i) {
          final (label, icon, subtitle, screen) = tools[i];
          return Card(
            child: ListTile(
              leading: CircleAvatar(child: Icon(icon)),
              title: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(subtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                  ctx, MaterialPageRoute(builder: (_) => screen)),
            ),
          );
        },
      ),
    );
  }
}
