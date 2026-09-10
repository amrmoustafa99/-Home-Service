import 'package:equatable/equatable.dart';

import '../../data/models/user_profile_model.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => const [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded(this.profile);

  final UserProfileModel profile;

  @override
  List<Object?> get props => [profile];
}

class ProfileUpdating extends ProfileState {
  const ProfileUpdating(this.profile);

  final UserProfileModel profile;

  @override
  List<Object?> get props => [profile];
}

class ProfileError extends ProfileState {
  const ProfileError({required this.message, required this.previousProfile});

  final String message;
  final UserProfileModel previousProfile;

  @override
  List<Object?> get props => [message, previousProfile];
}
