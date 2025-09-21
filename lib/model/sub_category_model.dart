class SubCategoryModel {
  final String subCategoryName;

  SubCategoryModel({required this.subCategoryName});

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(subCategoryName: json['subCategoryName']);
  }
}
