import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimensions.dart';
import 'profile_field_style.dart';

class InfoCardTile extends StatelessWidget {
  const InfoCardTile({
    super.key,
    required this.label,
    required this.value,
    required this.mainIcon,
    this.showCheck = false,
    this.badge,
  });

  final String label;
  final String value;
  final IconData mainIcon;
  final bool showCheck;
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          textAlign: TextAlign.right,
          style: ProfileFieldStyle.labelStyle,
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        Container(
          height: ProfileFieldStyle.fieldHeight,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingLg,
          ),
          decoration: ProfileFieldStyle.boxDecoration(),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              children: [
                Icon(mainIcon,
                    color: ProfileFieldStyle.iconColor,
                    size: ProfileFieldStyle.iconSize),
                const SizedBox(width: AppDimensions.spacingMd),
                Expanded(
                  child: Text(
                    value,
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: ProfileFieldStyle.valueTextStyle,
                  ),
                ),
                if (showCheck) ...[
                  const Spacer(),
                  const SolidCheckCircle(),
                ],
              ],
            ),
          ),
        ),
        if (badge != null)
          Padding(
            padding: const EdgeInsets.only(
              top: AppDimensions.verifiedGap,
              right: AppDimensions.spacingXs,
            ),
            child: badge,
          ),
      ],
    );
  }
}
