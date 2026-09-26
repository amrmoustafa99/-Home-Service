import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../data/models/address_model.dart';
import '../../data/models/addresses_copy.dart';
import '../../logic/cubit/address_cubit.dart';
import 'address_actions_bottom_sheet.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({super.key, required this.address});

  final AddressModel address;

  static const double _badgeSize = 32;
  static const double _badgeIconSize = 20;

  static const TextStyle _titleTextStyle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: -0.36,
  );

  static const TextStyle _detailsTextStyle = TextStyle(
    color: AppColors.figmaLabelGrey,
    fontSize: 16,
    fontFamily: 'IBMPlexSansArabic',
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: -0.32,
  );

  static const String _detailsSeparator = '، ';

  static String _detailsLine(AddressModel address) =>
      '${address.governorate}$_detailsSeparator'
      '${address.city}$_detailsSeparator'
      '${address.addressDetails}';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spacingLg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _AddressBadge(),
            const SizedBox(width: AppDimensions.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          address.title,
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          style: _titleTextStyle,
                        ),
                      ),
                      if (address.isDefault) ...[
                        const SizedBox(width: AppDimensions.spacingSm),
                        const _DefaultAddressPill(),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacingSm),
                  Text(
                    _detailsLine(address),
                    textAlign: TextAlign.right,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: _detailsTextStyle,
                  ),
                ],
              ),
            ),
            _KebabButton(address: address),
          ],
        ),
      ),
    );
  }
}

class _AddressBadge extends StatelessWidget {
  const _AddressBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AddressCard._badgeSize,
      height: AddressCard._badgeSize,
      decoration: const BoxDecoration(
        color: AppColors.lightGrey,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.home_outlined,
        size: AddressCard._badgeIconSize,
        color: AppColors.primary,
      ),
    );
  }
}

class _DefaultAddressPill extends StatelessWidget {
  const _DefaultAddressPill();

  static const double _pillWidth = 96;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _pillWidth,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingSm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text(
        AddressesCopy.defaultPill,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontFamily: 'IBMPlexSansArabic',
          fontWeight: FontWeight.w500,
          height: 1.8,
          letterSpacing: -0.2,
        ),
      ),
    );
  }
}

class _KebabButton extends StatelessWidget {
  const _KebabButton({required this.address});

  final AddressModel address;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showAddressActionsBottomSheet(
          context,
          address: address,
          cubit: context.read<AddressCubit>(),
        );
      },
      icon: const Icon(
        Icons.more_vert,
        color: AppColors.textSecondary,
        size: 24,
      ),
      tooltip: AddressesCopy.moreOptions,
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
    );
  }
}