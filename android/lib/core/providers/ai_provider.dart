import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/remote/api_client.dart';
import '../../data/remote/backend_proxy_ai_service.dart';
import '../../data/remote/gemini_ai_service.dart';
import '../../domain/services/ai_service.dart';
import 'auth_provider.dart';
import 'settings_provider.dart';

/// Provides the active [AiService] implementation.
///
/// Priority:
/// 1. When the user is authenticated → use the backend AI proxy (no API key required on device).
/// 2. When offline with a Gemini key configured → use Gemini directly.
/// 3. Otherwise → null (AI features unavailable; screens show a banner).
final aiServiceProvider = Provider<AiService?>((ref) {
  final auth = ref.watch(authProvider).value;
  if (auth != null && auth.isAuthenticated) {
    return BackendProxyAiService(ref.watch(apiClientProvider));
  }

  final settings = ref.watch(settingsProvider).value;
  if (settings != null && settings.geminiApiKey.isNotEmpty) {
    return GeminiAiService(settings.geminiApiKey);
  }

  return null;
});
