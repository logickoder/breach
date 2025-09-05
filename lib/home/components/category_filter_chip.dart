import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/theme/colors.dart';

class CategoryFilterChip extends StatelessWidget {
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryFilterChip({
    super.key,
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colors.purple600 : colors.grey200,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? colors.purple600 : colors.grey300,
          ),
        ),
        child: Center(
          child: Text(
            name,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : colors.grey700,
            ),
          ),
        ),
      ),
    );
  }
}
