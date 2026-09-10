import 'dart:typed_data';

class UserProfileModel {
  const UserProfileModel({
    required this.uid,
    required this.name,
    required this.phone,
    required this.email,
    this.profileImageUrl,
    this.profileImageBytes,
    this.isPhoneVerified = true,
    this.isEmailVerified = true,
  });

  final String uid;
  final String name;
  final String phone;
  final String email;
  final String? profileImageUrl;
  final Uint8List? profileImageBytes;
  final bool isPhoneVerified;
  final bool isEmailVerified;

  static const Object _unset = Object();

  UserProfileModel copyWith({
    String? name,
    String? phone,
    String? email,
    String? profileImageUrl,
    Object? profileImageBytes = _unset,
    bool? isPhoneVerified,
    bool? isEmailVerified,
  }) {
    return UserProfileModel(
      uid: uid,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      profileImageBytes: identical(profileImageBytes, _unset)
          ? this.profileImageBytes
          : profileImageBytes as Uint8List?,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }
}
