import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../data/models/profile_copy.dart';
import '../../data/models/user_profile_model.dart';
import '../../logic/cubit/profile_cubit.dart';
import '../../logic/cubit/profile_state.dart';
import '../widgets/info_card_tile.dart';
import '../widgets/primary_action_bar.dart';
import '../widgets/profile_app_bar.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/profile_field_style.dart';
import '../widgets/verified_badge.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: ProfileFieldStyle.background,
        body: SafeArea(
          child: Column(
            children: [
              const ProfileHeader(title: ProfileCopy.screenTitle),
              Expanded(
                child: BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    return switch (state) {
                      ProfileInitial() => const _ProfileLoading(),
                      ProfileLoaded(:final profile) =>
                        _ProfileContent(profile: profile),
                      ProfileUpdating(:final profile) =>
                        _ProfileContent(profile: profile),
                      ProfileError(:final message) => _ProfileErrorView(
                          message: message,
                          onRetry: () =>
                              context.read<ProfileCubit>().loadProfile(),
                        ),
                    };
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: PrimaryActionBar(
          label: ProfileCopy.editData,
          icon: Icons.edit_rounded,
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.profileEdit);
          },
        ),
      ),
    );
  }
}

class _ProfileLoading extends StatelessWidget {
  const _ProfileLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.figmaDarkGreen),
    );
  }
}

class _ProfileErrorView extends StatelessWidget {
  const _ProfileErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

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
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXl),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
              ),
              child: const Text(ProfileCopy.retry),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileContent extends StatefulWidget {
  const _ProfileContent({required this.profile});

  final UserProfileModel profile;

  @override
  State<_ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<_ProfileContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppDimensions.maxContentWidth,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.spacingXl,
            AppDimensions.spacingLg,
            AppDimensions.spacingXl,
            AppDimensions.spacingLg,
          ),
          child: FadeTransition(
            opacity: _fadeIn,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    ProfileAvatar(
                      imageUrl: widget.profile.profileImageUrl,
                      imageBytes: widget.profile.profileImageBytes,
                      size: AppDimensions.avatarSize,
                    ),
                    const SizedBox(height: AppDimensions.spacingMd),
                    Text(
                      widget.profile.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacing2xl),
                Column(
                  children: [
                    InfoCardTile(
                      label: ProfileCopy.fullNameLabel,
                      value: widget.profile.name,
                      mainIcon: Icons.person_outline,
                    ),
                    const SizedBox(height: AppDimensions.spacingXl),
                    InfoCardTile(
                      label: ProfileCopy.phoneLabel,
                      value: widget.profile.phone,
                      mainIcon: Icons.phone_outlined,
                      showCheck: true,
                      badge: widget.profile.isPhoneVerified
                          ? const VerifiedBadge(text: ProfileCopy.phoneVerified)
                          : null,
                    ),
                    const SizedBox(height: AppDimensions.spacingXl),
                    InfoCardTile(
                      label: ProfileCopy.emailLabel,
                      value: widget.profile.email,
                      mainIcon: Icons.mail_outline,
                      showCheck: true,
                      badge: widget.profile.isEmailVerified
                          ? const VerifiedBadge(text: ProfileCopy.emailVerified)
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
