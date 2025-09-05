import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

import '../../app/data/api_client.dart';
import '../../app/data/message_from_error.dart';
import '../../auth/domain/usecase.dart';
import '../data/model/interest.dart';

class OnboardingUseCase {
  static Future<List<Interest>> getSavedInterests() async {
    final prefs = await SharedPreferences.getInstance();
    var interests = prefs.getStringList('interests') ?? [];
    if (interests.isNotEmpty) {
      return interests.map((e) => Interest.fromJson(jsonDecode(e))).toList();
    }

    try {
      final creds = await AuthUseCase.getCredentials();
      if (creds == null) {
        return [];
      }

      final response = await apiClient.get<List<dynamic>>(
        '/users/${creds.userId}/interests',
      );
      prefs.setStringList(
        'interests',
        response.data?.map((e) => jsonEncode(e)).toList() ?? [],
      );
      return response.data
              ?.map((e) => Interest.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
    } catch (error, stackTrace) {
      toastification.show(
        title: Text('Failed to load interests'),
        description: Text(
          messageFromError(error: error, stackTrace: stackTrace),
        ),
        type: ToastificationType.error,
      );
      return [];
    }
  }

  static Future<void> skipInterestSelection() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('skipped_interest_selection', true);
  }

  static Future<bool> interestSelectionSkipped() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('skipped_interest_selection') ?? false;
  }
}
