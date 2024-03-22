

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/LoginPage.dart';

class SplashScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => SplashScreenState();



}

class SplashScreenState extends State<SplashScreen>{

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
    });

  }


  Widget build(BuildContext Context){

    return Scaffold(
      // ScreenSwitching
        body:Column(
          children: [
            SizedBox(
              height: 250,
            ),
            Container(
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bgNo.png'), // Path to your image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              // color: Colors.blue,
              child: Center(child: Text("Pet Care.io",style: TextStyle(fontSize: 34,fontWeight: FontWeight.w700,color: Colors.blueGrey))),
            ),
          ],
        )
    );

  }




}