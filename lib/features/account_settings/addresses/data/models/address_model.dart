import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  const AddressModel({
    this.id,
    required this.title,
    required this.governorate,
    required this.city,
    required this.addressDetails,
    this.landmark,
    this.isDefault = false,
    required this.createdAt,
  });

  static const String idKey = 'id';
  static const String titleKey = 'title';
  static const String governorateKey = 'governorate';
  static const String cityKey = 'city';
  static const String addressDetailsKey = 'addressDetails';
  static const String landmarkKey = 'landmark';
  static const String isDefaultKey = 'isDefault';
  static const String createdAtKey = 'createdAt';

  final String? id;
  final String title;
  final String governorate;
  final String city;
  final String addressDetails;
  final String? landmark;
  final bool isDefault;
  final DateTime createdAt;

  static const Object _unset = Object();

  factory AddressModel.fromMap(Map<String, dynamic> map, String id) {
    final createdAtRaw = map[createdAtKey];
    final DateTime createdAt;
    if (createdAtRaw is Timestamp) {
      createdAt = createdAtRaw.toDate();
    } else {
      createdAt = DateTime.tryParse(createdAtRaw as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0);
    }

    return AddressModel(
      id: id,
      title: map[titleKey] as String? ?? '',
      governorate: map[governorateKey] as String? ?? '',
      city: map[cityKey] as String? ?? '',
      addressDetails: map[addressDetailsKey] as String? ?? '',
      landmark: map[landmarkKey] as String?,
      isDefault: map[isDefaultKey] as bool? ?? false,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap({bool useServerTimestamp = false}) {
    return {
      titleKey: title,
      governorateKey: governorate,
      cityKey: city,
      addressDetailsKey: addressDetails,
      landmarkKey: landmark,
      isDefaultKey: isDefault,
      createdAtKey: useServerTimestamp
          ? FieldValue.serverTimestamp()
          : Timestamp.fromDate(createdAt),
    };
  }

  AddressModel copyWith({
    String? id,
    String? title,
    String? governorate,
    String? city,
    String? addressDetails,
    Object? landmark = _unset,
    bool? isDefault,
    DateTime? createdAt,
  }) {
    return AddressModel(
      id: id ?? this.id,
      title: title ?? this.title,
      governorate: governorate ?? this.governorate,
      city: city ?? this.city,
      addressDetails: addressDetails ?? this.addressDetails,
      landmark: identical(landmark, _unset)
          ? this.landmark
          : landmark as String?,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}