import 'dart:io';

import 'package:dio/dio.dart';

import '../logger.dart';

String messageFromError({
  required Object error,
  StackTrace? stackTrace,
  String? message,
}) {
  dynamic errorMessage;

  try {
    if ((error is DioException && error.error is SocketException) ||
        error is SocketException) {
      errorMessage = 'Please check your internet connection and try again';
    } else if (error is DioException) {
      if (error.response?.data != null) {
        errorMessage =
            error.response?.data['message'] ??
            error.response?.data['error'] ??
            message;
      } else {
        errorMessage =
            error.message ??
            (error.error as dynamic)?.message ??
            message ??
            'An error Occurred';
      }
    } else {
      errorMessage = message ?? (error as dynamic)?.message;
    }
  } catch (error, stackTrace) {
    errorMessage = error.toString();
    logger.e(
      'Failed to get error message',
      error: error,
      stackTrace: stackTrace,
    );
  }

  logger.e(
    errorMessage,
    error: error,
    stackTrace: stackTrace,
  );

  return errorMessage;
}
