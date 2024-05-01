import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/CheckFiles.dart';
import 'package:pet_care/CommunityScreen.dart';
import 'package:pet_care/ForgotPassword.dart';
import 'package:pet_care/LoginPage.dart';
import 'package:pet_care/ProfilePage.dart';
import 'package:pet_care/SignUpPageForm.dart';
import 'package:pet_care/SplashScreen.dart';
import 'package:pet_care/phoneAuthentication.dart';

import 'GoogleNavBar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print("FireBase Added");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    Map<String,dynamic> userData={
      "Name":"Jerry",
      "Email":"fuzailraza161@gmail.com",
      "isVerified":false,
      "PhoneNo":"+923014384681"
    };
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pet Care',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.black38,
            // background: Color.fromRGBO(10, 101, 10, 0.2),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: Colors.deepOrange),
            ),
            prefixStyle: const TextStyle(color: Colors.black),
            labelStyle: const TextStyle(color: Colors.black),
          ),
          textTheme: TextTheme(
              displayLarge: TextStyle(
            decorationStyle: TextDecorationStyle.solid,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          )),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.greenAccent,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.blue,
          ),
          dividerTheme: DividerThemeData(
              color: Colors.grey.shade500,
              thickness: BorderSide.strokeAlignOutside,
              space: CircularProgressIndicator.strokeAlignCenter,
              indent: 10,
              endIndent: 30)),
      initialRoute: '/',
      routes: {
        '/': (context) =>Tests(userData: userData,),
        // '/': (context) =>PhoneAuthentication(userData: userData),
        'Google Nav Bar': (context) => Tests(userData: {
          "Name":"Test Call"
        }),
        'Forgot Screen': (context) => ResetPassword(),
        'PhoneAuthenticate': (context) => PhoneAuthentication(userData: userData,),
        'Signup Page': (context) => SignUpForm(),
      },
      // home: const checkFiles(),
    );
  }
}
