

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/HomePage.dart';
import 'package:pet_care/LoginPage.dart';
import 'package:pet_care/temp.dart';
import 'package:pet_care/test.dart';

import 'GoogleNavBar.dart';

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
        body:Container(
          color: Colors.accents[9],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 400,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/petPic.png'), // Path to your image
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 60,left: 30),
                child: Container(
                  // color: Colors.blue,
                  child: Center(child: Text("Pet Care.io",style: TextStyle(fontSize: 34,fontWeight: FontWeight.w700,color: Colors.blueGrey))),
                ),
              ),
            ],
          ),
        )
    );

  }




}