import 'package:flutter/material.dart';

class CustomLoginWithGoogle extends StatefulWidget {
  const CustomLoginWithGoogle({super.key, required this.onPressed});
  final void Function()? onPressed;
  @override
  State<CustomLoginWithGoogle> createState() => _CustomLoginWithGoogleState();
}

class _CustomLoginWithGoogleState extends State<CustomLoginWithGoogle> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: widget.onPressed,
      color: Colors.red.shade700,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50), // Set border radius to 50
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Login with google', style: TextStyle(color: Colors.white)),
            SizedBox(width: 4),
            Image.asset('assets/google.png', height: 20, width: 20),
          ],
        ),
      ),
    );
  }
}
