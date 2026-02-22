import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/active_story_provider.dart';
import '../providers/draft_providers.dart';
import '../widgets/reference_drawer.dart';

class DraftScreen extends ConsumerStatefulWidget {
  const DraftScreen({super.key});

  @override
  ConsumerState<DraftScreen> createState() => _DraftScreenState();
}

class _DraftScreenState extends ConsumerState<DraftScreen> {
  final _controller = TextEditingController();
  bool _focusMode = false;
  bool _previewMode = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final active = ref.watch(activeStoryProvider);
    final activeChapter = ref.watch(activeChapterProvider);
    final chaptersAsync = ref.watch(chapterListProvider);

    // Keep editor in sync with active chapter
    if (activeChapter != null && _controller.text != activeChapter.content) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _controller.text = activeChapter.content;
      });
    }

    if (active == null) {
      return const Scaffold(body: Center(child: Text('Select a story from the Dashboard first.')));
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: _focusMode ? null : AppBar(
        title: Text(activeChapter?.title ?? 'Draft', overflow: TextOverflow.ellipsis),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: Icon(_previewMode ? Icons.edit : Icons.preview),
            tooltip: _previewMode ? 'Edit' : 'Preview',
            onPressed: () => setState(() => _previewMode = !_previewMode),
          ),
          IconButton(
            icon: const Icon(Icons.menu_book),
            tooltip: 'Reference',
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => const ReferenceDrawer(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.fullscreen),
            tooltip: 'Focus Mode',
            onPressed: () => setState(() => _focusMode = true),
          ),
        ],
      ),
      drawer: _buildChapterDrawer(context, chaptersAsync),
      body: _buildBody(context, activeChapter),
      floatingActionButton: _focusMode
          ? FloatingActionButton.small(
              onPressed: () => setState(() => _focusMode = false),
              child: const Icon(Icons.fullscreen_exit),
            )
          : null,
    );
  }

  Widget _buildBody(BuildContext context, dynamic activeChapter) {
    if (activeChapter == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('No chapter selected.'),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              child: const Text('Open Chapter List'),
            ),
          ],
        ),
      );
    }
    if (_previewMode) {
      return Markdown(
        data: _controller.text,
        padding: const EdgeInsets.all(16),
      );
    }
    return TextField(
      controller: _controller,
      maxLines: null,
      expands: true,
      keyboardType: TextInputType.multiline,
      style: const TextStyle(fontSize: 16, height: 1.6),
      decoration: const InputDecoration(
        hintText: 'Begin writing...',
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(16),
      ),
      onChanged: (content) {
        final chapter = ref.read(activeChapterProvider);
        if (chapter != null) {
          ref.read(chapterListProvider.notifier).saveContent(chapter, content);
          // Update active chapter state to keep it in sync
          ref.read(activeChapterProvider.notifier).set(chapter.copyWith(content: content));
        }
      },
    );
  }

  Widget? _buildChapterDrawer(BuildContext context, AsyncValue chaptersAsync) {
    return chaptersAsync.when(
      loading: () => null,
      error: (_, __) => null,
      data: (chapters) => Drawer(
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Chapters', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              Expanded(
                child: ListView(
                  children: chapters.map<Widget>((c) {
                    final active = ref.read(activeChapterProvider);
                    return ListTile(
                      title: Text(c.title),
                      selected: c.id == active?.id,
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, size: 18),
                        onPressed: () {
                          ref.read(chapterListProvider.notifier).deleteChapter(c.id);
                          if (ref.read(activeChapterProvider)?.id == c.id) {
                            ref.read(activeChapterProvider.notifier).clear();
                          }
                        },
                      ),
                      onTap: () {
                        ref.read(activeChapterProvider.notifier).set(c);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton.icon(
                  onPressed: () => _createChapter(context),
                  icon: const Icon(Icons.add),
                  label: const Text('New Chapter'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createChapter(BuildContext context) async {
    final ctrl = TextEditingController();
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Chapter'),
        content: TextField(controller: ctrl, autofocus: true, decoration: const InputDecoration(labelText: 'Title')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              if (ctrl.text.trim().isNotEmpty) {
                final chapter = await ref.read(chapterListProvider.notifier).createChapter(ctrl.text.trim());
                ref.read(activeChapterProvider.notifier).set(chapter);
                if (mounted) Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
