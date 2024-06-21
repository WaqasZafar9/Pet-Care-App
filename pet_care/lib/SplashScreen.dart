

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/ColorsScheme.dart';
import 'package:pet_care/CredentialsScreen/LoginPage.dart';
import 'package:pet_care/DataBase.dart';
import 'package:pet_care/HomePage/petScreenDynamicDarkFinal.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => SplashScreenState();

}

class SplashScreenState extends State<SplashScreen>{

  @override
  void initState() {
    super.initState();

    isUserSaved();
  }

  isUserSaved() async{
    var pref=await SharedPreferences.getInstance();

    if (pref.containsKey('userEmail')) {
      var userEmail=pref.getString("userEmail");
      Map<String,dynamic> userData=await DataBase.readData("UserData",userEmail!);
      await Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => petScreenDynamicDark( userData: userData,)));
    }
    else{
      Timer(const Duration(seconds: 1), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
      });
    }

  }


  Widget build(BuildContext Context){

    return Scaffold(
      // ScreenSwitching
        body:Container(
          // color: Colors.accents[9],
          color: appBarColor,
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
                  child: Center(child: Text("Pet Care.io",style: TextStyle(fontSize: 34,fontWeight: FontWeight.w700,color: Colors.blueGrey.shade200))),
                ),
              ),
            ],
          ),
        )
    );

  }




}