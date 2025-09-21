import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_application/home_page/category/add_category_page.dart';
import 'package:firebase_application/model/sub_category_model.dart';
import 'package:firebase_application/widgets/dialog_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'add_sub_category_page.dart';

class SubCategoryPage extends StatefulWidget {
  const SubCategoryPage({super.key, this.categoryId});

  final String? categoryId;

  @override
  State<SubCategoryPage> createState() => _SubCategoryPageState();
}

//List<QueryDocumentSnapshot> categories = [];//other methods to serialize json
List<SubCategoryModel> subCategoryModel = [];

class _SubCategoryPageState extends State<SubCategoryPage> {
  bool isLoading = false;

  getData() async {
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
        SubCategoryModel.fromJson(d.data() as Map<String, dynamic>),
      );
    }

    // categories.addAll(data.docs);
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddSubCategoryPage(
                title: 'AddSubCategory',
                categoryId: widget.categoryId,
              ),
            ),
          );
        },
        backgroundColor: Colors.amber,
        child: Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(title: Text('HomePage'), centerTitle: true, actions: []),
      body: isLoading == true
          ? Center(child: CircularProgressIndicator())
          : (!FirebaseAuth.instance.currentUser!.emailVerified)
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Click for verify your email ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(width: 16),
                MaterialButton(
                  onPressed: () {
                    FirebaseAuth.instance.currentUser!
                        .sendEmailVerification()
                        .then((val) {
                          if (context.mounted) {
                            dialogBox(
                              context,
                              'Success please logout and login ',
                              DialogType.success,
                            );
                          }
                        })
                        .catchError((e) {});
                  },
                  color: Colors.amber.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Text('Send', style: TextStyle(color: Colors.white)),
                ),
              ],
            )
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: screenHeight * 0.25,
                crossAxisCount: 2,
              ),
              itemCount:
                  subCategoryModel.length, // Update this if you have more items
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onLongPress: () {
                    dialogBox(
                      context,
                      'you want delete this item ',
                      DialogType.warning,
                      onOkPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('categories')
                            .doc(subCategoryModel[index].subCategoryName)
                            .delete();
                        await getData();
                      },
                    );
                  },

                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: Card(
                          child: Column(
                            children: [
                              Text(
                                // categories[index]['categoryName'],
                                subCategoryModel[index].subCategoryName,
                              ), // Adjust the text based on the index
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(.0),
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AddSubCategoryPage(
                                  title: 'updateSubCategory',
                                  categoryId: widget.categoryId,
                                  categoryName:
                                      subCategoryModel[index].subCategoryName,
                                  type: ActionType.update,
                                ),
                              ),
                            );
                            //Navigator.of(context).pushNamed('addCategory');
                          },
                          icon: Icon(Icons.edit, color: Colors.orange),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
