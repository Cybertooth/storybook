import 'package:flutter/material.dart';

import '../../scratchpad/screens/scratchpad_screen.dart';
import '../../story_engine/screens/story_engine_screen.dart';
import '../../settings/screens/settings_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  static const _items = [
    (
      icon: Icons.sticky_note_2_outlined,
      label: 'Scratchpad',
      subtitle: 'Quick notes and ideas',
    ),
    (
      icon: Icons.auto_stories,
      label: 'Story Engine',
      subtitle: 'AI-powered writing tools',
    ),
    (
      icon: Icons.settings_outlined,
      label: 'Settings',
      subtitle: 'Theme and API keys',
    ),
  ];

  Widget _screenFor(int index) => switch (index) {
        0 => const ScratchpadScreen(),
        1 => const StoryEngineScreen(),
        _ => const SettingsScreen(),
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (ctx, i) {
          final item = _items[i];
          return Card(
            child: ListTile(
              leading: CircleAvatar(child: Icon(item.icon)),
              title: Text(item.label,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(item.subtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                ctx,
                MaterialPageRoute(builder: (_) => _screenFor(i)),
              ),
            ),
          );
        },
      ),
    );
  }
}
