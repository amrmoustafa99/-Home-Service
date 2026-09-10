import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../data/models/address_model.dart';
import '../../data/models/addresses_copy.dart';
import '../../logic/cubit/address_cubit.dart';
import '../screens/add_address_screen.dart';

const TextStyle _labelTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
  height: 1.5,
  letterSpacing: -0.36,
);

Future<void> showAddressActionsBottomSheet(
  BuildContext context, {
  required AddressModel address,
  required AddressCubit cubit,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (_) => _AddressActionsSheet(address: address, cubit: cubit),
  );
}

class _AddressActionsSheet extends StatelessWidget {
  const _AddressActionsSheet({required this.address, required this.cubit});

  final AddressModel address;
  final AddressCubit cubit;

  void _onEdit(BuildContext context) {
    final navigator = Navigator.of(context);
    navigator.pop();
    navigator.push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: AddAddressScreen(existingAddress: address),
        ),
      ),
    );
  }

  void _onSetDefault(BuildContext context) {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    navigator.pop();
    cubit.setDefaultAddress(address.id!);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(_successSnackBar(AddressesCopy.setDefaultSuccess));
  }

  Future<void> _onDelete(BuildContext context) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await _confirmDelete(context);
    if (!confirmed) return;
    if (!context.mounted) return;
    navigator.pop();
    cubit.deleteAddress(address.id!);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(_successSnackBar(AddressesCopy.deleteSuccess));
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text(AddressesCopy.deleteAddress),
          content: const Text(AddressesCopy.deleteConfirmMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text(AddressesCopy.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text(AddressesCopy.confirmDelete),
            ),
          ],
        ),
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final actionColor = AppColors.textfromfield;
    final deleteColor = AppColors.error;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.spacingLg,
            AppDimensions.spacingMd,
            AppDimensions.spacingLg,
            AppDimensions.spacingXl,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppDimensions.radiusXl),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingLg),
              if (!address.isDefault) ...[
                _ActionRow(
                  icon: Icons.location_on_outlined,
                  label: AddressesCopy.setDefault,
                  color: actionColor,
                  onTap: () => _onSetDefault(context),
                ),
                const SizedBox(height: AppDimensions.spacingSm),
              ],
              _ActionRow(
                icon: Icons.edit_outlined,
                label: AddressesCopy.editAddress,
                color: actionColor,
                onTap: () => _onEdit(context),
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              _ActionRow(
                icon: Icons.delete_outline,
                label: AddressesCopy.deleteAddress,
                color: deleteColor,
                onTap: () => _onDelete(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingLg,
            vertical: AppDimensions.spacingMd,
          ),
          child: Row(
            children: [
              Icon(icon, size: 24, color: color),
              const SizedBox(width: AppDimensions.spacingLg),
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.right,
                  style: _labelTextStyle.copyWith(color: color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

SnackBar _successSnackBar(String message) {
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: AppColors.primaryDark,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
    ),
    content: Row(
      children: [
        const Icon(Icons.check_circle_outline, color: Colors.white),
        const SizedBox(width: AppDimensions.spacingSm),
        Expanded(child: Text(message)),
      ],
    ),
  );
}