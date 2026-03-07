import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/providers/auth_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final settings = await ref.read(settingsProvider.future);
      options.baseUrl = settings.backendUrl;

      final authState = await ref.read(authProvider.future);
      if (authState.isAuthenticated) {
        options.headers['Authorization'] = 'Bearer ${authState.token}';
      }

      return handler.next(options);
    },
  ));

  dio.interceptors.add(LogInterceptor(
    request: true,
    requestHeader: true,
    requestBody: true,
    responseHeader: true,
    responseBody: true,
    error: true,
  ));

  return dio;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref.watch(dioProvider));
});

class ApiClient {
  final Dio _dio;
  ApiClient(this._dio);

  Dio get dio => _dio;

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      return response.data;
    } on DioException catch (e) {
      return e.response?.data is Map<String, dynamic>
          ? e.response!.data as Map<String, dynamic>
          : {'success': false, 'message': e.message};
    }
  }

  Future<Map<String, dynamic>?> register(String email, String password) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'email': email,
        'password': password,
      });
      return response.data;
    } on DioException catch (e) {
      return e.response?.data is Map<String, dynamic>
          ? e.response!.data as Map<String, dynamic>
          : {'success': false, 'message': e.message};
    }
  }
}
