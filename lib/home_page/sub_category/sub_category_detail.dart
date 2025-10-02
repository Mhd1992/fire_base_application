import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_application/home_page/category/add_category_page.dart';
import 'package:firebase_application/widgets/custom_note_form_field.dart';
import 'package:firebase_application/widgets/dialog_box.dart';
import 'package:flutter/material.dart';

class SubCategoryDetail extends StatefulWidget {
  const SubCategoryDetail({
    super.key,
    this.title,
    this.catId,
    this.type,
    this.noteId,
    this.noteContent,
  });

  final String? title;
  final String? catId;
  final String? noteId;
  final String? noteContent;
  final ActionType? type;

  @override
  State<SubCategoryDetail> createState() => _SubCategoryDetailState();
}

class _SubCategoryDetailState extends State<SubCategoryDetail> {
  GlobalKey<FormState> formKey = GlobalKey();

  CollectionReference? notes;
  bool isLoading = false;
  TextEditingController noteController = TextEditingController();

  Future<void> addNote() async {
    notes = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.catId)
        .collection('notes');
    setState(() {
      isLoading = true;
    });

    notes!
        .add({'subCategoryName': noteController.text})
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

  Future<void> updateNote() async {
    await FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.catId)
        .collection('notes')
        .doc(widget.noteId)
        .update({'subCategoryName': noteController.text})
        .then((val) {
          dialogBox(
            context,
            'note update successfully',
            DialogType.success,
            onOkPressed: () => Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('homePage', (r) => false),
          );
        })
        .catchError((e) {
          dialogBox(context, e.toString(), DialogType.error);
        });
  }

  @override
  void initState() {
    if (widget.noteContent != null) {
      noteController.text = widget.noteContent.toString();
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Form(
                    key: formKey,
                    child: CustomNoteFormField(
                      controller: noteController,
                      noteTitle: widget.title ?? '',

                      validator: (val) {
                        if (val == null || val == "") {
                          return "";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            if (widget.type == ActionType.add) {
              addNote();
            } else {
              updateNote();
            }
          } else {
            dialogBox(context, 'not must not empty', DialogType.error);
          }
        },
        child: Icon(widget.type == ActionType.update ? Icons.edit : Icons.add),
      ),
    );
  }
}
