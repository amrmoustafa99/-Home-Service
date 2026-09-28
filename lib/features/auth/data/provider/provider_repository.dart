import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'join_data.dart';

class ProviderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> submitProvider(JoinData data) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('يجب تسجيل الدخول أولاً');
    }

    final uid = user.uid;

    await _firestore.collection('providers').doc(uid).set({
      'uid': uid,

      // Personal data
      'name': data.name,
      'phone': data.phone,
      'email': data.email,

      // Profile image
      // مؤقتًا بنحفظ اسم الملف فقط لأن Firebase Storage غير متاح حاليًا
      'avatarFileName': data.avatar?.name,

      // Services
      'categories': data.categories.toList(),
      'subServices': data.subServices.toList(),
      'experience': data.experience,
      'notes': data.notes,

      // Work images
      // مؤقتًا بنحفظ أسماء الصور فقط
      'workFileNames': data.works.map((image) => image.name).toList(),

      // Work scope
      'city': data.city,
      'days': data.days.toList(),

      // Available time
      'from': '${data.from.hour.toString().padLeft(2, '0')}:'
          '${data.from.minute.toString().padLeft(2, '0')}',

      'to': '${data.to.hour.toString().padLeft(2, '0')}:'
          '${data.to.minute.toString().padLeft(2, '2')}',

      // Provider status
      'status': 'pending',

      // Timestamp
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
