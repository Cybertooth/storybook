import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/remote/api_client.dart';
import 'settings_provider.dart';

class AuthState {
  final String? token;
  final bool isLoading;
  final String? error;
  final bool isOfflineMode;

  const AuthState({
    this.token,
    this.isLoading = false,
    this.error,
    this.isOfflineMode = false,
  });

  bool get isAuthenticated => token != null && token!.isNotEmpty;

  AuthState copyWith({
    String? token,
    bool? isLoading,
    String? error,
    bool clearError = false,
    bool? isOfflineMode,
  }) {
    return AuthState(
      token: token ?? this.token,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      isOfflineMode: isOfflineMode ?? this.isOfflineMode,
    );
  }
}

class AuthNotifier extends AsyncNotifier<AuthState> {
  static const _tokenKey = 'jwt_token';

  @override
  Future<AuthState> build() async {
    final storage = ref.read(secureStorageProvider);
    final token = await storage.read(key: _tokenKey);
    return AuthState(token: token);
  }

  Future<bool> login(String email, String password) async {
    state = AsyncData(
        state.value?.copyWith(isLoading: true, clearError: true) ??
            const AuthState(isLoading: true));
    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.login(email, password);

      if (response != null && response['success'] == true) {
        final token = response['data']['access_token'] as String;
        final storage = ref.read(secureStorageProvider);
        await storage.write(key: _tokenKey, value: token);

        state = AsyncData(AuthState(token: token));
        return true;
      } else {
        state = AsyncData(state.value?.copyWith(
              isLoading: false,
              error: response?['message']?.toString() ?? 'Login failed',
            ) ??
            AuthState(
                isLoading: false,
                error: response?['message']?.toString() ?? 'Login failed'));
        return false;
      }
    } catch (e) {
      state = AsyncData(state.value?.copyWith(
            isLoading: false,
            error: e.toString(),
          ) ??
          AuthState(isLoading: false, error: e.toString()));
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    state = AsyncData(
        state.value?.copyWith(isLoading: true, clearError: true) ??
            const AuthState(isLoading: true));
    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.register(email, password);

      if (response != null && response['success'] == true) {
        // Registration successful. Now try to login to get standard token.
        return await login(email, password);
      } else {
        state = AsyncData(state.value?.copyWith(
              isLoading: false,
              error: response?['message']?.toString() ?? 'Registration failed',
            ) ??
            AuthState(
                isLoading: false,
                error:
                    response?['message']?.toString() ?? 'Registration failed'));
        return false;
      }
    } catch (e) {
      state = AsyncData(state.value?.copyWith(
            isLoading: false,
            error: e.toString(),
          ) ??
          AuthState(isLoading: false, error: e.toString()));
      return false;
    }
  }

  Future<void> logout() async {
    final storage = ref.read(secureStorageProvider);
    await storage.delete(key: _tokenKey);
    state = const AsyncData(AuthState());
  }

  void continueOffline() {
    state = AsyncData(
        state.value?.copyWith(isOfflineMode: true, clearError: true) ??
            const AuthState(isOfflineMode: true));
  }
}

final authProvider =
    AsyncNotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
