import 'package:flutter/material.dart';

import 'theme.dart';

class AppColors {
  final Color purple700 = const Color(0xFF6215F2);
  final Color purple600 = const Color(0xFF8311F9);

  final Color white;
  final Color black;
  final Color grey200;
  final Color grey300;
  final Color grey500;
  final Color grey600;
  final Color grey700;
  final Color grey900;
  final Color ghostWhite;
  final Color paleSilver;
  final Color magnolia;

  const AppColors({
    required this.white,
    required this.black,
    required this.grey200,
    required this.grey300,
    required this.grey500,
    required this.grey600,
    required this.grey700,
    required this.grey900,
    required this.ghostWhite,
    required this.paleSilver,
    required this.magnolia,
  });

  static AppColors of(BuildContext context) {
    return Theme.of(context).extension<AppTheme>()!.colors;
  }

  static const light = AppColors(
    white: Colors.white,
    black: Colors.black,
    grey200: Color(0xFFE7E7E7),
    grey300: Color(0xFFD6D6D6),
    grey500: Color(0xFF929292),
    grey600: Color(0xFF6A6A6A),
    grey700: Color(0xFF565656),
    grey900: Color(0xFF181818),
    ghostWhite: Color(0xFFFCFAFF),
    paleSilver: Color(0xFFC7C4BC),
    magnolia: Color(0xFFFAF2FF),
  );

  static const dark = AppColors(
    white: Colors.black,
    black: Colors.white,
    grey200: Color(0xFF2C2C2C),
    grey300: Color(0xFF3D3D3D),
    grey500: Color(0xFF7E7E7E),
    grey600: Color(0xFF9D9D9D),
    grey700: Color(0xFFB1B1B1),
    grey900: Colors.white,
    ghostWhite: Color(0xFF1C1B1F),
    paleSilver: Color(0xFF5A5955),
    magnolia: Color(0xFF2C223D),
  );
}
