import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_application/home_page/sub_category/sub_category_detail.dart';

import '../../provider/sub_category_state_provider.dart';
import '../category/add_category_page.dart';

class SubCategoryPage extends ConsumerStatefulWidget {
  const SubCategoryPage({super.key, this.categoryId});

  final String? categoryId;

  @override
  ConsumerState<SubCategoryPage> createState() => _SubCategoryPageState();
}

class _SubCategoryPageState extends ConsumerState<SubCategoryPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => stateProviderFetchSubCategories(ref, widget.categoryId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayType = ref.watch(displayTypeStateProvider);
    final subCategoriesAsync = ref.watch(subCategoriesStateProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) => SubCategoryDetail(
                    title: 'Add Subcategory',
                    catId: widget.categoryId,
                    type: ActionType.add,
                  ),
                ),
              )
              .then((_) {
                stateProviderFetchSubCategories(ref, widget.categoryId);
              });
        },
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add, color: Colors.white),
      ),

      appBar: AppBar(
        title: const Text('Subcategories'),
        actions: [
          IconButton(
            icon: Icon(
              displayType == DisplayType.list ? Icons.grid_view : Icons.list,
            ),
            onPressed: () {
              ref
                  .read(displayTypeStateProvider.notifier)
                  .state = displayType == DisplayType.list
                  ? DisplayType.grid
                  : DisplayType.list;
            },
          ),
        ],
      ),
      body: subCategoriesAsync.when(
        data: (subCategories) {
          return displayType == DisplayType.list
              ? _buildList(subCategories)
              : _buildGrid(subCategories);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildList(List subCategories) {
    return ListView.builder(
      itemCount: subCategories.length,
      itemBuilder: (context, index) {
        final subCategory = subCategories[index];
        return Card(
          elevation: 4,
          child: ListTile(
            title: Text(
              subCategory.subCategoryName.length > 20
                  ? '${subCategory.subCategoryName.substring(0, 20)}...'
                  : subCategory.subCategoryName,
            ),
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SubCategoryDetail(
                    title: 'Edit Subcategory',
                    catId: widget.categoryId,
                    noteId: subCategory.noteId,
                    noteContent: subCategory.subCategoryName,
                    type: ActionType.update,
                  ),
                ),
              );
              stateProviderFetchSubCategories(ref, widget.categoryId);
            },
          ),
        );
      },
    );
  }

  Widget _buildGrid(List subCategories) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: subCategories.length,
      itemBuilder: (context, index) {
        final subCategory = subCategories[index];
        return GestureDetector(
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SubCategoryDetail(
                  catId: widget.categoryId,
                  noteId: subCategory.noteId,
                  noteContent: subCategory.subCategoryName,
                  type: ActionType.update,
                ),
              ),
            );
            stateProviderFetchSubCategories(ref, widget.categoryId);
          },
          child: Dismissible(
            key: Key(subCategory.noteId),
            direction: DismissDirection.endToStart,
            onDismissed: (_) => stateProviderDeleteSubCategory(
              ref,
              widget.categoryId,
              subCategory.noteId,
            ),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: Card(
              elevation: 2,
              child: Center(
                child: Text(
                  subCategory.subCategoryName.length > 20
                      ? '${subCategory.subCategoryName.substring(0, 20)}...'
                      : subCategory.subCategoryName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
