
import 'package:flutter/material.dart';
import 'package:login_page_practice/pages/LoginPage.dart';
import 'package:login_page_practice/pages/cartpage.dart';
import 'package:login_page_practice/pages/shopping.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: "Pet Care App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      routes: {
        "shopping" : (context) => shopping(),
        "cartpage" : (context) => cartpage(),
      },
    );
  }
}
