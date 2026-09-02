import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../logic/cubit/profile_cubit.dart';
import '../../logic/cubit/profile_state.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/profile_text_field.dart';
import '../widgets/verified_badge.dart';

/// Edit screen for the user's profile.
///
/// Form + client-side validation + in-memory save flow only: no backend runs
/// in this session. Photo picking goes through image_picker's [XFile] /
/// `readAsBytes()` and the bytes are stored in the Cubit state, which works
/// identically on Web, Android and iOS.
///
/// NOTE: the project does not configure a global RTL locale yet, so this
/// screen wraps itself in [Directionality.wrap] with [TextDirection.rtl].
/// Once the app sets Up `Locale('ar')` globally, this local wrapper should be
/// removed.
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

  /// Guards the success SnackBar/pop so it only reacts to a completed save,
  /// never to the [ProfileLoaded] re-emitted by a local photo pick.
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
    context.read<ProfileCubit>().updateProfileData(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
        );
  }

  /// Debug-only: triggers the global [ProfileError] state for visual testing.
  void _simulateError() {
    context.read<ProfileCubit>().simulateError();
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
            _showSnackBar('تم حفظ التغييرات بنجاح', isError: false);
            Navigator.of(context).pop();
          } else if (state is ProfileError) {
            _pendingSave = false;
            _showSnackBar(state.message, isError: true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.textPrimary,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'البيانات الشخصية',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            // TODO(team-b): replace with the real app logo asset when available.
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingLg,
                ),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusSm),
                  ),
                  child: const Icon(
                    Icons.home_work_outlined,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
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
                          const SizedBox(height: AppDimensions.spacing2xl),
                          ProfileTextField(
                            label: 'الإسم بالكامل',
                            controller: _nameController,
                            validator: _Validators.name,
                            textInputAction: TextInputAction.next,
                            suffixIcon: const Icon(
                              Icons.person_outline,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spacingXl),
                          ProfileTextField(
                            label: 'رقم الهاتف',
                            controller: _phoneController,
                            validator: _Validators.phone,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            prefixIcon: const Icon(
                              Icons.phone_outlined,
                              color: AppColors.textSecondary,
                            ),
                            suffixIcon: const _VerifiedCircleIcon(),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(
                              top: AppDimensions.spacingXs,
                              right: AppDimensions.spacingXs,
                            ),
                            child: VerifiedBadge(text: 'رقم الهاتف موثق'),
                          ),
                          const SizedBox(height: AppDimensions.spacingXl),
                          ProfileTextField(
                            label: 'البريد الإلكتروني',
                            controller: _emailController,
                            validator: _Validators.email,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            prefixIcon: const Icon(
                              Icons.mail_outline,
                              color: AppColors.textSecondary,
                            ),
                            suffixIcon: const _VerifiedCircleIcon(),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(
                              top: AppDimensions.spacingXs,
                              right: AppDimensions.spacingXs,
                            ),
                            child:
                                VerifiedBadge(text: 'البريد الإلكتروني موثق'),
                          ),
                          const SizedBox(height: AppDimensions.spacingXl),
                        ],
                      ),
                    ),
                  ),
                ),
                _BottomBar(
                  onSave: _save,
                  onSimulateError: _simulateError,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Centered avatar with an overlapping camera button and a "تغيير الصورة"
/// action below it.
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
            buildWhen: (previous, current) => current is ProfileLoaded,
            builder: (context, state) {
              final bytes = switch (state) {
                ProfileLoaded(:final profile) => profile.profileImageBytes,
                ProfileUpdating(:final profile) => profile.profileImageBytes,
                ProfileError(:final previousProfile) =>
                  previousProfile.profileImageBytes,
                ProfileInitial() => null,
              };
              return ProfileAvatar(
                imageBytes: bytes,
                size: AppDimensions.avatarSizeLg,
                onCameraTap: onCameraTap,
              );
            },
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          TextButton(
            onPressed: onCameraTap,
            child: const Text(
              'تغيير الصورة',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Green checkmark circle used as a field suffix (phone & email are verified).
class _VerifiedCircleIcon extends StatelessWidget {
  const _VerifiedCircleIcon();

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.check_circle, color: AppColors.primary);
  }
}

/// Pinned bottom bar with the full-width save button and the debug-only
/// "Simulate Error" trigger.
class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.onSave, required this.onSimulateError});

  final VoidCallback onSave;
  final VoidCallback onSimulateError;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.spacingXl,
        AppDimensions.spacingMd,
        AppDimensions.spacingXl,
        AppDimensions.spacingLg,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        buildWhen: (previous, current) =>
            previous is! ProfileUpdating || current is! ProfileUpdating,
        builder: (context, state) {
          final isUpdating = state is ProfileUpdating;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isUpdating ? null : onSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.primaryLight,
                    minimumSize: const Size(
                      double.infinity,
                      AppDimensions.fieldHeight,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusMd),
                    ),
                  ),
                  child: isUpdating
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'حفظ التغييرات',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
              // TODO(team-b): debug helper — remove before release.
              TextButton(
                onPressed: onSimulateError,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.error_outline,
                      size: 16,
                      color: AppColors.error,
                    ),
                    SizedBox(width: AppDimensions.spacingXs),
                    Text(
                      'Simulate Error',
                      style: TextStyle(
                        color: AppColors.error,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Client-side validators used by the edit form fields.
///
/// These are presentation-layer rules (inline field validation); a validation
/// failure must never reach the Cubit / [ProfileError]. Only the debug
/// `simulateError()` route produces that state.
abstract final class _Validators {
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال الإسم بالكامل';
    }
    return null;
  }

  static String? email(String? value) {
    final emailPattern = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال البريد الإلكتروني';
    }
    if (!emailPattern.hasMatch(value.trim())) {
      return 'يرجى إدخال بريد إلكتروني صحيح';
    }
    return null;
  }

  static String? phone(String? value) {
    // Digits only, optionally prefixed with '+', 7 to 15 digits total.
    final phonePattern = RegExp(r'^\+?\d{7,15}$');
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال رقم الهاتف';
    }
    if (!phonePattern.hasMatch(value.trim())) {
      return 'يرجى إدخال رقم هاتف صحيح';
    }
    return null;
  }
}