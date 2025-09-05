import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../home/home_screen.dart';
import '../../onboarding/domain/usecase.dart';
import '../../onboarding/onboarding_screen.dart';
import '../../onboarding/welcome_screen.dart';
import '../data/dto.dart';

class AuthUseCase {
  static Future<LoginResponse?> getCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final creds = prefs.getString('creds');
    if (creds == null || creds.isEmpty) return null;

    return LoginResponse.fromJson(jsonDecode(creds));
  }

  static Future<bool> checkIsLoggedIn() async {
    final creds = await getCredentials();
    if (creds == null) return false;
    return creds.token.isNotEmpty && creds.userId > 0;
  }

  static Future<String> startingRoute() async {
    final isLoggedIn = await checkIsLoggedIn();
    if (!isLoggedIn) {
      return OnboardingScreen.route;
    }

    final interestsSkipped = await OnboardingUseCase.interestSelectionSkipped();
    if (interestsSkipped) {
      return HomeScreen.route;
    }

    final interests = await OnboardingUseCase.getSavedInterest();
    if (interests.isEmpty) {
      return WelcomeScreen.route;
    }

    return HomeScreen.route;
  }
}
