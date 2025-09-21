import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_application/widgets/custom_button.dart';
import 'package:firebase_application/widgets/custom_login_with_google.dart';
import 'package:firebase_application/widgets/custom_logo.dart';
import 'package:firebase_application/widgets/custom_text_form_field.dart';
import 'package:firebase_application/widgets/dialog_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
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
                validator: (val) {
                  if (val == null || val == "") {
                    return "email must not empty";
                  }
                  return null;
                },
                controller: emailController,
                title: "Email",
                hint: "Enter your email",
              ),
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
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () async {
                    if (emailController.text != "" ||
                        emailController.text.isNotEmpty) {
                      FirebaseAuth.instance!.sendPasswordResetEmail(
                        email: emailController.text,
                      );
                    } else {
                      dialogBox(
                        context,
                        "Please fill email fields",
                        DialogType.info,
                      );
                    }
                  },
                  child: Text('Forget password'),
                ),
              ),
              CustomButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
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
                        .catchError((e) {
                          if (context.mounted) {
                            dialogBox(
                              context,
                              e.toString(),
                              DialogType.warning,
                            );
                          }

                          /*  if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.toString()),
                              duration: Duration(seconds: 5),
                              backgroundColor: Colors.amber,
                            ),
                          );
                        }*/
                        });
                  }

                  /*  try {
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );
                  } on FirebaseAuthException catch (e) {
                    String errorMessage;
                    switch (e.code) {
                      case 'weak-password':
                        errorMessage = 'The password provided is too weak.';
                        print('The password provided is too weak.');
                        break;
                      case 'email-already-in-use':
                        errorMessage =
                            'The account already exists for that email.';
                        dialogBox(context, errorMessage, DialogType.warning);
                        break;
                      case 'invalid-email':
                        errorMessage = 'The email address is not valid.';
                        dialogBox(context, errorMessage, DialogType.warning);

                        break;
                      case 'user-disabled':
                        errorMessage = 'The user has been disabled..';

                        dialogBox(context, errorMessage, DialogType.warning);
                        break;
                      case 'user-not-found':
                        errorMessage = 'The user has been disabled..';

                        dialogBox(context, errorMessage, DialogType.warning);
                        break;
                      case 'wrong-password':
                        errorMessage = 'The password is invalid.';

                        dialogBox(context, errorMessage, DialogType.warning);
                        break;
                      case 'operation-not-allowed':
                        errorMessage = 'Email/password accounts are not enabled.';
                        dialogBox(context, errorMessage, DialogType.warning);
                        break;
                      case 'too-many-requests':
                        errorMessage =
                            'Too many requests. Please try again later.';

                        dialogBox(context, errorMessage, DialogType.warning);
                        break;
                      default:
                        errorMessage = 'An unknown error occurred: ${e.message}';

                        dialogBox(context, errorMessage, DialogType.warning);
                    }
                  } catch (e) {
                    print('An error occurred: $e');
                  }*/
                },
                actionName: 'Login',
              ),
              SizedBox(height: 16),
              CustomLoginWithGoogle(
                onPressed: () async {
                  bool isLogged = await signInWithGoogle();

                  if (context.mounted) {
                    (isLogged)
                        ? Navigator.of(context).pushReplacementNamed('homePage')
                        : dialogBox(context, 'error', DialogType.warning);
                  }
                },
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have an account ? '),
                  TextButton(
                    onPressed: () {
                      //  Navigator.of(context).pushReplacementNamed('signUp');
                      Navigator.of(context).pushNamed('signUp');
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
      ),
    );
  }

  Future<bool> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final user = await googleSignIn.signIn();
    GoogleSignInAuthentication userAuth = await user!.authentication;
    var credential = GoogleAuthProvider.credential(
      idToken: userAuth.idToken,
      accessToken: userAuth.accessToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);

    return FirebaseAuth.instance.currentUser != null;
  }
}
