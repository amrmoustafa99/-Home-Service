import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';

class PrimaryActionBar extends StatelessWidget {
  const PrimaryActionBar({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isBusy = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.bottomBarPaddingH,
        vertical: AppDimensions.bottomBarPaddingV,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: AppDimensions.primaryActionHeight,
          child: FilledButton(
            onPressed: isBusy ? null : onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.figmaDarkGreen,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.primaryLight,
              elevation: 6,
              shadowColor: AppColors.figmaDarkGreen.withValues(alpha: 0.35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.primaryActionRadius,
                ),
              ),
            ),
            child: isBusy
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: 20, color: Colors.white),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
