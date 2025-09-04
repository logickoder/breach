import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class AppTheme extends ThemeExtension<AppTheme> {
  final AppColors colors;

  const AppTheme({required this.colors});

  static AppTheme of(BuildContext context) {
    return Theme.of(context).extension<AppTheme>()!;
  }

  @override
  ThemeExtension<AppTheme> copyWith({AppColors? colors}) {
    return AppTheme(colors: colors ?? this.colors);
  }

  @override
  ThemeExtension<AppTheme> lerp(
    covariant ThemeExtension<AppTheme>? other,
    double t,
  ) {
    return this;
  }

  ThemeData get(ThemeData base) {
    final buttonTheme = FilledButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      foregroundColor: Colors.white,
      backgroundColor: colors.purple600,
      textStyle: GoogleFonts.inter().copyWith(
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
      disabledBackgroundColor: colors.grey300,
      disabledForegroundColor: Colors.white,
    );

    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors.purple600,
        primary: colors.purple600,
        onPrimary: colors.white,
        surface: colors.white,
        onSurface: colors.grey900,
      ),
      extensions: [this],
      scaffoldBackgroundColor: colors.white,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom().merge(buttonTheme),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: colors.purple600, width: 1),
          backgroundColor: Colors.transparent,
          foregroundColor: colors.purple600,
        ).merge(buttonTheme),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom().merge(buttonTheme),
      ),
      inputDecorationTheme: () {
        final border = OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.grey200, width: 1),
        );
        return InputDecorationTheme(
          border: border,
          outlineBorder: border.borderSide,
          enabledBorder: border,
          focusedBorder: OutlineInputBorder(
            borderRadius: border.borderRadius,
            borderSide: BorderSide(color: colors.purple600, width: 1),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          hintStyle: TextStyle(color: colors.grey900, fontSize: 14),
          prefixIconColor: colors.grey900,
          suffixIconColor: colors.grey900,
        );
      }(),
      textTheme: GoogleFonts.interTextTheme()
          .apply(bodyColor: colors.grey900, displayColor: colors.grey900)
          .copyWith(bodyLarge: TextStyle(fontSize: 14, color: colors.black)),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colors.grey900,
        selectionHandleColor: colors.grey900,
      ),
      dividerColor: colors.black,
    );
  }
}
