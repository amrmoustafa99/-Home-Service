class CityModel {
  const CityModel({
    required this.id,
    required this.governorateId,
    required this.nameAr,
    required this.nameEn,
  });

  static const String _idKey = 'id';
  static const String _governorateIdKey = 'governorate_id';
  static const String _nameArKey = 'city_name_ar';
  static const String _nameEnKey = 'city_name_en';

  final String id;
  final String governorateId;
  final String nameAr;
  final String nameEn;

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json[_idKey] as String? ?? '',
      governorateId: json[_governorateIdKey]?.toString() ?? '',
      nameAr: json[_nameArKey] as String? ?? '',
      nameEn: json[_nameEnKey] as String? ?? '',
    );
  }
}