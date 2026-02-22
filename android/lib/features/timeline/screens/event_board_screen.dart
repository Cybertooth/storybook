import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/plot_event.dart';
import '../providers/timeline_providers.dart';
import '../widgets/event_card.dart';
import 'event_detail_sheet.dart';

class EventBoardScreen extends ConsumerWidget {
  const EventBoardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventListProvider);
    final threads = ref.watch(plotThreadsProvider);

    return eventsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (events) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Text('Plot Threads', style: TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                TextButton.icon(
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('New Thread'),
                  onPressed: () => _addThread(context, ref),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: threads.map((thread) {
                  final threadEvents = events.where((e) => e.plotThread == thread).toList();
                  return _ThreadRow(thread: thread, events: threadEvents, allEvents: events);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addThread(BuildContext context, WidgetRef ref) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Plot Thread'),
        content: TextField(controller: ctrl, autofocus: true, decoration: const InputDecoration(labelText: 'Thread name')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                ref.read(eventListProvider.notifier).createEvent(
                  title: 'First event', plotThread: ctrl.text.trim(),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class _ThreadRow extends ConsumerWidget {
  final String thread;
  final List<PlotEvent> events;
  final List<PlotEvent> allEvents;

  const _ThreadRow({required this.thread, required this.events, required this.allEvents});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(thread, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ...events.map((e) => EventCard(
                  event: e,
                  onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => EventDetailSheet(event: e),
                  ),
                )),
                _AddEventButton(plotThread: thread),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}

class _AddEventButton extends ConsumerWidget {
  final String plotThread;
  const _AddEventButton({required this.plotThread});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _showCreate(context, ref),
      child: Container(
        width: 100,
        height: 90,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.5), style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreate(BuildContext context, WidgetRef ref) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Add event to "$plotThread"'),
        content: TextField(controller: ctrl, autofocus: true, decoration: const InputDecoration(labelText: 'Event title')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                ref.read(eventListProvider.notifier).createEvent(title: ctrl.text.trim(), plotThread: plotThread);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
