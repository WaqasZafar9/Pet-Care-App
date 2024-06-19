import 'dart:async';
import 'dart:math';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:pet_care/ColorsScheme.dart';
import 'package:pet_care/DataBase.dart';
import 'package:pet_care/GoogleNavBar.dart';
import 'package:pet_care/uihelper.dart';

class PhoneAuthentication extends StatefulWidget {
  Map<String, dynamic> userData;
  PhoneAuthentication({super.key, required this.userData});

  @override
  State<PhoneAuthentication> createState() => _PhoneAuthenticationState();
}

class _PhoneAuthenticationState extends State<PhoneAuthentication> {
  @override
  void initState() {
    super.initState();
    sendCode();
  }

  late String OTP;
  bool isResendButtonVisible = false;
  var phoneController = TextEditingController();

  sendCode() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        timeout: Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException ex) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Sent!',
              message: '${ex.code.toString()} + " Code Error"',
              contentType: ContentType.failure,
            ),
          ));
        },
        codeSent: (String verificationID, int? resentToken) {
          OTP = verificationID;
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Sent!',
              message: 'Code Sent!',
              contentType: ContentType.success,
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        codeAutoRetrievalTimeout: (String VerificationID) {},
        phoneNumber: widget.userData["PhoneNo"]);
  }

  VerifyCode() async {
    try {
      PhoneAuthCredential credential = await PhoneAuthProvider.credential(
          verificationId: OTP, smsCode: otp.text.toString());
      FirebaseAuth.instance.signInWithCredential(credential).then(
        (value) {
          DataBase.updateUserData(
              "UserData", widget.userData["Email"], {"isVerified": true});
          widget.userData["isVerified"] = true;
          uiHelper.customAlertBox(() {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Tests(userData: widget.userData),
                ));
          }, context, "Verification Successfull");
        },
      ).onError((error, stackTrace) => uiHelper.customAlertBox(
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
        title: Text("Phone Verification",style: TextStyle(
          color: subTextColor
        ),),
        backgroundColor: appBarColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: backgroundColor
        ),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: otp,
                  validator: (value) => otpValidate(value),
                  style: TextStyle(
                    color: subTextColor
                  ),
                  decoration: InputDecoration(
                      labelText: "OTP",
                      labelStyle: TextStyle(
                        color: subTextColor
                      ),
                      prefixIcon: Icon(Icons.message,color: subTextColor,),
                      suffixIcon: Visibility(
                        visible: isResendButtonVisible,
                        child: TextButton(
                          onPressed: () {

                          },
                          child: Text(
                            "Resend",
                            style: TextStyle(fontSize: 10),
                          ),
                          style: ButtonStyle(
                              visualDensity: VisualDensity.comfortable),
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
      ),
    );
  }
}
