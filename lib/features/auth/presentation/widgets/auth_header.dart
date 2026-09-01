import 'package:flutter/material.dart';
import 'package:home_service/core/constants/app_assets.dart';
import 'package:home_service/core/theme/app_colors.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: SizedBox(
        height: 130,
        child: Stack(
          children: [
            Positioned(
              top: 15,
              right: 16,
              child: SizedBox(
                width: 108,
                height: 30,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFFF7F7F7,
                    ).withValues(alpha: 0.2),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/FoundationHome',
                    );
                  },
                  child: Text(
                    'تصفح كزائر',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontFamily: 'IBMPlexSansArabic',
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),

            Align(
              alignment: Alignment.center,
              child: Image.asset(
                AppAssets.logo,
                width: 85,
                height: 70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
