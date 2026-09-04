import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';

class VerifiedBadge extends StatelessWidget {
  const VerifiedBadge({
    super.key,
    required this.text,
    this.pill = false,
  });

  static const double checkmarkSize = 16;

  final String text;
  final bool pill;

  @override
  Widget build(BuildContext context) {
    if (pill) return _buildPill();
    return _buildRow();
  }

  Widget _buildPill() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingSm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: AppColors.primary, size: 12),
          const SizedBox(width: 3),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.primaryDark,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.check_circle_outline,
          color: AppColors.figmaVerifiedGreen,
          size: checkmarkSize,
        ),
        const SizedBox(width: AppDimensions.spacingXs),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.figmaVerifiedGreen,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
