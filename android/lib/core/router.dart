import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/codex/screens/codex_screen.dart';
import '../features/timeline/screens/timeline_screen.dart';
import '../features/draft/screens/draft_screen.dart';
import '../features/more/screens/more_screen.dart';
import '../shared/widgets/app_scaffold.dart';

part 'router.g.dart';

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    initialLocation: '/dashboard',
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppScaffold(child: child),
        routes: [
          GoRoute(
              path: '/dashboard', builder: (c, s) => const DashboardScreen()),
          GoRoute(path: '/codex', builder: (c, s) => const CodexScreen()),
          GoRoute(path: '/timeline', builder: (c, s) => const TimelineScreen()),
          GoRoute(path: '/draft', builder: (c, s) => const DraftScreen()),
          GoRoute(path: '/more', builder: (c, s) => const MoreScreen()),
        ],
      ),
    ],
  );
}
