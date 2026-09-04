import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimensions.dart';
import 'profile_field_style.dart';

class ProfileTextField extends StatelessWidget {
  const ProfileTextField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.hintText,
    this.verticalContentPadding = 16,
  });

  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? hintText;
  final double verticalContentPadding;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: ProfileFieldStyle.labelStyle,
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textAlign: TextAlign.right,
          style: ProfileFieldStyle.valueTextStyle,
          decoration: InputDecoration(
            hintText: hintText,
            filled: false,
            isDense: true,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            suffixIconConstraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
              maxWidth: 32,
              maxHeight: 32,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: verticalContentPadding,
            ),
            enabledBorder: ProfileFieldStyle.enabledBorder(),
            focusedBorder: ProfileFieldStyle.focusedBorder(),
            errorBorder: ProfileFieldStyle.errorBorder(),
            focusedErrorBorder: ProfileFieldStyle.focusedErrorBorder(),
          ),
        ),
      ],
    );
  }
}
