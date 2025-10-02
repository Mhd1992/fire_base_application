class SubCategoryModel {
  final String subCategoryName;
  final String noteId;

  SubCategoryModel({required this.noteId, required this.subCategoryName});

  factory SubCategoryModel.fromJson(Map<String, dynamic> json, String id) {
    return SubCategoryModel(
      noteId: id,
      subCategoryName: json['subCategoryName'],
    );
  }
}
