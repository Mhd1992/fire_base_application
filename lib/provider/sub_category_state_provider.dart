import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_application/model/sub_category_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// Display type enum
enum DisplayType { list, grid }

// Display type provider
final displayTypeStateProvider = StateProvider.autoDispose<DisplayType>(
  (ref) => DisplayType.list,
);

// Subcategories provider
final subCategoriesStateProvider =
    StateProvider.autoDispose<AsyncValue<List<SubCategoryModel>>>(
      (ref) => const AsyncValue.loading(),
    );

// Fetch subcategories function
Future<void> stateProviderFetchSubCategories(
  WidgetRef ref,
  String? categoryId,
) async {
  if (categoryId == null) {
    ref.read(subCategoriesStateProvider.notifier).state = const AsyncValue.data(
      [],
    );
    return;
  }
  ref.read(subCategoriesStateProvider.notifier).state =
      const AsyncValue.loading();
  try {
    final data = await FirebaseFirestore.instance
        .collection('categories')
        .doc(categoryId)
        .collection('notes')
        .get();
    final subCategories = data.docs
        .map((doc) => SubCategoryModel.fromJson(doc.data(), doc.id))
        .toList();
    ref.read(subCategoriesStateProvider.notifier).state = AsyncValue.data(
      subCategories,
    );
  } catch (e, st) {
    ref.read(subCategoriesStateProvider.notifier).state = AsyncValue.error(
      e,
      st,
    );
  }
}

Future<void> stateProviderDeleteSubCategory(
  WidgetRef ref,
  String? categoryId,
  String noteId,
) async {
  if (categoryId == null) return;
  try {
    await FirebaseFirestore.instance
        .collection('categories')
        .doc(categoryId)
        .collection('notes')
        .doc(noteId)
        .delete();
    // Refresh after delete
    await stateProviderFetchSubCategories(ref, categoryId);
  } catch (e, st) {
    ref.read(subCategoriesStateProvider.notifier).state = AsyncValue.error(
      e,
      st,
    );
  }
}
