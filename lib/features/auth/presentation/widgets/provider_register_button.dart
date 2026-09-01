import 'package:flutter/material.dart';
import 'package:home_service/core/theme/app_colors.dart';

class ProviderRegisterButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const ProviderRegisterButton  ({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: AppColors.primary,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 16,
              fontFamily: 'IBMPlexSansArabic',
            ),
          ),
        ),
      ),
    );
  }
}

