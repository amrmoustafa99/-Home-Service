import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';

class HowItWorksStep extends StatelessWidget {
  const HowItWorksStep({
    super.key,
    required this.icon,
    required this.number,
    required this.title,
    required this.subtitle,
  });

  static const TextStyle _titleTextStyle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 14,
    fontFamily: 'IBMPlexSansArabic',
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: -0.28,
  );

  static const TextStyle _subtitleTextStyle = TextStyle(
    color: AppColors.textfromfield,
    fontSize: 12,
    fontFamily: 'IBMPlexSansArabic',
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: -0.24,
  );

  static const TextStyle _numberTextStyle = TextStyle(
    color: AppColors.figmaDarkGreen,
    fontSize: 18,
    fontFamily: 'IBMPlexSansArabic',
    fontWeight: FontWeight.w700,
    height: 1.56,
  );

  final IconData icon;
  final String number;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingLg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.all(Radius.circular(AppDimensions.radiusSm)),
      ),
      child: Row(
        children: [
          StepBadge(child: Icon(icon, color: AppColors.figmaDarkGreen, size: 20)),
          const SizedBox(width: AppDimensions.spacingLg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(title, textAlign: TextAlign.right, style: _titleTextStyle),
                const SizedBox(height: AppDimensions.spacingXs),
                Text(
                  subtitle,
                  textAlign: TextAlign.right,
                  style: _subtitleTextStyle,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.spacingLg),
          StepBadge(
            child: Text(
              number,
              textAlign: TextAlign.center,
              style: _numberTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}

class StepBadge extends StatelessWidget {
  const StepBadge({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.all(Radius.circular(AppDimensions.radiusSm)),
      ),
      child: Center(child: child),
    );
  }
}