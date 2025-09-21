import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_application/home_page/category/add_category_page.dart';
import 'package:firebase_application/home_page/sub_category/sub_category_page.dart';
import 'package:firebase_application/model/category_model.dart';
import 'package:firebase_application/widgets/dialog_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

List<QueryDocumentSnapshot> categories = [];
List<CategoryModel> models = [];

class _HomePageState extends State<HomePage> {
  bool isLoading = false;

  getData() async {
    isLoading = true;
    categories = [];
    models = [];
    QuerySnapshot data;
    data = await FirebaseFirestore.instance
        .collection('categories')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    for (var d in data.docs) {
      models.add(
        CategoryModel.fromJson(d.data() as Map<String, dynamic>, d.id),
      );
      print('----------------\n');
      print('${d.id}----->');
      print(d.data());
      print('----------------\n');
    }
    categories.addAll(data.docs);
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
          Navigator.of(context).pushNamed('addCategory');
        },
        backgroundColor: Colors.amber,
        child: Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        title: Text('HomePage'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('login', (r) => false);

              GoogleSignIn googleSigned = GoogleSignIn();
              googleSigned.signOut();
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
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
                  categories.length, // Update this if you have more items
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SubCategoryPage(
                          categoryId: models[index].categoryId,
                        ),
                      ),
                    );
                  },
                  onLongPress: () {
                    dialogBox(
                      context,
                      'you want delete this item ',
                      DialogType.warning,
                      onOkPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('categories')
                            .doc(models[index].categoryId)
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
                        child: Card(
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/folder.png',
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.scaleDown,
                              ),
                              Text(
                                // categories[index]['categoryName'],
                                models[index].categoryName,
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
                                builder: (context) => AddCategoryPage(
                                  title: 'updateCategory',
                                  categoryId: models[index].categoryId,
                                  categoryName: models[index].categoryName,
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
