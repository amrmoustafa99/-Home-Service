import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';

/// Small green checkmark row used to indicate a verified field
/// (e.g. "رقم الهاتف موثق") in the profile screens.
class VerifiedBadge extends StatelessWidget {
  const VerifiedBadge({super.key, required this.text, this.iconSize = 16});

  final String text;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check_circle, color: AppColors.primary, size: iconSize),
        const SizedBox(width: AppDimensions.spacingXs),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}