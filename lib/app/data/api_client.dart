import 'package:dio/dio.dart';

import '../../auth/domain/auth_interceptor.dart';

final apiClient =
    Dio(
        BaseOptions(
          baseUrl: 'https://breach-api.qa.mvm-tech.xyz/api',
          connectTimeout: Duration(seconds: 60),
          receiveTimeout: Duration(seconds: 60),
          sendTimeout: Duration(seconds: 60),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      )
      ..interceptors.add(AuthInterceptor())
      ..interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: true,
          error: true,
        ),
      );
