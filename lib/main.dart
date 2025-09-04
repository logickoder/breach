import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/theme/colors.dart';
import 'app/theme/theme.dart';
import 'auth/auth_screen.dart';
import 'auth/domain/auth_screen_type.dart';
import 'onboarding/onboarding_screen.dart';
import 'onboarding/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Breach',
      debugShowCheckedModeBanner: false,
      theme: AppTheme(colors: AppColors.light).get(ThemeData.light()),
      darkTheme: AppTheme(colors: AppColors.dark).get(ThemeData.dark()),
      builder: (context, child) {
        final isDark =
            MediaQuery.platformBrightnessOf(context) == Brightness.dark;
        return AnnotatedRegion(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: isDark
                ? Brightness.light
                : Brightness.dark,
            statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
          ),
          child: child!,
        );
      },
      routes: {
        OnboardingScreen.route: (_) => const OnboardingScreen(),
        for (var type in AuthScreenType.values) ...{
          AuthScreen.route(type): (_) => AuthScreen(type: type),
        },
        WelcomeScreen.route: (_) => const WelcomeScreen(),
      },
    );
  }
}
