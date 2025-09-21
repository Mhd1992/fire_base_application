import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({super.key, required this.onPressed, this.actionName});

  final void Function()? onPressed;
  final String? actionName;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    widget.actionName ?? "Login";
    return MaterialButton(
      onPressed: widget.onPressed,
      color: Colors.amber.shade700,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50), // Set border radius to 50
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Text(
          widget.actionName.toString(),
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
