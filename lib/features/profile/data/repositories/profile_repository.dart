import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../../../core/constants/supabase_constants.dart';
import '../models/profile_field.dart';

class ProfileRepository {
  ProfileRepository({FirebaseFirestore? firestore})
      : _firestoreOverride = firestore;

  final FirebaseFirestore? _firestoreOverride;

  FirebaseFirestore get _firestore =>
      _firestoreOverride ?? FirebaseFirestore.instance;

  supabase.SupabaseClient get _supabaseClient =>
      supabase.Supabase.instance.client;

  static const Map<String, dynamic> _emptyProfile = {
    ProfileField.name: '',
    ProfileField.phone: '',
    ProfileField.email: '',
    ProfileField.profileImage: '',
  };

  Future<Map<String, dynamic>?> fetchProfileData(String uid) async {
    try {
      final doc = await _firestore
          .collection(ProfileField.collection)
          .doc(uid)
          .get();
      if (!doc.exists || doc.data() == null) {
        return _emptyProfile;
      }
      return doc.data();
    } catch (e) {
      debugPrint('ProfileRepository.fetchProfileData: $e');
      rethrow;
    }
  }

  Future<void> updateProfileData({
    required String uid,
    required String name,
    required String phone,
    required String email,
  }) async {
    try {
      await _firestore.collection(ProfileField.collection).doc(uid).set(
        {ProfileField.name: name, ProfileField.phone: phone, ProfileField.email: email},
        SetOptions(merge: true),
      );
    } catch (e) {
      debugPrint('ProfileRepository.updateProfileData: $e');
      rethrow;
    }
  }

  Future<String> uploadProfilePhoto({
    required String uid,
    required Uint8List bytes,
  }) async {
    final storagePath = '$uid/profile.jpg';
    try {
      await _supabaseClient.storage
          .from(SupabaseConstants.profileImagesBucket)
          .uploadBinary(
            storagePath,
            bytes,
            fileOptions: const supabase.FileOptions(
              upsert: true,
              contentType: 'image/jpeg',
            ),
          );

      final rawPublicUrl = _supabaseClient.storage
          .from(SupabaseConstants.profileImagesBucket)
          .getPublicUrl(storagePath);

      // Enforce cache-busting at the persistence layer
      final publicUrl = '$rawPublicUrl?t=${DateTime.now().millisecondsSinceEpoch}';

      await _firestore.collection(ProfileField.collection).doc(uid).set(
        {ProfileField.profileImage: publicUrl},
        SetOptions(merge: true),
      );
      return publicUrl;
    } catch (e) {
      debugPrint('ProfileRepository.uploadProfilePhoto: $e');
      rethrow;
    }
  }
}
