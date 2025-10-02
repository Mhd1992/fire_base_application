import 'package:flutter/material.dart';

class CustomNoteFormField extends StatefulWidget {
  final String? noteTitle;
  final String? noteHint;

  final void Function()? onPressed;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CustomNoteFormField({
    super.key,
    this.noteTitle,
    this.noteHint,
    required this.controller,
    required this.validator,

    this.onPressed,
  });

  @override
  State<CustomNoteFormField> createState() => _CustomNoteFormFieldState();
}

class _CustomNoteFormFieldState extends State<CustomNoteFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      controller: widget.controller,
      onTap: widget.onPressed ?? () {},
      maxLines: null,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 20),
        filled: true,
        border: InputBorder.none,
        fillColor: Colors.transparent,
      ),
    );
  }
}
