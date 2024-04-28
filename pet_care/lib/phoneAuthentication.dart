import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:pet_care/DataBase.dart';
import 'package:pet_care/GoogleNavBar.dart';
import 'package:pet_care/HomePage.dart';
import 'package:pet_care/uihelper.dart';

class PhoneAuthentication extends StatefulWidget {
  Map<String,dynamic> userData;
  PhoneAuthentication({super.key,required this.userData});

  @override
  State<PhoneAuthentication> createState() => _PhoneAuthenticationState();
}

class _PhoneAuthenticationState extends State<PhoneAuthentication> {

  @override
  void initState() {
    super.initState();
    // sendCode();
  }



  late String OTP;
  bool isResendButtonVisible=false;
  var phoneController=TextEditingController();

  sendCode() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        timeout: Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException ex) {
          uiHelper.customAlertBox(
              () {}, context, ex.code.toString() + " Code Error");
        },
        codeSent: (String verificationID, int? resentToken) {
          OTP = verificationID;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Code Sent")));
        },
        codeAutoRetrievalTimeout: (String VerificationID) {},
        phoneNumber: widget.userData["PhoneNo"]);
  }

  VerifyCode() async {
    try {
      PhoneAuthCredential credential = await PhoneAuthProvider.credential(
          verificationId: OTP, smsCode: otp.text.toString());
       FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) {
         DataBase.updateUserData("UserData", widget.userData["Email"] , {
          "isVerified": true
        }
        );
            uiHelper.customAlertBox(() { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Tests(userData: widget.userData),));}, context, "Verification Successfull");
          },).onError((error, stackTrace) => uiHelper.customAlertBox(
              () {}, context, error.toString() + "Verification Error"));
    } catch (ex) {
      uiHelper.customAlertBox(() {}, context, ex.toString());
    }

  }

  otpValidate(value) {
    if (value!.isEmpty) {
      if (value!.isEmpty) {
        return "Please Enter OTP";
      }
      return null;
    }
  }

  TextEditingController otp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Phone Verification"),
      ),
      body: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: otp,
                validator: (value) => otpValidate(value),
                decoration: InputDecoration(
                    labelText: "OTP",
                    prefixIcon: Icon(Icons.message),
                    suffixIcon: Visibility(
                      visible: isResendButtonVisible,
                      child: TextButton(
                        onPressed: () {},
                        child: Text("Resend",style: TextStyle(
                          fontSize: 10
                        ),),
                        style:ButtonStyle(
                          visualDensity: VisualDensity.comfortable
                        ),
                      ),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                  onPressed: () => VerifyCode(),
                  child: Text("Verify OTP"),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(180, 50)),
                    elevation: MaterialStateProperty.all(5),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
