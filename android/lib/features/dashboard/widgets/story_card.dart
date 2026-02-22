import 'package:flutter/material.dart';
import '../../../domain/models/story.dart';

class StoryCard extends StatelessWidget {
  final Story story;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const StoryCard({
    super.key,
    required this.story,
    required this.isActive,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      color: isActive ? cs.primaryContainer : null,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(story.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: story.summary.isNotEmpty ? Text(story.summary, maxLines: 2, overflow: TextOverflow.ellipsis) : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isActive) Icon(Icons.check_circle, color: cs.primary),
            IconButton(icon: const Icon(Icons.delete_outline), onPressed: onDelete),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
