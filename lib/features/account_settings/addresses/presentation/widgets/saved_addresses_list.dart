import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../data/models/address_model.dart';
import '../../data/models/addresses_copy.dart';
import 'address_card.dart';

class SavedAddressesList extends StatelessWidget {
  const SavedAddressesList({
    super.key,
    required this.addresses,
    this.isRefreshing = false,
    this.errorMessage,
    this.showErrorBanner = false,
    this.onDismissError,
  });

  final List<AddressModel> addresses;
  final bool isRefreshing;
  final String? errorMessage;
  final bool showErrorBanner;
  final VoidCallback? onDismissError;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (errorMessage != null && showErrorBanner && onDismissError != null)
          _ErrorBanner(message: errorMessage!, onDismiss: onDismissError!),
        if (isRefreshing)
          const LinearProgressIndicator(
            minHeight: 3,
            color: AppColors.figmaDarkGreen,
            backgroundColor: AppColors.lightGrey,
          ),
        Expanded(
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(AppDimensions.spacingLg),
            itemCount: addresses.length + 1,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppDimensions.spacingLg),
            itemBuilder: (context, index) {
              if (index == 0) return const _SavedAddressesHeading();
              return AddressCard(address: addresses[index - 1]);
            },
          ),
        ),
      ],
    );
  }
}

class _SavedAddressesHeading extends StatelessWidget {
  const _SavedAddressesHeading();

  static const TextStyle _headingTextStyle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: -0.36,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        AddressesCopy.savedHeading,
        textAlign: TextAlign.right,
        style: _headingTextStyle,
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message, required this.onDismiss});

  final String message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(
        AppDimensions.spacingLg,
        AppDimensions.spacingLg,
        AppDimensions.spacingLg,
        0,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingMd,
        vertical: AppDimensions.spacingSm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        border: Border.all(color: AppColors.error),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 18),
            const SizedBox(width: AppDimensions.spacingSm),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontFamily: 'IBMPlexSansArabic',
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
            ),
            IconButton(
              onPressed: onDismiss,
              icon: const Icon(
                Icons.close,
                color: AppColors.textSecondary,
                size: 18,
              ),
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
          ],
        ),
      ),
    );
  }
}