import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimensions.dart';
import '../../data/models/offers_copy.dart';

class OffersInfoCard extends StatelessWidget {
  const OffersInfoCard({super.key});

  static const Color _cardBackground = Color(0xFFD8F0E2);
  static const Color _titleColor = Color(0xFF146E58);
  static const Color _textColor = Color(0xFF707070);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spacingLg),
      decoration: ShapeDecoration(
        color: _cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: _titleColor, size: 24),
          const SizedBox(width: AppDimensions.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  OffersCopy.howToUseTitle,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: _titleColor,
                    fontSize: 18,
                    fontFamily: 'IBMPlexSansArabic',
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                    letterSpacing: -0.36,
                  ),
                ),
                SizedBox(height: AppDimensions.spacingXs),
                Text(
                  OffersCopy.howToUseDescription,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: _textColor,
                    fontSize: 14,
                    fontFamily: 'IBMPlexSansArabic',
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                    letterSpacing: -0.32,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
