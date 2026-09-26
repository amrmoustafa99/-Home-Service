import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../data/models/addresses_copy.dart';
import '../../logic/cubit/address_cubit.dart';
import '../screens/add_address_screen.dart';

class AddressesLoading extends StatelessWidget {
  const AddressesLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.figmaDarkGreen),
    );
  }
}

class EmptyAddressesView extends StatelessWidget {
  const EmptyAddressesView({super.key});

  static const double _illustrationWidth = 155;
  static const double _illustrationHeight = 190;
  static const double _imageToHeadingGap = 36;

  static const TextStyle _headingTextStyle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: -0.44,
  );

  static const TextStyle _subtextTextStyle = TextStyle(
    color: AppColors.textfromfield,
    fontSize: 16,
    fontFamily: 'IBMPlexSansArabic',
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: -0.32,
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(AppDimensions.spacingXl),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppDimensions.maxContentWidth,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                AppAssets.emptyAddressesIllustration,
                width: _illustrationWidth,
                height: _illustrationHeight,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: _imageToHeadingGap),
              const Text(
                AddressesCopy.listEmptyTitle,
                textAlign: TextAlign.center,
                style: _headingTextStyle,
              ),
              const SizedBox(height: AppDimensions.spacingMd),
              const Text(
                AddressesCopy.listEmptySubtext,
                textAlign: TextAlign.center,
                style: _subtextTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddressesErrorView extends StatelessWidget {
  const AddressesErrorView({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.error,
              size: 48,
            ),
            const SizedBox(height: AppDimensions.spacingLg),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontFamily: 'IBMPlexSansArabic',
                fontWeight: FontWeight.w500,
                height: 1.5,
                letterSpacing: -0.32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddAddressButton extends StatelessWidget {
  const AddAddressButton({super.key, required this.label});

  final String label;

  static const double _buttonHeight = 60;

  static const TextStyle _labelTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontFamily: 'IBMPlexSansArabic',
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: -0.28,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: _buttonHeight,
      child: Material(
        color: AppColors.primary,
        borderRadius: BorderRadius.all(
          Radius.circular(AppDimensions.radiusSm),
        ),
        child: InkWell(
          onTap: () {
            final cubit = context.read<AddressCubit>();
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => BlocProvider.value(
                  value: cubit,
                  child: const AddAddressScreen(),
                ),
              ),
            );
          },
          borderRadius: BorderRadius.all(
            Radius.circular(AppDimensions.radiusSm),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, color: Colors.white, size: 24),
              const SizedBox(width: AppDimensions.spacingSm),
              Text(
                label,
                textAlign: TextAlign.center,
                style: _labelTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}