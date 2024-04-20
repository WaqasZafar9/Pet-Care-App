import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/LoginPage.dart';
import 'package:pet_care/SplashScreen.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pet Care',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black38),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(color: Colors.deepOrange),
          ),
          prefixStyle: const TextStyle(color: Colors.black),
          labelStyle: const TextStyle(color: Colors.black),
        ),

        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.greenAccent,
        )
      ),
      home: SplashScreen(),
    );
  }
}