import 'package:dio/dio.dart';

import 'usecase.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final creds = await AuthUseCase.getCredentials();
      if (creds != null) {
        options.headers['Authorization'] = 'Bearer ${creds.token}';
      }
    } finally {
      handler.next(options);
    }
  }
}
