import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:pet_care/GoogleNavBar.dart';
import 'package:pet_care/uihelper.dart';

class PhoneAuthentication extends StatefulWidget {
  const PhoneAuthentication({super.key});

  @override
  State<PhoneAuthentication> createState() => _PhoneAuthenticationState();
}

class _PhoneAuthenticationState extends State<PhoneAuthentication> {



  late String OTP;
  String phoneNo = "+923014384681";
  bool isResendButtonVisible=false;
  var phoneController=TextEditingController();

  sendCode() async {
    phoneNo=phoneController.text;
    await FirebaseAuth.instance.verifyPhoneNumber(
        timeout: Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException ex) {
          uiHelper.customAlertBox(
              () {}, context, ex.code.toString() + " Code Error");
        },
        codeSent: (String verificationID, int? resentToken) {
          OTP = verificationID;
          uiHelper.customAlertBox(() {}, context, "Code Sent SuccessFully");
        },
        codeAutoRetrievalTimeout: (String VerificationID) {},
        phoneNumber: phoneNo);
  }

  VerifyCode() async {
    try {
      PhoneAuthCredential credential = await PhoneAuthProvider.credential(
          verificationId: OTP, smsCode: otp.text.toString());
      // FirebaseAuth.instanece.signInWithCredential(credential).then((value) => MaterialPageRoute(builder: (context) => Tests(),));
      FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) => uiHelper.customAlertBox(
              () {}, context, "Verification SuccessFull"))
          .onError((error, stackTrace) => uiHelper.customAlertBox(
              () {}, context, error.toString() + "Verification Error"));
    } catch (ex) {
      uiHelper.customAlertBox(() {}, context, ex.toString());
      // log(ex.toString() as num);
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
            uiHelper.customTextField(phoneController, "Phone No", Icons.message, false)
            ,
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
            ElevatedButton(
                onPressed: () => sendCode(),
                child: Text("Verify"),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(180, 50)),
                  elevation: MaterialStateProperty.all(5),
                )),
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
