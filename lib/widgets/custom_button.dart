import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({super.key});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {},
      color: Colors.amber.shade700,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50), // Set border radius to 50
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Text('Login', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
