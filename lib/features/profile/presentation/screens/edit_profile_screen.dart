import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../data/models/profile_edit_copy.dart';
import '../../logic/cubit/profile_cubit.dart';
import '../../logic/cubit/profile_state.dart';
import '../widgets/primary_action_bar.dart';
import '../widgets/profile_app_bar.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/profile_field_style.dart';
import '../widgets/profile_text_field.dart';
import '../widgets/verified_badge.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  bool _pendingSave = false;

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileCubit>().currentProfile;
    _nameController = TextEditingController(text: profile.name);
    _phoneController = TextEditingController(text: profile.phone);
    _emailController = TextEditingController(text: profile.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _save() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _pendingSave = true;
    final cubit = context.read<ProfileCubit>();
    cubit.updateProfileData(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      profileImageBytes: cubit.currentProfile.profileImageBytes,
    );
  }

  Future<void> _pickPhoto() async {
    final XFile? picked =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    final Uint8List bytes = await picked.readAsBytes();
    if (!mounted) return;
    context.read<ProfileCubit>().pickLocalPhoto(bytes);
  }

  void _showSnackBar(String message, {required bool isError}) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? AppColors.error : AppColors.primaryDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: AppDimensions.spacingSm),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocListener<ProfileCubit, ProfileState>(
        listenWhen: (previous, current) =>
            current is ProfileLoaded || current is ProfileError,
        listener: (context, state) {
          if (state is ProfileLoaded && _pendingSave) {
            _pendingSave = false;
            _showSnackBar(ProfileEditCopy.savedSuccessfully, isError: false);
            Navigator.of(context).pop();
          } else if (state is ProfileError) {
            _pendingSave = false;
            _showSnackBar(state.message, isError: true);
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: ProfileFieldStyle.background,
          body: SafeArea(
            child: Column(
              children: [
                const ProfileHeader(title: ProfileEditCopy.screenTitle),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: AppDimensions.maxContentWidth,
                      ),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacingXl,
                          vertical: AppDimensions.spacingLg,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _AvatarSection(onCameraTap: _pickPhoto),
                              const SizedBox(height: 16),
                              ProfileTextField(
                                label: ProfileEditCopy.fullNameLabel,
                                controller: _nameController,
                                validator: _Validators.name,
                                textInputAction: TextInputAction.next,
                                prefixIcon: const Icon(
                                  Icons.person_outline,
                                  color: ProfileFieldStyle.iconColor,
                                  size: ProfileFieldStyle.iconSize,
                                ),
                              ),
                              const SizedBox(height: 12),
                              // In RTL, prefixIcon sits right (start), suffixIcon left (end).
                              ProfileTextField(
                                label: ProfileEditCopy.phoneLabel,
                                controller: _phoneController,
                                validator: _Validators.phone,
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.next,
                                prefixIcon: const Icon(
                                  Icons.phone_outlined,
                                  color: ProfileFieldStyle.iconColor,
                                  size: ProfileFieldStyle.iconSize,
                                ),
                                suffixIcon: const Padding(
                                  padding: EdgeInsets.all(6),
                                  child: SolidCheckCircle(),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                  top: AppDimensions.verifiedGap,
                                  right: AppDimensions.spacingXs,
                                ),
                                child:
                                    VerifiedBadge(text: ProfileEditCopy.phoneVerified),
                              ),
                              const SizedBox(height: 12),
                              ProfileTextField(
                                label: ProfileEditCopy.emailLabel,
                                controller: _emailController,
                                validator: _Validators.email,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.done,
                                prefixIcon: const Icon(
                                  Icons.mail_outline,
                                  color: ProfileFieldStyle.iconColor,
                                  size: ProfileFieldStyle.iconSize,
                                ),
                                suffixIcon: const Padding(
                                  padding: EdgeInsets.all(6),
                                  child: SolidCheckCircle(),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                  top: AppDimensions.verifiedGap,
                                  right: AppDimensions.spacingXs,
                                ),
                                child:
                                    VerifiedBadge(text: ProfileEditCopy.emailVerified),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BlocBuilder<ProfileCubit, ProfileState>(
            buildWhen: (previous, current) =>
                previous is! ProfileUpdating || current is! ProfileUpdating,
            builder: (context, state) {
              return PrimaryActionBar(
                label: ProfileEditCopy.save,
                icon: Icons.save_rounded,
                onPressed: _save,
                isBusy: state is ProfileUpdating,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AvatarSection extends StatelessWidget {
  const _AvatarSection({required this.onCameraTap});

  final VoidCallback onCameraTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          BlocBuilder<ProfileCubit, ProfileState>(
            buildWhen: (previous, current) =>
                current is ProfileLoaded ||
                current is ProfileUpdating ||
                current is ProfileError,
            builder: (context, state) {
              final profile = switch (state) {
                ProfileLoaded(:final profile) => profile,
                ProfileUpdating(:final profile) => profile,
                ProfileError(:final previousProfile) => previousProfile,
                ProfileInitial() => null,
              };
              return ProfileAvatar(
                imageUrl: profile?.profileImageUrl,
                imageBytes: profile?.profileImageBytes,
                size: AppDimensions.avatarSize,
                onCameraTap: onCameraTap,
              );
            },
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          TextButton(
            onPressed: onCameraTap,
            child: const Text(
              ProfileEditCopy.changePhoto,
              style: TextStyle(
                color: AppColors.figmaDarkGreen,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

abstract final class _Validators {
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ProfileEditCopy.fullNameMissing;
    }
    return null;
  }

  static String? email(String? value) {
    final emailPattern = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
    if (value == null || value.trim().isEmpty) {
      return ProfileEditCopy.emailMissing;
    }
    if (!emailPattern.hasMatch(value.trim())) {
      return ProfileEditCopy.emailInvalid;
    }
    return null;
  }

  static String? phone(String? value) {
    final phonePattern = RegExp(r'^\+?\d{7,15}$');
    if (value == null || value.trim().isEmpty) {
      return ProfileEditCopy.phoneMissing;
    }
    if (!phonePattern.hasMatch(value.trim())) {
      return ProfileEditCopy.phoneInvalid;
    }
    return null;
  }
}
