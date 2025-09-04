import 'package:dio/dio.dart';

final apiClient = Dio(
  BaseOptions(
    baseUrl: 'https://breach-api.qa.mvm-tech.xyz/api',
    connectTimeout: Duration(seconds: 60),
    receiveTimeout: Duration(seconds: 60),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ),
);
