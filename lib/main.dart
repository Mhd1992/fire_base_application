import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_application/auth/login.dart';
import 'package:firebase_application/auth/sign_up.dart';
import 'package:firebase_application/home_page/category/add_category_page.dart';
import 'package:firebase_application/home_page/home/home_page.dart';
import 'package:firebase_application/home_page/sub_category/add_sub_category_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("Error initializing Firebase: $e");
    return; // Exit if Firebase initialization fails
  }
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),

    androidProvider: AndroidProvider.debug,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('-------->>>>> User is currently signed out!');
      } else {
        print('-------->>>>> User is signed in!');
      }
    });

    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          //backgroundColor: Colors.grey,
          elevation: 1,
          titleTextStyle: TextStyle(
            color: Colors.amber.shade700,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.orange),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

      home: Scaffold(
        body: FirebaseAuth.instance.currentUser == null ? Login() : HomePage(),
      ),
      routes: {
        'login': (context) => Login(),
        'signUp': (context) => SignUp(),
        'homePage': (context) => HomePage(),
        'addCategory': (context) => AddCategoryPage(title: 'AddNewCategory'),
      },
    );
  }
}
