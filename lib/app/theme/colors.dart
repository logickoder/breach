import 'package:flutter/material.dart';

import 'theme.dart';

class AppColors {
  final Color purple700 = const Color(0xFF6215F2);
  final Color purple600 = const Color(0xFF8311F9);

  final Color white;
  final Color black;
  final Color grey900;
  final Color ghostWhite;

  const AppColors({
    required this.white,
    required this.black,
    required this.grey900,
    required this.ghostWhite,
  });

  static AppColors of(BuildContext context) {
    return Theme.of(context).extension<AppTheme>()!.colors;
  }

  static const light = AppColors(
    white: Colors.white,
    black: Colors.black,
    grey900: Color(0xFF181818),
    ghostWhite: Color(0xFFFCFAFF),
  );

  static const dark = AppColors(
    white: Colors.black,
    black: Colors.white,
    grey900: Colors.white,
    ghostWhite: Color(0xFF1C1B1F),
  );
}
