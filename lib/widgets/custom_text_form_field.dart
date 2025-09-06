import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String title;
  final String hint;
  final Widget? suffixIcon;
  final void Function()? onPressed;
  final TextEditingController controller;

  const CustomTextFormField({
    super.key,
    required this.title,
    required this.hint,
    required this.controller,
    this.suffixIcon,
    this.onPressed,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onTap: widget.onPressed ?? () {},
      decoration: InputDecoration(
        suffixIcon: widget.suffixIcon ?? SizedBox(),
        contentPadding: EdgeInsets.symmetric(horizontal: 20),
        label: Text(widget.title),
        hintText: widget.hint,
        filled: true,
        fillColor: ColorScheme.of(context).surfaceContainer,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: Colors.green),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
