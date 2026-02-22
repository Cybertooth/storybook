import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/active_story_provider.dart';
import '../../../domain/models/unresolved_question.dart';
import '../providers/question_providers.dart';

class QuestionsBottomSheet extends ConsumerStatefulWidget {
  const QuestionsBottomSheet({super.key});

  @override
  ConsumerState<QuestionsBottomSheet> createState() => _State();
}

class _State extends ConsumerState<QuestionsBottomSheet> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    final storyId = ref.read(activeStoryProvider)?.id;
    if (storyId == null) return;
    await ref.read(questionListProvider.notifier).add(storyId, text);
    _ctrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final questionsAsync = ref.watch(questionListProvider);
    final hasStory = ref.watch(activeStoryProvider) != null;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.55,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (ctx, scrollCtrl) => Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Unresolved Questions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(ctx),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          if (hasStory) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      decoration: const InputDecoration(
                        hintText: 'Add a question…',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _add(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _add,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
          ],
          Expanded(
            child: questionsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (questions) {
                final open = questions.where((q) => !q.isResolved).toList();
                final resolved = questions.where((q) => q.isResolved).toList();
                if (questions.isEmpty) {
                  return Center(
                    child: Text(
                      hasStory ? 'No questions yet.' : 'Select a story first.',
                    ),
                  );
                }
                return ListView(
                  controller: scrollCtrl,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    if (open.isNotEmpty) ...[
                      const _SectionHeader('Open'),
                      ...open.map((q) => _QuestionTile(question: q)),
                    ],
                    if (resolved.isNotEmpty) ...[
                      const _SectionHeader('Resolved'),
                      ...resolved.map((q) => _QuestionTile(question: q)),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader(this.label);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 4),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
            letterSpacing: 0.8,
          ),
        ),
      );
}

class _QuestionTile extends ConsumerWidget {
  final UnresolvedQuestion question;
  const _QuestionTile({required this.question});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(questionListProvider.notifier);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Checkbox(
        value: question.isResolved,
        onChanged: question.isResolved
            ? null
            : (_) => notifier.resolve(question),
      ),
      title: Text(
        question.text,
        style: question.isResolved
            ? const TextStyle(decoration: TextDecoration.lineThrough)
            : null,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, size: 18),
        onPressed: () => notifier.delete(question.id),
      ),
    );
  }
}
