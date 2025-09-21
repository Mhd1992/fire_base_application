import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_application/widgets/custom_button.dart';
import 'package:firebase_application/widgets/custom_text_form_field.dart';
import 'package:firebase_application/widgets/dialog_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({
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
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

enum ActionType { add, update }

class _AddCategoryPageState extends State<AddCategoryPage> {
  @override
  void initState() {
    if (widget.categoryName != null) {
      categoryController.text = widget.categoryName.toString();
    }
    super.initState();
  }

  TextEditingController categoryController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  CollectionReference categories = FirebaseFirestore.instance.collection(
    'categories',
  );
  bool isLoading = false;

  Future<void> addSubCategory() async {
    bool existElement = await checkIfExist(categoryController.text);
    setState(() {
      isLoading = true;
    });
    if (existElement) {
      categories
          .add({
            'categoryName': categoryController.text,
            'userId': FirebaseAuth.instance.currentUser!.uid,
          })
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
    } else {
      setState(() {
        isLoading = false;
      });
      dialogBox(context, 'Existed Item', DialogType.error);
    }
  }

  Future<void> updateCategory() async {
    bool existElement = await checkIfExist(categoryController.text);
    if (existElement) {
      try {
        setState(() {
          isLoading = true;
        });
        await FirebaseFirestore.instance
            .collection('categories')
            .doc(widget.categoryId)
            .update({'categoryName': categoryController.text})
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
    final element = await categories
        .where('categoryName', isEqualTo: categoryName)
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (element.docs.isEmpty) {
      return true;
    }

    return false;
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
                          controller: categoryController,
                          hint: 'Enter Category Name',
                          title: widget.categoryName ?? 'categoryName',
                          validator: (val) {
                            if (val == null || val == "") {
                              return "category name must not empty";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 8),
                        CustomButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              if (widget.type == ActionType.update) {
                                updateCategory();
                              } else {
                                addSubCategory();
                              }
                            }
                          },
                          actionName: (widget.type == ActionType.update)
                              ? 'updateCategory'
                              : 'AddCategory',
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
