import 'dart:typed_data';

/// Holds the current user's profile data.
///
/// Fully backend-agnostic: the profile picture is kept in memory as raw image
/// bytes ([profileImageBytes]) which works identically on Web, Android and
/// iOS. No Firestore/Supabase imports and no [dart:io] types in this class.
class UserProfileModel {
  const UserProfileModel({
    required this.uid,
    required this.name,
    required this.phone,
    required this.email,
    this.profileImageBytes,
    this.isPhoneVerified = true,
    this.isEmailVerified = true,
  });

  final String uid;
  final String name;
  final String phone;
  final String email;

  /// In-memory image bytes of the avatar photo — never a path/URL.
  final Uint8List? profileImageBytes;

  final bool isPhoneVerified;
  final bool isEmailVerified;

  UserProfileModel copyWith({
    String? name,
    String? phone,
    String? email,
    Uint8List? profileImageBytes,
    bool? isPhoneVerified,
    bool? isEmailVerified,
  }) {
    return UserProfileModel(
      uid: uid,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      profileImageBytes: profileImageBytes ?? this.profileImageBytes,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }
}