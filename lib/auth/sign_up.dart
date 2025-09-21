import 'package:firebase_application/widgets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign up '), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              SizedBox(height: 16),
              Center(
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    color: ColorScheme.of(context).outlineVariant,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/logo.png'),
                  ),
                ),
              ),
              Text(
                'SIGNUP',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Register to using App',
                style: TextStyle(
                  color: ColorScheme.of(context).onPrimaryContainer,
                ).copyWith(fontSize: 16.0),
              ),
              SizedBox(height: 16),
              CustomTextFormField(
                title: 'Email',
                hint: 'Enter Your email',
                controller: emailController,
                validator: (val) {
                  if (val == null || val == "") {
                    {
                      return "Email must not null";
                    }
                  }
                },
              ),

              SizedBox(height: 32),
              CustomTextFormField(
                title: 'userName',
                hint: 'Enter Your name',
                controller: userNameController,
                validator: (val) {
                  if (val == null || val == "") {
                    {
                      return "userName must not null";
                    }
                  }
                },
              ),

              SizedBox(height: 8),
              SizedBox(height: 32),
              CustomTextFormField(
                validator: (val) {
                  if (val == null || val == "") {
                    return "password must not empty";
                  }
                  return null;
                },
                controller: passwordController,
                title: "Password",
                hint: "Enter your password",
                suffixIcon: Icon(Icons.remove_red_eye),
              ),

              /*    SizedBox(height: 32),
              TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: ColorScheme.of(context).surfaceContainer,
                  label: Text('confirm Password'),
                  hintText: 'Enter confirmed password',
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
          */
              SizedBox(height: 16),
              MaterialButton(
                onPressed: () async {
                  // try {
                  if (formKey.currentState!.validate()) {
                    await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text,
                        )
                        .then((val) {
                          if (context.mounted) {
                            Navigator.of(
                              context,
                            ).pushReplacementNamed('homePage');
                          }
                        })
                        .catchError((error) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(error.toString()),
                                duration: Duration(seconds: 5),
                                backgroundColor: Colors.amber,
                              ),
                            );
                          }
                        });
                  }
                },

                color: Colors.amber.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    50,
                  ), // Set border radius to 50
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text('SignUp ', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
