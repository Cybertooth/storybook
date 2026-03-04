import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/remote/gemini_ai_service.dart';
import '../../domain/services/ai_service.dart';
import 'settings_provider.dart';

/// Returns null if no API key is configured.
/// To switch to the NestJS backend proxy: replace GeminiAiService
/// with BackendProxyAiService (to be created in a future phase).
final aiServiceProvider = Provider<AiService?>((ref) {
  final settings = ref.watch(settingsProvider).value;
  if (settings == null || settings.geminiApiKey.isEmpty) return null;
  return GeminiAiService(settings.geminiApiKey);
});
