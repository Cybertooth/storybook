import 'package:flutter/material.dart';
import 'event_board_screen.dart';
import 'pacing_graph_screen.dart';

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Timeline'),
          bottom: const TabBar(tabs: [Tab(text: 'Event Board'), Tab(text: 'Pacing Graph')]),
        ),
        body: const TabBarView(children: [EventBoardScreen(), PacingGraphScreen()]),
      ),
    );
  }
}
