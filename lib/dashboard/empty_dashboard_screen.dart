import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app/theme/colors.dart';

class EmptyDashboardScreen extends StatelessWidget {
  final String title;
  final String icon;

  const EmptyDashboardScreen({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.ghostWhite,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              width: 64,
              height: 64,
              colorFilter: ColorFilter.mode(colors.grey600, BlendMode.srcIn),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: colors.grey900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming Soon',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 16,
                color: colors.grey600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
