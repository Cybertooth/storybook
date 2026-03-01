import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/active_story_provider.dart';
import 'event_board_screen.dart';
import 'pacing_graph_screen.dart';

class TimelineScreen extends ConsumerWidget {
  const TimelineScreen({super.key});

  List<Widget> _buildActions(BuildContext context, WidgetRef ref) {
    return [
      IconButton(
        icon: const Icon(Icons.library_books),
        tooltip: 'Switch Project',
        onPressed: () {
          ref.read(activeStoryProvider.notifier).clear();
          context.go('/projects');
        },
      ),
      IconButton(
        icon: const Icon(Icons.settings),
        tooltip: 'Settings',
        onPressed: () => context.push('/settings'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Timeline'),
          actions: _buildActions(context, ref),
          bottom: const TabBar(
              tabs: [Tab(text: 'Event Board'), Tab(text: 'Pacing Graph')]),
        ),
        body: const TabBarView(
            children: [EventBoardScreen(), PacingGraphScreen()]),
      ),
    );
  }
}
