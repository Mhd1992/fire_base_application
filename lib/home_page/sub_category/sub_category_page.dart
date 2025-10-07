import 'package:firebase_application/home_page/category/add_category_page.dart';
import 'package:firebase_application/provider/display_type_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_application/home_page/sub_category/sub_category_detail.dart';

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
      () => ref.read(subCategoriesProvider.notifier).fetch(widget.categoryId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayType1 = ref.watch(displayTypeProvider1);
    //final displayType1 = ref.watch(displayTypeProvider);
    final subCategoriesAsync = ref.watch(subCategoriesProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SubCategoryDetail(
                title: 'AddNote',
                catId: widget.categoryId,
                type: ActionType.add,
              ),
            ),
          );
          ref.read(subCategoriesProvider.notifier).fetch(widget.categoryId);
        },
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        title: const Text('SubCategoryPage'),
        centerTitle: true,
        actions: [
          IconButton(
            // onPressed: () => ref.read(displayTypeProvider.notifier).toggle(), ///in this case using Provider.StateNotifier instead of StateProvider.
            onPressed: () {
              ref
                  .read(displayTypeProvider1.notifier)
                  .state = displayType1 == DisplayType.list
                  ? DisplayType.grid
                  : DisplayType.list;
            },
            icon: Icon(
              displayType1 == DisplayType.grid
                  ? Icons.menu
                  : Icons.grid_view_rounded,
            ),
          ),
        ],
      ),
      body: subCategoriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (subCategories) {
          if (subCategories.isEmpty) {
            return const Center(child: Text('No subcategories found.'));
          }
          return displayType1 == DisplayType.grid
              ? _buildGrid(subCategories)
              : _buildList(subCategories);
        },
      ),
    );
  }

  Widget _buildList(List subCategories) {
    return ListView.builder(
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
            ref.read(subCategoriesProvider.notifier).fetch(widget.categoryId);
          },
          child: Card(
            child: Dismissible(
              key: Key(subCategory.noteId),
              direction: DismissDirection.endToStart,
              onDismissed: (_) => ref
                  .read(subCategoriesProvider.notifier)
                  .delete(widget.categoryId, subCategory.noteId),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: ListTile(
                title: Text(
                  subCategory.subCategoryName.length > 20
                      ? '${subCategory.subCategoryName.substring(0, 20)}...'
                      : subCategory.subCategoryName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
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
                  title: 'updateNote',
                  catId: widget.categoryId,
                  noteId: subCategory.noteId,
                  noteContent: subCategory.subCategoryName,
                  type: ActionType.update,
                ),
              ),
            );
            ref.read(subCategoriesProvider.notifier).fetch(widget.categoryId);
          },
          child: Dismissible(
            key: Key(subCategory.noteId),
            direction: DismissDirection.endToStart,
            onDismissed: (_) => ref
                .read(subCategoriesProvider.notifier)
                .delete(widget.categoryId, subCategory.noteId),
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
