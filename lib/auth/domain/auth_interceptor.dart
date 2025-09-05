import 'dart:convert';

import 'package:breach/auth/data/dto.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final creds = prefs.getString('creds');
      if (creds != null && creds.isNotEmpty) {
        final data = LoginResponse.fromJson(jsonDecode(creds));
        options.headers['Authorization'] = 'Bearer ${data.token}';
      }
    } finally {
      handler.next(options);
    }
  }
}
