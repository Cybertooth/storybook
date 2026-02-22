import 'package:flutter/material.dart';
import '../../../domain/models/plot_event.dart';

class EventCard extends StatelessWidget {
  final PlotEvent event;
  final VoidCallback onTap;

  const EventCard({super.key, required this.event, required this.onTap});

  Color _statusColor(BuildContext context, EventStatus status) {
    final cs = Theme.of(context).colorScheme;
    return switch (status) {
      EventStatus.finalEvent => cs.primary,
      EventStatus.drafted => cs.secondary,
      EventStatus.idea => cs.surfaceContainer,
    };
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _statusColor(context, event.status),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(event.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
            if (event.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(event.description, style: const TextStyle(fontSize: 11), maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
            const SizedBox(height: 6),
            Row(children: [
              Icon(Icons.favorite, size: 12, color: Colors.pink[300]),
              const SizedBox(width: 2),
              Text('${event.emotionalValue}', style: const TextStyle(fontSize: 11)),
            ]),
          ],
        ),
      ),
    );
  }
}
