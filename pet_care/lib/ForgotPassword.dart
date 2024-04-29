import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/LoginPage.dart';
import 'package:pet_care/uihelper.dart';

class ResetPassword extends StatefulWidget {
  ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  emailValidator(String? value) {
    if (value!.isEmpty) {
      return "Please Enter Email";
    } else {
      return null;
    }
  }

  submitForm(value) {
    if (formKey.currentState!.validate()) {
      try {
        FirebaseAuth.instance.sendPasswordResetEmail(email: value);
        uiHelper.customAlertBox(
                (){
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Login(),));
            }
            ,context, "Reset Link Sent !");
      } on FirebaseAuthException catch (ex) {
         uiHelper.customAlertBox((){},context, ex.code.toString());
      }
    } else {
      uiHelper.customAlertBox((){},context, "Please Enter Email");
    }
    print("Clicked");
  }

  TextEditingController email = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Pet Care")),
      ),
      body: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                validator: (value) => emailValidator(value),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                submitForm(email.text);
              },
              child: Text("Reset Password"),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(180, 50)),
                elevation: MaterialStateProperty.all(5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
