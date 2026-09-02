import 'package:equatable/equatable.dart';

import '../../data/models/user_profile_model.dart';

/// Base state for the profile feature.
///
/// A sealed class so the UI can pattern-match exhaustively on the current
/// [ProfileState] variant.
sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => const [];
}

/// The feature has just started and holds no profile yet.
class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

/// The profile is loaded and fully editable/viewable.
class ProfileLoaded extends ProfileState {
  const ProfileLoaded(this.profile);

  /// The current user profile (in-memory only, no persistence).
  final UserProfileModel profile;

  @override
  List<Object?> get props => [profile];
}

/// A save is in progress; keeps the current [profile] so the UI can continue
/// displaying existing data while the (simulated) save runs.
class ProfileUpdating extends ProfileState {
  const ProfileUpdating(this.profile);

  final UserProfileModel profile;

  @override
  List<Object?> get props => [profile];
}

/// A general save failure, unrelated to field validation.
///
/// Keeps [previousProfile] so the UI can recover gracefully without losing
/// the data the user already entered.
class ProfileError extends ProfileState {
  const ProfileError({required this.message, required this.previousProfile});

  /// User-facing error message.
  final String message;

  /// The profile as it was before the failed save.
  final UserProfileModel previousProfile;

  @override
  List<Object?> get props => [message, previousProfile];
}