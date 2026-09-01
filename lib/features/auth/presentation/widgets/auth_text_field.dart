

import 'package:flutter/material.dart';
import 'package:home_service/core/theme/app_colors.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  final bool isPassword;
  final bool obscurePassword;
  final VoidCallback? onTogglePassword;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.isPassword = false,
    this.obscurePassword = false,
    this.onTogglePassword,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: isPassword ? obscurePassword : false,
          textAlign: TextAlign.right,
          style: const TextStyle(
            fontFamily: 'IBMPlexSansArabic',
          ),
          decoration: InputDecoration(
            hintStyle: TextStyle(
              color: AppColors.textfromfield,
            ),
            hintText: hint,
            hintTextDirection: TextDirection.ltr,

            suffixIcon: Icon(
              icon,
              color: AppColors.primary,
            ),

            prefixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.primary,
                    ),
                    onPressed: onTogglePassword,
                  )
                : null,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          validator: validator,
        ),
      ),
    );
  }
}
