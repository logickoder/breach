import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app/theme/colors.dart';

class OnboardingScreen extends StatelessWidget {
  static const route = '/';

  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Scaffold(
      backgroundColor: colors.ghostWhite,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/onboarding.gif'),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsetsGeometry.symmetric(horizontal: 32),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text.rich(
                  TextSpan(
                    text: 'Find ',
                    children: [
                      TextSpan(
                        text: 'Great',
                        style: TextStyle(color: colors.purple600),
                      ),
                      const TextSpan(text: ' Ideas'),
                    ],
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 32),
              child: Text(
                'Subscribe to your favourite creators and thinkers. Support work that matters',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () {},
              child: Text(
                'Join Breach',
                style: GoogleFonts.spaceGrotesk().copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
