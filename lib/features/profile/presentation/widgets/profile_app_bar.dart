import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimensions.dart';

class ProfileHeader extends StatelessWidget implements PreferredSizeWidget {
  const ProfileHeader({super.key, required this.title});

  final String title;

  @override
  Size get preferredSize =>
      const Size.fromHeight(AppDimensions.headerHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.headerHeight,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingLg),
      child: Row(
        children: [
          Image.asset(
            'assets/images/ca65bd77edea517c72330e73fec51aa6a1430b34.png',
            width: AppDimensions.headerLogoWidth,
            height: AppDimensions.headerLogoHeight,
            fit: BoxFit.contain,
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.keyboard_arrow_left,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
