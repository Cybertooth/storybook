import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/router.dart';
import 'core/providers/theme_provider.dart';
import 'core/providers/settings_provider.dart';

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
    final settingsAsync = ref.watch(settingsProvider);
    final seedColor = settingsAsync.value?.seedColorValue != null
        ? Color(settingsAsync.value!.seedColorValue)
        : AppTheme.defaultPrimary;

    return MaterialApp.router(
      title: 'Storybook',
      theme: AppTheme.light(seedColor),
      darkTheme: AppTheme.dark(seedColor),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
