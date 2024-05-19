import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_care/DataBase.dart';
import 'package:pet_care/LoginPage.dart';
import 'package:pet_care/uihelper.dart';

class SignUpForm extends StatefulWidget {
  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  File? pickedImage;

  showAlertBox() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Pick Image From"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
                leading: Icon(Icons.camera_alt),
                title: Text("Camera"),
              ),
              ListTile(
                onTap: () {
                  pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
                leading: Icon(Icons.image),
                title: Text("Gallery"),
              ),
            ],
          ),
        );
      },
    );
  }

  pickImage(ImageSource imageSource) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageSource);
      if (photo == null) return;
      setState(() {
        pickedImage = File(photo.path);
      });
    } catch (ex) {
      print("Error ${ex.toString()}");
    }
  }

  signUP(userData) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: userData["Email"], password: userData["Password"])
          .then((value) async {
        uiHelper.customAlertBox(() {}, context, "Uploading");
        var url = await DataBase.uploadImage(
            userData["Email"], "ProfilePics", pickedImage);
        if (url == null) {
          return uiHelper.customAlertBox(
                  () {}, context, "Pic Upload Unsuccessful");
        }
        userData["Pic"] = url;

        if (await DataBase.saveUserData("UserData", userData)) {
          uiHelper.customAlertBox(() {}, context, "Saved");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Login()));
        } else {
          return uiHelper.customAlertBox(() {}, context, "User SignUp Failed");
        }
        return null;
      });
    } on FirebaseAuthException catch (ex) {
      return uiHelper.customAlertBox(() {}, context, ex.code.toString());
    }
  }

  void submitForm() {
    if (_SignupFormKey.currentState!.validate()) {
      String email = EmailController.value.text;
      String password = PasswordController.value.text;

      Map<String, dynamic> userData = {
        "Name": NameController.value.text,
        "Email": EmailController.value.text,
        "PhoneNo": PhoneNoController.value.text,
        "Password": PasswordController.value.text,
        "City": CityController.value.text,
        "DateOfBirth": "DateOfBirthController",
        "Pic": null,
        "isVerified": false
      };

      signUP(userData);
    }
  }

  checkImagePicked() {
    if (pickedImage == null) {
      return "Please Pick your Image";
    } else {
      return null;
    }
  }

  String? nameValidator(value) {
    if (value.isEmpty) {
      return ("Please Enter Name");
    }
    final RegExp NameRejex = RegExp(r'\d');
    if (value.contains(NameRejex)) {
      return ("Name Not Valid. Must Not Contain Numbers!");
    }
    return null;
  }

  String? phoneNoValidator(value) {
    if (value.isEmpty) {
      return ("Please Enter Phone Number");
    }
    final RegExp PhoneNoRejex = RegExp(r'^\+92\d{10}$');
    if (!value.contains(PhoneNoRejex)) {
      return ("Phone No must be in +92XXXXXXXXXX format");
    }
    return null;
  }

  String? emailValidator(value) {
    if (value.isEmpty) {
      return ("Please Enter Email");
    }
    final RegExp emailRegex =
    RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!value.contains(emailRegex)) {
      return ("Email Not Valid!");
    }
    return null;
  }

  String? passwordValidator(value) {
    if (value.isEmpty) {
      return ("Please Enter Password");
    }
    final RegExp passwordRejex =
    RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$');
    if (!value.contains(passwordRejex)) {
      return ("Password Must Contain at Least One Lower Case, Upper Case, Digit, and be 8 Characters Long");
    }
    return null;
  }

  String? confirmPasswordValidator(value) {
    if (value.isEmpty) {
      return ("Please Enter Password");
    }
    if (PasswordController.value.text != ConfirmPasswordController.value.text) {
      return ("Password and Confirm Passwords Must be Same");
    }
    return null;
  }

  String? cityValidator(value) {
    if (value.isEmpty) {
      return ("Please Enter City");
    }
    final RegExp NameRejex = RegExp(r'\d');
    if (value.contains(NameRejex)) {
      return ("City Not Valid. Must Not Contain Numbers!");
    }
    return null;
  }

  TextEditingController NameController = TextEditingController();
  TextEditingController PhoneNoController = TextEditingController();
  TextEditingController EmailController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  TextEditingController ConfirmPasswordController = TextEditingController();
  TextEditingController CityController = TextEditingController();
  final _SignupFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _SignupFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: showAlertBox,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: pickedImage != null
                        ? FileImage(pickedImage!)
                        : AssetImage('assets/profile_placeholder.png')
                    as ImageProvider,
                    child: pickedImage == null
                        ? Icon(
                      Icons.add_a_photo,
                      size: 50,
                      color: Colors.grey[700],
                    )
                        : null,
                  ),
                ),
                SizedBox(height: 20),
                buildTextField(
                    controller: NameController,
                    label: 'Name',
                    hintText: 'Enter your name',
                    icon: Icons.person,
                    validator: nameValidator),
                SizedBox(height: 16),
                buildTextField(
                    controller: PhoneNoController,
                    label: 'Phone Number',
                    hintText: '+92XXXXXXXXXX',
                    icon: Icons.phone,
                    validator: phoneNoValidator),
                SizedBox(height: 16),
                buildTextField(
                    controller: EmailController,
                    label: 'Email',
                    hintText: 'Enter your email',
                    icon: Icons.email,
                    validator: emailValidator),
                SizedBox(height: 16),
                buildTextField(
                    controller: PasswordController,
                    label: 'Password',
                    hintText: 'Enter your password',
                    icon: Icons.lock,
                    validator: passwordValidator,
                    obscureText: true),
                SizedBox(height: 16),
                buildTextField(
                    controller: ConfirmPasswordController,
                    label: 'Confirm Password',
                    hintText: 'Confirm your password',
                    icon: Icons.lock,
                    validator: confirmPasswordValidator,
                    obscureText: true),
                SizedBox(height: 16),
                buildTextField(
                    controller: CityController,
                    label: 'City',
                    hintText: 'Enter your city',
                    icon: Icons.location_city,
                    validator: cityValidator),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: Text(
                    'Already have an account? Login',
                    style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    required String? Function(String?) validator,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey[100],
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      validator: validator,
    );
  }
}
