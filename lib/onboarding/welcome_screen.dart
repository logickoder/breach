import 'package:flutter/material.dart';

import '../app/assets.dart';
import '../app/theme/colors.dart';
import 'select_interests_screen.dart';

class WelcomeScreen extends StatelessWidget {
  static const route = '/welcome';

  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Scaffold(
      backgroundColor: colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppAssets.welcomeImage),
              const SizedBox(height: 24),
              const FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Welcome to Breach 🥳',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Just a few quick questions to help personalise your Breach experience. Are you ready?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Navigator.pushNamed(
                  context,
                  SelectInterestsScreen.route,
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: colors.grey900,
                  foregroundColor: colors.white,
                ),
                child: Text('Let\'s begin!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
