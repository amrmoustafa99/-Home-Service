import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/address_model.dart';

class AddressRepository {
  AddressRepository({FirebaseFirestore? firestore})
      : _firestoreOverride = firestore;

  static const String _collection = 'users';
  static const String _subcollection = 'addresses';

  final FirebaseFirestore? _firestoreOverride;

  FirebaseFirestore get _firestore =>
      _firestoreOverride ?? FirebaseFirestore.instance;

  String get _currentUid => FirebaseAuth.instance.currentUser!.uid;

  CollectionReference<Map<String, dynamic>> _addressesCollection(String uid) =>
      _firestore.collection(_collection).doc(uid).collection(_subcollection);

  Stream<List<AddressModel>> watchAddresses() {
    final uid = _currentUid;
    return _addressesCollection(uid)
        .orderBy(AddressModel.isDefaultKey, descending: true)
        .orderBy(AddressModel.createdAtKey, descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AddressModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> addAddress(AddressModel address) async {
    final uid = _currentUid;
    final addressesRef = _addressesCollection(uid);

    final existing = await addressesRef.limit(1).get();
    final isFirstAddress = existing.docs.isEmpty;

    final effectiveAddress =
        address.copyWith(isDefault: address.isDefault || isFirstAddress);

    await addressesRef.doc().set(
          effectiveAddress.toMap(useServerTimestamp: true),
        );
  }

  Future<void> updateAddress(AddressModel address) async {
    final id = address.id;
    if (id == null) {
      throw ArgumentError('Cannot update an address without an id.');
    }

    final uid = _currentUid;
    final data = address.toMap()..remove(AddressModel.isDefaultKey);

    await _addressesCollection(uid).doc(id).update(data);
  }

  Future<void> deleteAddress(String addressId) async {
    final uid = _currentUid;
    final addressesRef = _addressesCollection(uid);

    final removedDoc = await addressesRef.doc(addressId).get();
    final wasDefault =
        (removedDoc.data()?[AddressModel.isDefaultKey] as bool?) ?? false;

    final batch = _firestore.batch();
    batch.delete(addressesRef.doc(addressId));

    if (wasDefault) {
      final candidates = await addressesRef
          .orderBy(AddressModel.createdAtKey, descending: true)
          .limit(2)
          .get();

      for (final doc in candidates.docs) {
        if (doc.id != addressId) {
          batch.update(doc.reference, {AddressModel.isDefaultKey: true});
          break;
        }
      }
    }

    await batch.commit();
  }

  Future<void> setDefaultAddress(String addressId) async {
    final uid = _currentUid;
    final addressesRef = _addressesCollection(uid);

    final currentDefaults = await addressesRef
        .where(AddressModel.isDefaultKey, isEqualTo: true)
        .limit(2)
        .get();

    final batch = _firestore.batch();
    for (final doc in currentDefaults.docs) {
      if (doc.id != addressId) {
        batch.update(doc.reference, {AddressModel.isDefaultKey: false});
      }
    }
    batch.update(addressesRef.doc(addressId), {
      AddressModel.isDefaultKey: true,
    });

    await batch.commit();
  }
}