import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../features/projects/screens/projects_screen.dart';
import '../features/codex/screens/codex_screen.dart';
import '../features/timeline/screens/timeline_screen.dart';
import '../features/draft/screens/draft_screen.dart';
import '../features/scratchpad/screens/scratchpad_screen.dart';
import '../features/story_engine/screens/story_engine_screen.dart';
import '../features/settings/screens/settings_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../shared/widgets/app_scaffold.dart';
import 'providers/active_story_provider.dart';
import 'providers/auth_provider.dart';

part 'router.g.dart';

@riverpod
GoRouter router(Ref ref) {
  // Watch activeStoryProvider and authProvider to trigger router re-evaluation on state change
  final activeStory = ref.watch(activeStoryProvider);
  final authState = ref.watch(authProvider).value;

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isAtLogin = state.uri.path == '/login';
      final isAtSettings = state.uri.path == '/settings';

      final isAuthenticated = authState?.isAuthenticated ?? false;
      final isOffline = authState?.isOfflineMode ?? false;
      final hasAccess = isAuthenticated || isOffline;

      // Unauthenticated users must go to login (unless they are configuring settings)
      if (!hasAccess && !isAtLogin && !isAtSettings) {
        return '/login';
      }

      // Keep authenticated/offline users out of login screen
      if (hasAccess && isAtLogin) {
        return '/projects';
      }

      final isAtProjects = state.uri.path == '/projects';

      if (hasAccess) {
        if (activeStory == null && !isAtProjects && !isAtSettings) {
          return '/projects';
        } else if (activeStory != null &&
            (state.uri.path == '/' || isAtProjects)) {
          return '/scratchpad';
        }
      }

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (c, s) => const LoginScreen()),
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
