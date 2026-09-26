import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';

class ProfileFieldStyle {
  ProfileFieldStyle._();

  static const Color iconColor = AppColors.figmaDarkGreen;
  static const Color background = AppColors.surface;
  static const Color borderColor = AppColors.figmaBoxBorder;
  static const double fieldHeight = AppDimensions.fieldHeight;
  static const double badgeSize = AppDimensions.verifiedBadgeSize;
  static const double iconSize = 22;
  static const double borderRadius = AppDimensions.radiusMd;

  static const TextStyle valueTextStyle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static BoxDecoration boxDecoration() => BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor),
      );

  static OutlineInputBorder enabledBorder() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: borderColor),
      );

  static OutlineInputBorder focusedBorder() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: borderColor, width: 1.5),
      );

  static OutlineInputBorder errorBorder() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: AppColors.error),
      );

  static OutlineInputBorder focusedErrorBorder() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      );

  static const TextStyle labelStyle = TextStyle(
    color: AppColors.figmaLabelGrey,
    fontSize: 13,
  );
}

class SolidCheckCircle extends StatelessWidget {
  const SolidCheckCircle({
    super.key,
    this.diameter = 20,
    this.iconSize = 12,
  });

  final double diameter;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: const BoxDecoration(
        color: AppColors.figmaDarkGreen,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.check, color: Colors.white, size: iconSize),
    );
  }
}
