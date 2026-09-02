import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/user_profile_model.dart';
import 'profile_state.dart';

/// Manages the profile feature state entirely in memory.
///
/// There is NO backend in this session: the cubit is seeded with a hardcoded
/// dummy [UserProfileModel] and "saves" are simulated with a short delay.
/// The profile picture is stored as in-memory [Uint8List] bytes (web-safe).
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileInitial()) {
    _profile = const UserProfileModel(
      uid: 'dummy-user',
      name: 'محمد حسني',
      phone: '+20112838457',
      email: 'muhammad34@gmail.com',
      isPhoneVerified: true,
      isEmailVerified: true,
    );
    emit(ProfileLoaded(_profile));
  }

  /// Source of truth for the latest known profile, mirrored into the emitted
  /// states so the UI always has access to it.
  UserProfileModel _profile = const UserProfileModel(
    uid: '',
    name: '',
    phone: '',
    email: '',
  );

  /// The latest known profile, regardless of the current state variant.
  UserProfileModel get currentProfile => _profile;

  /// "Saves" the edited fields into the in-memory profile.
  ///
  /// Emits [ProfileUpdating] first (so the UI can show progress while keeping
  /// existing data visible), then [ProfileLoaded] with the updated data after
  /// a simulated network delay. Nothing is persisted.
  Future<void> updateProfileData({
    required String name,
    required String phone,
    required String email,
  }) async {
    emit(ProfileUpdating(_profile));
    await Future.delayed(const Duration(milliseconds: 800));
    _profile = _profile.copyWith(name: name, phone: phone, email: email);
    emit(ProfileLoaded(_profile));
  }

  /// Updates the local profile picture immediately (no delay, fully local).
  void pickLocalPhoto(Uint8List bytes) {
    _profile = _profile.copyWith(profileImageBytes: bytes);
    emit(ProfileLoaded(_profile));
  }

  /// Debug-only helper that emits a [ProfileError] for visual testing.
  ///
  /// This exists solely to exercise the error UI; it is NEVER called by field
  /// validation, which is handled exclusively by inline form validators.
  void simulateError() {
    emit(
      ProfileError(
        message: 'تعذر حفظ البيانات، يُرجى المحاولة مرة أخرى.',
        previousProfile: _profile,
      ),
    );
  }
}