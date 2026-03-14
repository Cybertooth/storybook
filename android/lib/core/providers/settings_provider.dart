import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (_) => const FlutterSecureStorage(),
);

class AppSettings {
  final String geminiApiKey;
  final String openAiApiKey;
  final String aiProvider; // 'gemini' | 'openai'
  final String backendUrl;
  final int seedColorValue;

  const AppSettings({
    this.geminiApiKey = '',
    this.openAiApiKey = '',
    this.aiProvider = 'gemini',
    this.backendUrl = 'https://storybook-backend-sfknzwjwga-uc.a.run.app/api/v1',
    this.seedColorValue = 0xFF6366F1, // Default vibrant indigo
  });
}

class SettingsNotifier extends AsyncNotifier<AppSettings> {
  static const _geminiKey = 'gemini_api_key';
  static const _openAiKey = 'openai_api_key';
  static const _providerKey = 'ai_provider';
  static const _backendUrlKey = 'backend_url';
  static const _seedColorKey = 'seed_color';

  @override
  Future<AppSettings> build() async {
    final storage = ref.read(secureStorageProvider);

    int seedColor = 0xFF6366F1;
    final seedStr = await storage.read(key: _seedColorKey);
    if (seedStr != null) {
      seedColor = int.tryParse(seedStr) ?? 0xFF6366F1;
    }

    return AppSettings(
      geminiApiKey: await storage.read(key: _geminiKey) ?? '',
      openAiApiKey: await storage.read(key: _openAiKey) ?? '',
      aiProvider: await storage.read(key: _providerKey) ?? 'gemini',
      backendUrl: await storage.read(key: _backendUrlKey) ??
          'https://storybook-backend-sfknzwjwga-uc.a.run.app/api/v1',
      seedColorValue: seedColor,
    );
  }

  Future<void> updateSettings({
    String? geminiKey,
    String? openAiKey,
    String? provider,
    String? backendUrl,
    int? seedColorValue,
  }) async {
    final storage = ref.read(secureStorageProvider);
    if (geminiKey != null) {
      await storage.write(key: _geminiKey, value: geminiKey);
    }
    if (openAiKey != null) {
      await storage.write(key: _openAiKey, value: openAiKey);
    }
    if (provider != null) {
      await storage.write(key: _providerKey, value: provider);
    }
    if (backendUrl != null) {
      await storage.write(key: _backendUrlKey, value: backendUrl);
    }
    if (seedColorValue != null) {
      await storage.write(key: _seedColorKey, value: seedColorValue.toString());
    }
    ref.invalidateSelf();
  }
}

final settingsProvider =
    AsyncNotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);
