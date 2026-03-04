import 'package:flutter/material.dart';
import 'seed_expander_screen.dart';
import 'critique_screen.dart';
import 'plot_hole_screen.dart';
import 'beat_sheet_screen.dart';
import 'tropes_screen.dart';
import 'show_dont_tell_screen.dart';

class StoryEngineScreen extends StatelessWidget {
  const StoryEngineScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      (
        'Show, Don\'t Tell',
        Icons.visibility,
        'Identify tell-heavy prose and see evocatively rewritten versions',
        const ShowDontTellScreen()
      ),
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
