
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/GoogleNavBar.dart';
import 'package:pet_care/LoginPage.dart';

class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
  checkuser() async{
    final user= FirebaseAuth.instance.currentUser;
    if(user!=null){
      return Tests();
    }
    else{
      return Login();
    }
  }
}
