import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'theme_provider.g.dart';

class AppThemeMode extends Notifier<ThemeMode> {
  static const _themeKey = 'app_theme_mode';

  @override
  ThemeMode build() {
    // Default to dark mode; load saved preference asynchronously.
    _loadSaved();
    return ThemeMode.dark;
  }

  Future<void> _loadSaved() async {
    const storage = FlutterSecureStorage();
    final saved = await storage.read(key: _themeKey);
    if (saved != null) {
      try {
        state = saved == 'light' ? ThemeMode.light : ThemeMode.dark;
      } catch (_) {
        // Provider may have been replaced during hot restart; ignore.
      }
    }
  }

  void toggle() {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    state = next;
    _persist(next);
  }

  void set(ThemeMode mode) {
    state = mode;
    _persist(mode);
  }

  Future<void> _persist(ThemeMode mode) async {
    const storage = FlutterSecureStorage();
    await storage.write(
        key: _themeKey, value: mode == ThemeMode.dark ? 'dark' : 'light');
  }
}
