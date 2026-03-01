import 'package:flutter/material.dart';
import '../../../domain/models/story.dart';

class ProjectCard extends StatelessWidget {
  final Story story;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ProjectCard({
    super.key,
    required this.story,
    required this.isActive,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Card(
      elevation: isActive ? 4 : 1,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isActive
            ? BorderSide(color: cs.primary, width: 2)
            : BorderSide.none,
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          story.title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (story.summary.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            story.summary,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: onDelete,
                    tooltip: 'Delete Project',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (isActive)
                    Chip(
                      label: const Text('Active Workspace'),
                      backgroundColor: cs.primaryContainer,
                      labelStyle: TextStyle(
                          color: cs.onPrimaryContainer,
                          fontWeight: FontWeight.bold),
                      side: BorderSide.none,
                    )
                  else
                    const SizedBox.shrink(),
                  FilledButton.icon(
                    onPressed: onTap,
                    icon: const Icon(Icons.open_in_new),
                    label: Text(isActive ? 'Continue Writing' : 'Open Project'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
