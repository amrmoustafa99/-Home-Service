import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../data/models/user_profile_model.dart';
import '../../logic/cubit/profile_cubit.dart';
import '../../logic/cubit/profile_state.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/verified_badge.dart';

/// Read-only view of the current user's profile.
///
/// NOTE: the project does not configure a global RTL locale yet, so this
/// screen wraps itself in [Directionality.wrap] with [TextDirection.rtl].
/// Once the app sets Up `Locale('ar')` globally, this local wrapper should be
/// removed.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'الملف الشخصي',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: AppDimensions.spacingLg),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.profileEdit);
                },
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.primaryContainer,
                  foregroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingMd,
                    vertical: AppDimensions.spacingSm,
                  ),
                  minimumSize: const Size(0, 40),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit_outlined, size: 18),
                    SizedBox(width: AppDimensions.spacingXs),
                    Text(
                      'تعديل',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              final UserProfileModel? profile = switch (state) {
                ProfileLoaded(:final profile) => profile,
                ProfileUpdating(:final profile) => profile,
                ProfileError(:final previousProfile) => previousProfile,
                ProfileInitial() => null,
              };
              if (profile == null) {
                return const SizedBox.shrink();
              }
              return _ProfileContent(profile: profile);
            },
          ),
        ),
      ),
    );
  }
}

/// Scrollable body of the read-only profile screen.
class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.profile});

  final UserProfileModel profile;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spacingXl),
      child: Column(
        children: [
          const SizedBox(height: AppDimensions.spacingSm),
          ProfileAvatar(
            imageBytes: profile.profileImageBytes,
            size: AppDimensions.avatarSizeLg,
          ),
          const SizedBox(height: AppDimensions.spacing2xl),
          Text(
            profile.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXl),
          _ProfileInfoTile(
            label: 'الإسم بالكامل',
            value: profile.name,
          ),
          const SizedBox(height: AppDimensions.spacingXl),
          _ProfileInfoTile(
            label: 'رقم الهاتف',
            value: profile.phone,
            badge: profile.isPhoneVerified
                ? const VerifiedBadge(text: 'رقم الهاتف موثق')
                : null,
          ),
          const SizedBox(height: AppDimensions.spacingXl),
          _ProfileInfoTile(
            label: 'البريد الإلكتروني',
            value: profile.email,
            badge: profile.isEmailVerified
                ? const VerifiedBadge(text: 'البريد الإلكتروني موثق')
                : null,
          ),
        ],
      ),
    );
  }
}

/// A single read-only label/value card with an optional verified badge below
/// the value (mirroring the verified rows' placement on the edit screen).
class _ProfileInfoTile extends StatelessWidget {
  const _ProfileInfoTile({
    required this.label,
    required this.value,
    this.badge,
  });

  final String label;
  final String value;
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingLg,
        vertical: AppDimensions.spacingLg,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXs),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (badge != null)
            Padding(
              padding: const EdgeInsets.only(top: AppDimensions.spacingXs),
              child: badge,
            ),
        ],
      ),
    );
  }
}