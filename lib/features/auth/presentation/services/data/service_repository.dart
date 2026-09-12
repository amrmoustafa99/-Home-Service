import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/service_model.dart';

class ServiceRepository {
  final FirebaseFirestore firestore;

  ServiceRepository({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<ServiceModel>> getServicesByCategory(
    String categoryId,
  ) async {
    final snapshot = await firestore
        .collection('services')
        .where('categoryId', isEqualTo: categoryId)
        .get();

    return snapshot.docs.map((doc) {
      return ServiceModel.fromFirestore(
        doc.id,
        doc.data(),
      );
    }).toList();
  }
}