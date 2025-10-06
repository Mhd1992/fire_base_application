import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_application/model/sub_category_model.dart';
import 'package:flutter_riverpod/legacy.dart';

// Display type enum
enum DisplayType { list, grid }

// Display type provider
final displayTypeProvider = StateNotifierProvider<DisplayTypeNotifier, DisplayType>(
  (ref) => DisplayTypeNotifier(),
);

class DisplayTypeNotifier extends StateNotifier<DisplayType> {
  DisplayTypeNotifier() : super(DisplayType.list);

  void toggle() {
    state = state == DisplayType.list ? DisplayType.grid : DisplayType.list;
  }
}

// Subcategories provider
final subCategoriesProvider = StateNotifierProvider.autoDispose<SubCategoriesNotifier, AsyncValue<List<SubCategoryModel>>>(
  
  (ref) => SubCategoriesNotifier(),
);

class SubCategoriesNotifier extends StateNotifier<AsyncValue<List<SubCategoryModel>>> {
  SubCategoriesNotifier() : super(const AsyncValue.loading());

  Future<void> fetch(String? categoryId) async {
    if (categoryId == null) {
      state = const AsyncValue.data([]);
      return;
    }
    state = const AsyncValue.loading();
    try {
      final data = await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryId)
          .collection('notes')
          .get();
      final subCategories = data.docs
          .map((doc) => SubCategoryModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      state = AsyncValue.data(subCategories);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> delete(String? categoryId, String noteId) async {
    if (categoryId == null) return;
    try {
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryId)
          .collection('notes')
          .doc(noteId)
          .delete();
      // Refresh after delete
      await fetch(categoryId);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}