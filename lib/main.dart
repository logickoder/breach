import 'package:flutter/material.dart';

import 'app/theme/colors.dart';
import 'app/theme/theme.dart';
import 'onboarding/onboarding_screen.dart';

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
      routes: {
        OnboardingScreen.route: (_) => const OnboardingScreen(),
      },
    );
  }
}
