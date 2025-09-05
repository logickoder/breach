import 'package:flutter/material.dart';

import '../../app/theme/colors.dart';

class CategoryChip extends StatelessWidget {
  final String name;
  final String icon;
  final bool selected;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.name,
    required this.icon,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const duration = Durations.medium1;

    final colors = AppColors.of(context);
    final borderRadius = BorderRadius.circular(8);

    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      splashColor: colors.purple700,
      child: AnimatedContainer(
        duration: duration,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: colors.paleSilver),
          borderRadius: borderRadius,
          color: selected ? colors.purple600 : colors.white,
        ),
        child: AnimatedDefaultTextStyle(
          duration: duration,
          style: TextStyle(
            color: selected ? Colors.white : colors.grey900,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
          child: Text('$icon $name'),
        ),
      ),
    );
  }
}
