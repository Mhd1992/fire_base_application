import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_application/home_page/category/add_category_page.dart';
import 'package:firebase_application/home_page/cubit/display_cubit.dart';
import 'package:firebase_application/home_page/cubit/display_state.dart';
import 'package:firebase_application/home_page/sub_category/sub_category_detail.dart';
import 'package:firebase_application/model/sub_category_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubCategoryPage extends ConsumerStatefulWidget {
  const SubCategoryPage({super.key, this.categoryId});

  final String? categoryId;

  @override
  ConsumerState<SubCategoryPage> createState() => _SubCategoryPageState();
}

//List<QueryDocumentSnapshot> categories = [];//other methods to serialize json
List<SubCategoryModel> subCategoryModel = [];

class _SubCategoryPageState extends ConsumerState<SubCategoryPage> {
  bool isLoading = false;

  // DisplayType? type;

  getSubCategoryData() async {
    print('----------\n');
    print('${widget.categoryId}');
    print('----------\n');
    isLoading = true;
    //  categories = [];
    subCategoryModel = [];
    QuerySnapshot data;
    data = await FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryId)
        .collection('notes')
        .get();
    for (var d in data.docs) {
      print('------------Data\n');
      print(d.data());
      subCategoryModel.add(
        SubCategoryModel.fromJson(d.data() as Map<String, dynamic>, d.id),
      );
    }

