import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/questions/screens/questions_bottom_sheet.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  const AppScaffold({super.key, required this.child});

  static const _tabs = [
    (icon: Icons.dashboard, label: 'Dashboard', path: '/dashboard'),
    (icon: Icons.menu_book, label: 'Codex', path: '/codex'),
    (icon: Icons.timeline, label: 'Timeline', path: '/timeline'),
    (icon: Icons.edit, label: 'Draft', path: '/draft'),
    (icon: Icons.more_horiz, label: 'More', path: '/more'),
  ];

  int _locationToIndex(BuildContext context) {
    final loc = GoRouterState.of(context).matchedLocation;
    for (int i = 0; i < _tabs.length; i++) {
      if (loc.startsWith(_tabs[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      floatingActionButton: FloatingActionButton.small(
        heroTag: 'questions_fab',
        tooltip: 'Unresolved Questions',
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => const QuestionsBottomSheet(),
        ),
        child: const Text('?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _locationToIndex(context),
        onDestinationSelected: (i) => context.go(_tabs[i].path),
        destinations: _tabs
            .map((t) => NavigationDestination(icon: Icon(t.icon), label: t.label))
            .toList(),
      ),
    );
  }
}
