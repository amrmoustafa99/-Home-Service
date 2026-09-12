class ServiceModel {
  final String id;
  final String name;
  final String description;
  final String image;
  final String categoryId;
  final int price;

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.categoryId,
    required this.price,
  });

  factory ServiceModel.fromFirestore(
    String id,
    Map<String, dynamic> data,
  ) {
    return ServiceModel(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      image: data['image'] ?? '',
      categoryId: data['categoryId'] ?? '',
      price: (data['price'] ?? 0) as int,
    );
  }
}