    // categories.addAll(data.docs);
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    getSubCategoryData();
    getDisplayType();
    super.initState();
  }

  Future<void> getDisplayType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? savedType = prefs.getInt('displayType');

    if (savedType != null) {
      setState(() {
        //  type = DisplayType.values[savedType];
      });
    } else {
      // Default to list if no type is saved
      setState(() {
        //    type = DisplayType.list;
      });
    }
  }

  /* Future<void> saveDisplayType(DisplayType displayType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('displayType', displayType.index);
  }*/

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DisplayCubit(),

      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SubCategoryDetail(
                  title: 'AddNote',
                  catId: widget.categoryId,
                  type: ActionType.add,
                ),
              ),
            );
          },
          backgroundColor: Colors.amber,
          child: Icon(Icons.add, color: Colors.white),
        ),
        appBar: AppBar(
          title: Text('SubCategoryPage'),
          centerTitle: true,
          actions: [
            BlocConsumer<DisplayCubit, DisplayState>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                return IconButton(
                  onPressed: () {
                    context.read<DisplayCubit>().toggleDisplay();
                  },
                  icon: Icon(
                    context.select<DisplayCubit, DisplayItem>(
                              (cubit) => cubit.state.displayItem,
                            ) ==
                            DisplayItem.grid
                        ? Icons.menu
                        : Icons.grid_view_rounded,
                  ),
                );
              },
            ),
          ],
        ),
        body: isLoading == true
            ? Center(child: CircularProgressIndicator())
            : BlocConsumer<DisplayCubit, DisplayState>(
                listener: (context, state) {
                  // TODO: implement listener
                },
                builder: (context, state) {
                  return context.select<DisplayCubit, DisplayItem>(
                            (cubit) => cubit.state.displayItem,
                          ) ==
                          DisplayItem.grid
                      ? buildGrid()
                      : buildList();
                },
              ),

        //
      ),
    );
  }

  Widget buildList() {
    return ListView.builder(
      itemCount: subCategoryModel.length, // Update this if you have more items
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SubCategoryDetail(
                  catId: widget.categoryId,
                  noteId: subCategoryModel[index].noteId,
                  noteContent: subCategoryModel[index].subCategoryName,
                  type: ActionType.update,
                ),
              ),
            );
          },

          child: Card(
            child: Dismissible(
              key: Key(subCategoryModel[index].noteId),
              onDismissed: (direction) async {
                await FirebaseFirestore.instance
                    .collection('categories')
                    .doc(widget.categoryId)
                    .collection('notes')
                    .doc(subCategoryModel[index].noteId)
                    .delete();
              },
              child: ListTile(
                title: Text(
                  subCategoryModel[index].subCategoryName.length > 20
                      ? subCategoryModel[index].subCategoryName.substring(0, 20)
                      : subCategoryModel[index].subCategoryName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildGrid() {
    double screenHeight = MediaQuery.of(context).size.height;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //mainAxisExtent: screenHeight * 0.1,
        crossAxisCount: 2,
      ),
      itemCount: subCategoryModel.length, // Update this if you have more items
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SubCategoryDetail(
                  title: 'updateNote',
                  catId: widget.categoryId,
                  noteId: subCategoryModel[index].noteId,
                  noteContent: subCategoryModel[index].subCategoryName,
                  type: ActionType.update,
                ),
              ),
            );
          },

          child: Dismissible(
            key: Key(subCategoryModel[index].noteId),
            onDismissed: (direction) async {
              await FirebaseFirestore.instance
                  .collection('categories')
                  .doc(widget.categoryId)
                  .collection('notes')
                  .doc(subCategoryModel[index].noteId)
                  .delete();
            },
            child: Card(
              elevation: 2,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  subCategoryModel[index].subCategoryName.length > 20
                      ? subCategoryModel[index].subCategoryName.substring(0, 20)
                      : subCategoryModel[index].subCategoryName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/*

this code below is refactored code usicng bloc and cubit
  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_application/home_page/sub_category/sub_category_detail.dart';
import 'package:firebase_application/model/sub_category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_application/home_page/cubit/display_cubit.dart';
import 'package:firebase_application/home_page/cubit/display_state.dart';

class SubCategoryPage extends ConsumerStatefulWidget {
  const SubCategoryPage({super.key, this.categoryId});

  final String? categoryId;

  @override
  ConsumerState<SubCategoryPage> createState() => _SubCategoryPageState();
}

class _SubCategoryPageState extends ConsumerState<SubCategoryPage> {
  bool isLoading = false;
  List<SubCategoryModel> subCategories = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchSubCategories();
    _getDisplayType();
  }

  Future<void> _fetchSubCategories() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final data = await FirebaseFirestore.instance
          .collection('categories')
          .doc(widget.categoryId)
          .collection('notes')
          .get();

      subCategories = data.docs
          .map((doc) => SubCategoryModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      errorMessage = 'Failed to load subcategories';
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _getDisplayType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getInt('displayType');
    // You can use this value to set display type if needed
  }

  Future<void> _deleteSubCategory(int index) async {
    try {
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(widget.categoryId)
          .collection('notes')
          .doc(subCategories[index].noteId)
          .delete();
      setState(() {
        subCategories.removeAt(index);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete subcategory')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DisplayCubit(),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SubCategoryDetail(
                  title: 'AddNote',
                  catId: widget.categoryId,
                  type: ActionType.add,
                ),
              ),
            ).then((_) => _fetchSubCategories());
          },
          backgroundColor: Colors.amber,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        appBar: AppBar(
          title: const Text('SubCategoryPage'),
          centerTitle: true,
          actions: [
            BlocConsumer<DisplayCubit, DisplayState>(
              listener: (context, state) {},
              builder: (context, state) {
                final isGrid = context.select<DisplayCubit, DisplayItem>(
                  (cubit) => cubit.state.displayItem,
                ) == DisplayItem.grid;
                return IconButton(
                  onPressed: () => context.read<DisplayCubit>().toggleDisplay(),
                  icon: Icon(isGrid ? Icons.menu : Icons.grid_view_rounded),
                );
              },
            ),
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(child: Text(errorMessage!))
                : BlocBuilder<DisplayCubit, DisplayState>(
                    builder: (context, state) {
                      return state.displayItem == DisplayItem.grid
                          ? _buildGrid()
                          : _buildList();
                    },
                  ),
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: subCategories.length,
      itemBuilder: (context, index) {
        final subCategory = subCategories[index];
        return GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SubCategoryDetail(
                catId: widget.categoryId,
                noteId: subCategory.noteId,
                noteContent: subCategory.subCategoryName,
                type: ActionType.update,
              ),
            ),
          ).then((_) => _fetchSubCategories()),
          child: Card(
            child: Dismissible(
              key: Key(subCategory.noteId),
              direction: DismissDirection.endToStart,
              onDismissed: (_) => _deleteSubCategory(index),
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
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: subCategories.length,
      itemBuilder: (context, index) {
        final subCategory = subCategories[index];
        return GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SubCategoryDetail(
                title: 'updateNote',
                catId: widget.categoryId,
                noteId: subCategory.noteId,
                noteContent: subCategory.subCategoryName,
                type: ActionType.update,
              ),
            ),
          ).then((_) => _fetchSubCategories()),
          child: Dismissible(
            key: Key(subCategory.noteId),
            direction: DismissDirection.endToStart,
            onDismissed: (_) => _deleteSubCategory(index),
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
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
 */
