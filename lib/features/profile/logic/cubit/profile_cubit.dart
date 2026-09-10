import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/profile_field.dart';
import '../../data/models/profile_messages.dart';
import '../../data/models/user_profile_model.dart';
import '../../data/repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required ProfileRepository repository,
    String? Function()? currentUidProvider,
  })  : _repository = repository,
        _currentUid = currentUidProvider ??
            (() => FirebaseAuth.instance.currentUser?.uid),
        super(const ProfileInitial());

  final ProfileRepository _repository;
  final String? Function() _currentUid;

  UserProfileModel _profile = const UserProfileModel(
    uid: '',
    name: '',
    phone: '',
    email: '',
  );

  UserProfileModel get currentProfile => _profile;

  Future<void> loadProfile() async {
    final uid = _currentUid();
    if (uid == null) {
      debugPrint('ProfileCubit.loadProfile: no authenticated user.');
      emit(ProfileError(
        message: ProfileMessages.noAuthenticatedUser,
        previousProfile: _profile,
      ));
      return;
    }
    try {
      final data = await _repository.fetchProfileData(uid);
      if (data == null) {
        debugPrint(
          'ProfileCubit.loadProfile: no document found for uid $uid.',
        );
        emit(ProfileError(
          message: ProfileMessages.profileNotFound,
          previousProfile: _profile,
        ));
        return;
      }
      _profile = UserProfileModel(
        uid: uid,
        name: _stringFrom(data, ProfileField.name),
        phone: _stringFrom(data, ProfileField.phone),
        email: _stringFrom(data, ProfileField.email),
        profileImageUrl: _imageUrlFrom(data),
      );
      emit(ProfileLoaded(_profile));
    } catch (e) {
      debugPrint('ProfileCubit.loadProfile: $e');
      emit(ProfileError(
        message: ProfileMessages.loadFailed,
        previousProfile: _profile,
      ));
    }
  }

  Future<void> updateProfileData({
    required String name,
    required String phone,
    required String email,
    Uint8List? profileImageBytes,
  }) async {
    final uid = _currentUid();
    if (uid == null) {
      debugPrint('ProfileCubit.updateProfileData: no authenticated user.');
      emit(ProfileError(
        message: ProfileMessages.noAuthenticatedUser,
        previousProfile: _profile,
      ));
      return;
    }
    emit(ProfileUpdating(_profile));
    try {
      String? profileImageUrl = _profile.profileImageUrl;
      if (profileImageBytes != null) {
        profileImageUrl = await _repository.uploadProfilePhoto(
          uid: uid,
          bytes: profileImageBytes,
        );
      }
      await _repository.updateProfileData(
        uid: uid,
        name: name,
        phone: phone,
        email: email,
      );
      imageCache.clear();
      imageCache.clearLiveImages();
      _profile = _profile.copyWith(
        name: name,
        phone: phone,
        email: email,
        profileImageUrl: profileImageUrl,
        profileImageBytes: null,
      );
      emit(ProfileLoaded(_profile));
    } catch (e) {
      debugPrint('ProfileCubit.updateProfileData: $e');
      emit(ProfileError(
        message: ProfileMessages.saveFailed,
        previousProfile: _profile,
      ));
    }
  }

  void pickLocalPhoto(Uint8List bytes) {
    if (bytes.isEmpty || identical(bytes, _profile.profileImageBytes)) {
      return;
    }
    _profile = _profile.copyWith(profileImageBytes: bytes);
    emit(ProfileLoaded(_profile));
  }

  static String? _imageUrlFrom(Map<String, dynamic> data) {
    final url = data[ProfileField.profileImage] as String?;
    if (url == null || url.isEmpty) return null;
    return url;
  }

  static String _stringFrom(Map<String, dynamic> data, String field) =>
      data[field]?.toString() ?? '';
}
