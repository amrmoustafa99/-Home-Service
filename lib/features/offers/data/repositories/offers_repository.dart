import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/offer_model.dart';
import '../models/offers_copy.dart';

class OffersFetchException implements Exception {
  final String message;
  OffersFetchException(this.message);

  @override
  String toString() => message;
}

abstract class OffersRepository {
  Future<List<Offer>> getOffers();
}

class FirebaseOffersRepository implements OffersRepository {
  final FirebaseFirestore _firestore;

  FirebaseOffersRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<Offer>> getOffers() async {
    try {
      final snapshot = await _firestore
          .collection('offers')
          .orderBy('expiryDate', descending: false)
          .get();

      return snapshot.docs
          .map((doc) => Offer.fromJson(doc.data(), doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw OffersFetchException(e.message ?? OffersCopy.defaultError);
    } catch (_) {
      throw OffersFetchException(OffersCopy.defaultError);
    }
  }
}
