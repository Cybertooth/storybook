import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../features/projects/screens/projects_screen.dart';
import '../features/codex/screens/codex_screen.dart';
import '../features/timeline/screens/timeline_screen.dart';
import '../features/draft/screens/draft_screen.dart';
import '../features/scratchpad/screens/scratchpad_screen.dart';
import '../features/story_engine/screens/story_engine_screen.dart';
import '../features/settings/screens/settings_screen.dart';
import '../shared/widgets/app_scaffold.dart';
import 'providers/active_story_provider.dart';

part 'router.g.dart';

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final activeStory = ref.read(activeStoryProvider);
      final isAtProjects = state.uri.path == '/projects';

      if (activeStory == null && !isAtProjects) {
        return '/projects';
      } else if (activeStory != null &&
          (state.uri.path == '/' || isAtProjects)) {
        return '/scratchpad';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/projects', builder: (c, s) => const ProjectsScreen()),
      GoRoute(path: '/settings', builder: (c, s) => const SettingsScreen()),
      ShellRoute(
        builder: (context, state, child) => AppScaffold(child: child),
        routes: [
          GoRoute(
              path: '/scratchpad', builder: (c, s) => const ScratchpadScreen()),
          GoRoute(path: '/draft', builder: (c, s) => const DraftScreen()),
          GoRoute(path: '/ai', builder: (c, s) => const StoryEngineScreen()),
          GoRoute(path: '/timeline', builder: (c, s) => const TimelineScreen()),
          GoRoute(path: '/codex', builder: (c, s) => const CodexScreen()),
        ],
      ),
    ],
  );
}
