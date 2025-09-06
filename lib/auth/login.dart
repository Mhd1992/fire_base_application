import 'package:firebase_application/auth/sign_up.dart';
import 'package:firebase_application/widgets/custom_button.dart';
import 'package:firebase_application/widgets/custom_login_with_google.dart';
import 'package:firebase_application/widgets/custom_logo.dart';
import 'package:firebase_application/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            SizedBox(height: 16),
            CustomLogo(),
            Text(
              'LOGIN',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Login to continue use App',
              style: TextStyle(
                color: ColorScheme.of(context).onPrimaryContainer,
              ).copyWith(fontSize: 16.0),
            ),
            SizedBox(height: 16),
            CustomTextFormField(
              controller: emailController,
              title: "Email",
              hint: "Enter your email",
            ),
            SizedBox(height: 32),
            CustomTextFormField(
              controller: passwordController,
              title: "Password",
              hint: "Enter your password",
              suffixIcon: Icon(Icons.remove_red_eye),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text('Forget password'),
              ),
            ),
            CustomButton(),
            SizedBox(height: 16),
            CustomLoginWithGoogle(),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Don\'t have an account ? '),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                    );
                  },
                  child: Text(
                    'SignUp',
                    style: TextStyle(color: Colors.amber.shade700),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
