import 'package:flutter/material.dart';

import 'theme.dart';

class AppColors {
  final Color purple700 = const Color(0xFF6215F2);
  final Color purple600 = const Color(0xFF8311F9);

  final Color white;
  final Color black;
  final Color grey900;

  const AppColors({
    required this.white,
    required this.black,
    required this.grey900,
  });

  static AppColors of(BuildContext context) {
    return Theme.of(context).extension<AppTheme>()!.colors;
  }

  static const light = AppColors(
    white: Colors.white,
    black: Colors.black,
    grey900: Color(0xFF181818),
  );

  static const dark = AppColors(
    white: Colors.black,
    black: Colors.white,
    grey900: Colors.white,
  );
}
