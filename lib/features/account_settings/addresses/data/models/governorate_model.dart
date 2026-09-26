class GovernorateModel {
  const GovernorateModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });

  static const String _idKey = 'id';
  static const String _nameArKey = 'governorate_name_ar';
  static const String _nameEnKey = 'governorate_name_en';

  final String id;
  final String nameAr;
  final String nameEn;

  factory GovernorateModel.fromJson(Map<String, dynamic> json) {
    return GovernorateModel(
      id: json[_idKey] as String? ?? '',
      nameAr: json[_nameArKey] as String? ?? '',
      nameEn: json[_nameEnKey] as String? ?? '',
    );
  }
}