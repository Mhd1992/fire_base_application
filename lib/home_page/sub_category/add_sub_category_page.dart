import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_application/home_page/category/add_category_page.dart';
import 'package:firebase_application/widgets/custom_button.dart';
import 'package:firebase_application/widgets/custom_text_form_field.dart';
import 'package:firebase_application/widgets/dialog_box.dart';
import 'package:flutter/material.dart';

class AddSubCategoryPage extends StatefulWidget {
  const AddSubCategoryPage({
    super.key,
    required this.title,
    this.categoryName,
    this.categoryId,
    this.type,
  });

  final String title;
  final String? categoryName;
  final String? categoryId;
  final ActionType? type;

  @override
  State<AddSubCategoryPage> createState() => _AddSubCategoryPageState();
}

class _AddSubCategoryPageState extends State<AddSubCategoryPage> {
  @override
  void initState() {
    if (widget.categoryName != null) {
      subCategoryController.text = widget.categoryName.toString();
    }

    super.initState();
  }

  TextEditingController subCategoryController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  String? catId;
  CollectionReference? subCategories;
  bool isLoading = false;

  Future<void> addSubCategory() async {
    print('Added categoryId---------\n ');
    print(widget.categoryId);
    subCategories = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryId)
        .collection('notes');
    setState(() {
      isLoading = true;
    });

    subCategories!
        .add({'subCategoryName': subCategoryController.text})
        .then((val) {
          setState(() {
            isLoading = false;
          });
          if (context.mounted) {
            dialogBox(
              context,
              'Added Successfully',
              DialogType.success,
              onOkPressed: () => Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('homePage', (r) => false),
            );
          }
        })
        .catchError((error) {
          setState(() {
            isLoading = false;
          });
          dialogBox(context, error, DialogType.error);
        });
  }

  Future<void> updateSubCategory() async {
    bool existElement = await checkIfExist(subCategoryController.text);
    if (existElement) {
      try {
        setState(() {
          isLoading = true;
        });
        await FirebaseFirestore.instance
            .collection('categories')
            .doc(widget.categoryId)
            .update({'categoryName': subCategoryController.text})
            .then((val) {
              setState(() {
                isLoading = false;
              });
              dialogBox(
                context,
                'Updated Successfully',
                DialogType.success,
                onOkPressed: () => Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('homePage', (r) => false),
              );
            });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
      dialogBox(context, 'Existed Item', DialogType.error);
    }
  }

  Future<bool> checkIfExist(String categoryName) async {
    /*  final element = await subCategories!
        .where('subCategoryName', isEqualTo: categoryName)
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (element.docs.isEmpty) {
      return true;
    }*/

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: (isLoading)
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        CustomTextFormField(
                          controller: subCategoryController,
                          hint: 'Enter SubCategory Name',
                          title: widget.categoryName ?? 'subCategoryName',
                          validator: (val) {
                            if (val == null || val == "") {
                              return "subcategory name must not empty";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 8),
                        CustomButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              if (widget.type == ActionType.update) {
                                updateSubCategory();
                              } else {
                                addSubCategory();
                              }
                            }
                          },
                          actionName: (widget.type == ActionType.update)
                              ? 'updateSubCategory'
                              : 'AddSubCategory',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
