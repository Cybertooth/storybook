# Android Phase 1: Foundation

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Initialize the Flutter project in `android/`, install all dependencies, set up the app theme, and create the 5-tab navigation skeleton.

**Architecture:** Flutter 3.x + Riverpod 2.x + go_router. All code lives in `android/`. Run `dart run build_runner build --delete-conflicting-outputs` after any file with `part '*.g.dart'` is modified.

**Tech Stack:** Flutter, Riverpod, go_router, freezed, drift (installed now, used in Phase 2)

**Depends on:** Nothing — this is the starting point.
**Next phase:** `2026-02-21-android-phase-2-data-layer.md`

---

## Task 1: Initialize Flutter Project

**Files:**
- Create: `android/` (Flutter project root, created by CLI)

**Step 1: Create the Flutter project**

```bash
cd G:/code/gen-ai/storybook_v1
flutter create --project-name storybook_android --org com.storybook --platforms android android
```

Expected: `All done! Your application code is in android/lib/main.dart`

**Step 2: Verify the stub app runs**

```bash
cd android
flutter run
```

Expected: Default Flutter counter app launches on emulator/device.

**Step 3: Replace boilerplate main.dart**

Replace `android/lib/main.dart` with:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: Scaffold(body: Center(child: Text('Storybook')))));
}
```

**Step 4: Commit**

```bash
git add android/
git commit -m "feat(android): initialize Flutter project"
```

---

## Task 2: Configure pubspec.yaml

**Files:**
- Modify: `android/pubspec.yaml`

**Step 1: Replace the dependencies and dev_dependencies sections**

Open `android/pubspec.yaml`. Replace everything from `dependencies:` onward with:

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5

  # Storage
  drift: ^2.18.0
  drift_flutter: ^0.2.1
  path_provider: ^2.1.3
  flutter_secure_storage: ^9.0.0

  # Navigation
  go_router: ^14.2.1

  # HTTP
  dio: ^5.4.3+1

  # Models
  freezed_annotation: ^2.4.1
  json_annotation: ^4.9.0

  # UUID
  uuid: ^4.4.0

  # UI
  fl_chart: ^0.68.0
  graphview: ^1.2.0
  flutter_markdown: ^0.7.3
  gap: ^3.0.1

  # File operations (used in Phase 8)
  file_picker: ^8.0.3
  share_plus: ^10.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
  build_runner: ^2.4.11
  riverpod_generator: ^2.4.3
  drift_dev: ^2.18.0
  freezed: ^2.5.2
  json_serializable: ^6.8.0
  mockito: ^5.4.4
```

**Step 2: Install dependencies**

```bash
cd android
flutter pub get
```

Expected: All packages resolved, no version conflicts.

**Step 3: Commit**

```bash
git add android/pubspec.yaml android/pubspec.lock
git commit -m "feat(android): add all package dependencies"
```

---

## Task 3: App Theme + Constants

**Files:**
- Create: `android/lib/core/theme/app_theme.dart`
- Create: `android/lib/core/constants.dart`

**Step 1: Create constants**

`android/lib/core/constants.dart`:

```dart
class AppConstants {
  static const appName = 'Storybook';
  static const projectBundleVersion = 1;
  static const appBundleName = 'storybook';
}
```

**Step 2: Create theme**

`android/lib/core/theme/app_theme.dart`:

```dart
import 'package:flutter/material.dart';

class AppTheme {
  static const _primary = Color(0xFF6366F1); // indigo-500
  static const _darkSurface = Color(0xFF1E1E2E);

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: _primary,
          surface: _darkSurface,
          surfaceContainer: const Color(0xFF2A2A3E),
        ),
        cardTheme: const CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: _primary),
        cardTheme: const CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
}
```

**Step 3: Commit**

```bash
git add android/lib/core/
git commit -m "feat(android): app theme and constants"
```

---

## Task 4: Navigation Skeleton

**Files:**
- Create: `android/lib/core/providers/theme_provider.dart`
- Create: `android/lib/core/router.dart`
- Create: `android/lib/shared/widgets/app_scaffold.dart`
- Create: `android/lib/features/dashboard/screens/dashboard_screen.dart` (stub)
- Create: `android/lib/features/codex/screens/codex_screen.dart` (stub)
- Create: `android/lib/features/timeline/screens/timeline_screen.dart` (stub)
- Create: `android/lib/features/draft/screens/draft_screen.dart` (stub)
- Create: `android/lib/features/more/screens/more_screen.dart` (stub)
- Modify: `android/lib/main.dart`

**Step 1: Theme provider**

`android/lib/core/providers/theme_provider.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

@riverpod
class AppThemeMode extends _$AppThemeMode {
  @override
  ThemeMode build() => ThemeMode.dark;

  void toggle() {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }

  void set(ThemeMode mode) => state = mode;
}
```

**Step 2: Stub screens**

Create these 5 files — all identical except the label text:

`android/lib/features/dashboard/screens/dashboard_screen.dart`:
```dart
import 'package:flutter/material.dart';
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Dashboard')));
}
```

Repeat for `codex_screen.dart` (label: 'Codex'), `timeline_screen.dart` (label: 'Timeline'), `draft_screen.dart` (label: 'Draft'), `more_screen.dart` (label: 'More').

**Step 3: AppScaffold with bottom nav**

`android/lib/shared/widgets/app_scaffold.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  const AppScaffold({super.key, required this.child});

  static const _tabs = [
    (icon: Icons.dashboard, label: 'Dashboard', path: '/dashboard'),
    (icon: Icons.menu_book, label: 'Codex', path: '/codex'),
    (icon: Icons.timeline, label: 'Timeline', path: '/timeline'),
    (icon: Icons.edit, label: 'Draft', path: '/draft'),
    (icon: Icons.more_horiz, label: 'More', path: '/more'),
  ];

  int _locationToIndex(BuildContext context) {
    final loc = GoRouterState.of(context).matchedLocation;
    for (int i = 0; i < _tabs.length; i++) {
      if (loc.startsWith(_tabs[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _locationToIndex(context),
        onDestinationSelected: (i) => context.go(_tabs[i].path),
        destinations: _tabs
            .map((t) => NavigationDestination(icon: Icon(t.icon), label: t.label))
            .toList(),
      ),
    );
  }
}
```

**Step 4: Router**

`android/lib/core/router.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
          GoRoute(path: '/dashboard', builder: (c, s) => const DashboardScreen()),
          GoRoute(path: '/codex', builder: (c, s) => const CodexScreen()),
          GoRoute(path: '/timeline', builder: (c, s) => const TimelineScreen()),
          GoRoute(path: '/draft', builder: (c, s) => const DraftScreen()),
          GoRoute(path: '/more', builder: (c, s) => const MoreScreen()),
        ],
      ),
    ],
  );
}
```

**Step 5: Update main.dart**

`android/lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/router.dart';
import 'core/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: StorybookApp()));
}

class StorybookApp extends ConsumerWidget {
  const StorybookApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeModeProvider);
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'Storybook',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
```

**Step 6: Run code generation**

```bash
cd android
dart run build_runner build --delete-conflicting-outputs
```

Expected: Generates `theme_provider.g.dart`, `router.g.dart` with no errors.

**Step 7: Run the app**

```bash
flutter run
```

Expected: App launches with 5-tab bottom nav, each tab shows its stub label. Dark mode by default.

**Step 8: Commit**

```bash
git add android/lib/
git commit -m "feat(android): 5-tab navigation skeleton with Riverpod and go_router"
```
