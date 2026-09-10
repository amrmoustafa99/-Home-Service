import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../data/models/addresses_copy.dart';

class AddAddressTextField extends StatelessWidget {
  const AddAddressTextField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.hintText,
    this.helperText,
    this.textInputAction,
    this.maxLines = 1,
  });

  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? hintText;
  final String? helperText;
  final TextInputAction? textInputAction;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AddAddressFieldStyle.labelStyle),
        const SizedBox(height: AppDimensions.spacingSm),
        TextFormField(
          controller: controller,
          validator: validator,
          textInputAction: textInputAction,
          textAlign: TextAlign.right,
          maxLines: maxLines,
          style: AddAddressFieldStyle.valueStyle,
          decoration: AddAddressFieldStyle.inputDecoration(
            hintText: hintText,
            helperText: helperText,
          ),
        ),
      ],
    );
  }
}

class LocationDropdownField<T> extends StatelessWidget {
  const LocationDropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.hint,
    required this.onChanged,
    this.initialValue,
    this.validator,
    this.enabled = true,
    this.isLoading = false,
    this.helperText,
  });

  final String label;
  final List<DropdownMenuItem<T>> items;
  final String hint;
  final T? initialValue;
  final ValueChanged<T?> onChanged;
  final FormFieldValidator<T>? validator;
  final bool enabled;
  final bool isLoading;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AddAddressFieldStyle.labelStyle),
        const SizedBox(height: AppDimensions.spacingSm),
        DropdownButtonFormField<T>(
          isExpanded: true,
          isDense: true,
          items: items,
          initialValue: initialValue,
          hint: Text(hint, style: AddAddressFieldStyle.hintStyle),
          onChanged: enabled ? onChanged : null,
          validator: validator,
          decoration: AddAddressFieldStyle.inputDecoration(
            suffixIcon: isLoading
                ? const Padding(
                    padding: EdgeInsets.only(left: AppDimensions.spacingMd),
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.figmaDarkGreen,
                      ),
                    ),
                  )
                : null,
            helperText: helperText,
          ),
        ),
      ],
    );
  }
}

class DefaultToggleRow extends StatelessWidget {
  const DefaultToggleRow({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingLg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        border: Border.all(
          color: AddAddressFieldStyle.borderColor,
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Flexible(
            child: Text(
              AddressesCopy.defaultToggleLabel,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.lightGrey,
          ),
        ],
      ),
    );
  }
}

class SubmitBar extends StatelessWidget {
  const SubmitBar({
    super.key,
    required this.label,
    required this.isBusy,
    required this.onPressed,
  });

  final String label;
  final bool isBusy;
  final VoidCallback onPressed;

  static const double _buttonHeight = 60;

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
          height: _buttonHeight,
          child: FilledButton(
            onPressed: isBusy ? null : onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.primaryLight,
              elevation: 6,
              shadowColor: AppColors.primary.withValues(alpha: 0.35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
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
                      const Icon(Icons.add, size: 20, color: Colors.white),
                      const SizedBox(width: AppDimensions.spacingSm),
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

abstract final class AddAddressFieldStyle {
  static const Color borderColor = AppColors.textfromfield;
  static const Color focusedColor = AppColors.figmaDarkGreen;

  static const TextStyle labelStyle = TextStyle(
    color: AppColors.figmaLabelGrey,
    fontSize: 12,
  );

  static const TextStyle hintStyle = TextStyle(
    color: AppColors.textfromfield,
    fontSize: 14,
  );

  static const TextStyle helperStyle = TextStyle(
    color: AppColors.textfromfield,
    fontSize: 12,
  );

  static const TextStyle valueStyle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 14,
  );

  static OutlineInputBorder _border(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  static InputDecoration inputDecoration({
    String? hintText,
    String? helperText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      helperText: helperText,
      helperStyle: helperStyle,
      isDense: true,
      filled: false,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingLg,
        vertical: AppDimensions.spacingLg,
      ),
      enabledBorder: _border(borderColor, 0.5),
      focusedBorder: _border(focusedColor, 1.5),
      errorBorder: _border(AppColors.error, 1),
      focusedErrorBorder: _border(AppColors.error, 1.5),
    );
  }
}

abstract final class Validators {
  static String? requiredText(String? value, String message) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }
}