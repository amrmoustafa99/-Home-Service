

import 'package:flutter/material.dart';
import 'package:home_service/core/theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double elevation;
  final double width;
  final double height;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.elevation = 0,
    this.width = 363,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: textColor ?? Colors.white,
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 12,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: textColor ?? Colors.white,
            fontWeight: FontWeight.w600,
            fontFamily: 'IBMPlexSansArabic',
          ),
        ),
      ),
    );
  }
}

