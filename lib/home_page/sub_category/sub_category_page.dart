import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_application/home_page/category/add_category_page.dart';
import 'package:firebase_application/home_page/sub_category/sub_category_detail.dart';
import 'package:firebase_application/model/sub_category_model.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubCategoryPage extends StatefulWidget {
  const SubCategoryPage({super.key, this.categoryId});

  final String? categoryId;

  @override
  State<SubCategoryPage> createState() => _SubCategoryPageState();
}

//List<QueryDocumentSnapshot> categories = [];//other methods to serialize json
List<SubCategoryModel> subCategoryModel = [];

enum DisplayType { list, grid }

class _SubCategoryPageState extends State<SubCategoryPage> {
  bool isLoading = false;
  DisplayType? type;

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
        type = DisplayType.values[savedType];
      });
    } else {
      // Default to list if no type is saved
      setState(() {
        type = DisplayType.list;
      });
    }
  }

  Future<void> saveDisplayType(DisplayType displayType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('displayType', displayType.index);
  }

  @override
  Widget build(BuildContext context) {
    print('-----------\n${widget.categoryId}\n----------------');
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              /* builder: (context) => AddSubCategoryPage(
                title: 'AddSubCategory',
                categoryId: widget.categoryId,
              ),*/
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
          IconButton(
            onPressed: () {
              setState(() {
                if (type == DisplayType.list) {
                  type = DisplayType.grid;
                } else {
                  type = DisplayType.list;
                }
                saveDisplayType(type!); // Save the selected display type
              });
            },
            icon: Icon(
              type == DisplayType.grid ? Icons.menu : Icons.grid_view_rounded,
            ),
          ),
        ],
      ),
      body: isLoading == true
          ? Center(child: CircularProgressIndicator())
          : (type == DisplayType.grid)
          ? buildGrid()
          : buildList(),
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
