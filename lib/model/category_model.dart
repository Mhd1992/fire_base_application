class CategoryModel {
  final String categoryId;
  final String categoryName;
  final String? userId;

  CategoryModel({
    required this.categoryId,
    required this.categoryName,
    required this.userId,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json, String id) {
    return CategoryModel(
      categoryId: id,
      categoryName: json['categoryName'],
      userId: json['userId'] ?? 'no_data',
    );
  }
}
