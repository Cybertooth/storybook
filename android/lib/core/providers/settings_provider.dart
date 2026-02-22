import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (_) => const FlutterSecureStorage(),
);

class AppSettings {
  final String geminiApiKey;
  final String openAiApiKey;
  final String aiProvider; // 'gemini' | 'openai'

  const AppSettings({
    this.geminiApiKey = '',
    this.openAiApiKey = '',
    this.aiProvider = 'gemini',
  });
}

class SettingsNotifier extends AsyncNotifier<AppSettings> {
  static const _geminiKey = 'gemini_api_key';
  static const _openAiKey = 'openai_api_key';
  static const _providerKey = 'ai_provider';

  @override
  Future<AppSettings> build() async {
    final storage = ref.read(secureStorageProvider);
    return AppSettings(
      geminiApiKey: await storage.read(key: _geminiKey) ?? '',
      openAiApiKey: await storage.read(key: _openAiKey) ?? '',
      aiProvider: await storage.read(key: _providerKey) ?? 'gemini',
    );
  }

  Future<void> updateSettings(
      {String? geminiKey, String? openAiKey, String? provider}) async {
    final storage = ref.read(secureStorageProvider);
    if (geminiKey != null)
      await storage.write(key: _geminiKey, value: geminiKey);
    if (openAiKey != null)
      await storage.write(key: _openAiKey, value: openAiKey);
    if (provider != null)
      await storage.write(key: _providerKey, value: provider);
    ref.invalidateSelf();
  }
}

final settingsProvider =
    AsyncNotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);
