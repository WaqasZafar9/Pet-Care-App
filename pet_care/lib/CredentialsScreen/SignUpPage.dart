import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_care/DataBase.dart';
import 'package:pet_care/CredentialsScreen/LoginPage.dart';
import 'package:pet_care/uihelper.dart';

class SignUpForm extends StatefulWidget {
  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  double borderRadius = 15;
  File? pickedImage;

  showAlertBox() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Pic Image From"),
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
              )
            ],
          ),
        );
      },
    );
  }

  pickImage(ImageSource imageSource) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageSource);
      if (photo == null) {
        return;
      }
      final tempImage = File(photo.path);
      setState(() {
        pickedImage = tempImage;
      });
    } catch (ex) {
      print("Error ${ex.toString()}");
    }
  }

  signUP(userData) async {
    UserCredential? userCredential;

    // Todo check if user saved in data base or not if not then authentication must be roll back

    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: userData["Email"], password: userData["Password"])
          .then((value) async {
        uiHelper.customAlertBox(() {}, context, "Uploading");
        var url = await DataBase.uploadImage(
            userData["Email"], "ProfilePics", pickedImage);
        uiHelper.customAlertBox(() {}, context, "Uploading...");
        if (url == null) {
          return uiHelper.customAlertBox(
              () {}, context, "Pic Upload Unsuccessfully");
        }
        uiHelper.customAlertBox(() {}, context, "Uploaded");
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
      // if(ex.toString()!="email-already-in-use"){
      //   return uiHelper.customAlertBox(() {}, context, "Email already Exists");
      // }
      // print("Printed Error ${ex.toString()}");
      return uiHelper.customAlertBox(() {}, context, ex.code.toString());
    }
  }

  uploadImage(email, collection, pickedImage) async {
    try {
      print("Upload 1");
      UploadTask uploadTask = FirebaseStorage.instance
          .ref(collection)
          .child(email)
          .putFile(pickedImage!);
      print("Upload 2 :- ${uploadTask.toString()}");
      TaskSnapshot taskSnapshot = await uploadTask;
      print("Upload 3");
      String url = await taskSnapshot.ref.getDownloadURL();
      print("Upload 4");
      return url;
    } on FirebaseException catch (ex) {
      print("Error ${ex.toString()}");
      return null;
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
        "DateOfBirth": DateOfBirthController,
        "Pic": null,
        "isVerified": false
      };

      signUP(userData);
      // print("Save Data Call");
      // DataBase.saveUserData("UserData",userData);
      // print("Save Data Back");
      // var updateData = {"City": "Karachi"};
      // DataBase.updateUserData(
      //     "UserData", "fuzailraza161@gmail.com", updateData);
      // uiHelper.customAlertBox(() {}, context, "Form Valid");
      // } else {
      //   uiHelper.customAlertBox(() {}, context, "Form Not Valid");
    }
    uiHelper.customAlertBox(() {}, context, "Remaining Call");
    String email = EmailController.value.text;
    String password = PasswordController.value.text;
    final RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    final RegExp passwordRejex =
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$');
    final RegExp NameRejex = RegExp(r'\d');
    final RegExp PhoneNoRejex = RegExp(r'^\+92\d{10}$');
    String Name = NameController.value.text;
    String PhoneNo = PhoneNoController.value.text;
    String Email = EmailController.value.text;
    String Password = PasswordController.value.text;
    String ConfirmPassword = ConfirmPasswordController.value.text;
    String City = CityController.value.text;

    if (Name.isEmpty ||
        PhoneNo.isEmpty ||
        Email.isEmpty ||
        Password.isEmpty ||
        ConfirmPassword.isEmpty ||
        City.isEmpty) {
      uiHelper.customAlertBox(() {}, context, "PLease Fill All Fields!");
    } else if (Name.contains(NameRejex)) {
      uiHelper.customAlertBox(
          () {}, context, "Name Not Valid.Must Not Contains Numbers!");
    } else if (!PhoneNo.contains(PhoneNoRejex)) {
      uiHelper.customAlertBox(
          () {}, context, "Phone No must be in +92XXXXXXXXXX Format");
    } else if (!email.contains(emailRegex)) {
      uiHelper.customAlertBox(() {}, context, "Email Not Valid!");
    } else if (password != ConfirmPassword) {
      uiHelper.customAlertBox(
          () {}, context, "Password and Confirm Passwords Must be Same");
    } else if (!Password.contains(passwordRejex)) {
      uiHelper.customAlertBox(() {}, context,
          "Password Must Contains at Least One Lower Case,Upper Case,Digit,8 Letters Length");
    } else if (City.contains(NameRejex)) {
      uiHelper.customAlertBox(
          () {}, context, "City Not Valid.Must Not Contains Numbers!");
    } else if (pickedImage == null) {
      uiHelper.customAlertBox(() {}, context, "Please Pick Your Image");
    } else {
      uiHelper.customAlertBox(() {}, context, "SignUp SuccessFully");
    }
  }

  checkImagePicked() {
    if (pickedImage == null) {
      return "PLease Pick your Image";
    } else {
      return null;
    }
  }

  String? nameValidator(value) {
    if (value.isEmpty) {
      return ("PLease Enter Name");
    }
    final RegExp NameRejex = RegExp(r'\d');
    if (value.contains(NameRejex)) {
      return ("Name Not Valid.Must Not Contains Numbers!");
    }
    return null;
  }

  String? phoneNoValidator(value) {
    if (value.isEmpty) {
      return ("PLease Enter PhoneNo");
    }
    final RegExp PhoneNoRejex = RegExp(r'^\+92\d{10}$');
    if (!value.contains(PhoneNoRejex)) {
      return ("Phone No must be in +92XXXXXXXXXX Format");
    }
    return null;
  }

  String? emailValidator(value) {
    if (value.isEmpty) {
      return ("PLease Enter Email");
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
      return ("PLease Enter Password");
    }
    final RegExp passwordRejex =
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$');
    if (!value.contains(passwordRejex)) {
      return ("Password Must Contains at Least One Lower Case,Upper Case,Digit,8 Letters Length");
    }
    return null;
  }

  String? confirmPasswordValidator(value, ConfirmPassword) {
    if (value != ConfirmPassword) {
      return ("Password and Confirm Passwords Must be Same");
    }
    return null;
  }

  String? cityValidator(value) {
    if (value.isEmpty) {
      return ("PLease Enter City");
    }
    final RegExp NameRejex = RegExp(r'\d');
    if (value.contains(NameRejex)) {
      return ("City Not Valid.Must Not Contains Numbers!");
    }
    return null;
  }

  String? dateOfBirthValidator(value) {
    if (DateOfBirthController == "") {
      return ("PLease Enter Date of  birth");
    }

    return checkImagePicked();
  }

  var NameController = TextEditingController();
  var PhoneNoController = TextEditingController();
  var EmailController = TextEditingController();
  var PasswordController = TextEditingController();
  var ConfirmPasswordController = TextEditingController();
  var CityController = TextEditingController();
  String DateOfBirthController = "";
  var PetController = TextEditingController();
  final GlobalKey<FormState> _SignupFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime(2024);

    return Scaffold(
      appBar: AppBar(
        title: Text("Pet Care"),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Color.fromRGBO(10, 101, 10, 0.2),
          child: Form(
            key: _SignupFormKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      // color: Colors.grey,
                      width: double.infinity,
                      child: GestureDetector(
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
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10,bottom: 8),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: NameController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        label: Text("Name"),
                        prefixIcon: Icon(Icons.person),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(borderRadius))),
                    validator: (value) => nameValidator(value),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10,bottom: 8),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: PhoneNoController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        label: Text("PhoneNo"),
                        prefixIcon: Icon(Icons.phone_rounded),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(borderRadius))),
                    validator: (value) => phoneNoValidator(value),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10,bottom: 8),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: EmailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        label: Text("Email"),
                        prefixIcon: Icon(Icons.email),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(borderRadius))),
                    validator: (value) => emailValidator(value),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10,bottom: 8),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: PasswordController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        label: Text("Password"),
                        prefixIcon: Icon(Icons.password_rounded),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(borderRadius))),
                    validator: (value) => passwordValidator(value),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10,bottom: 8),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: ConfirmPasswordController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        label: Text("Confirm Password"),
                        prefixIcon: Icon(Icons.password_rounded),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(borderRadius))),
                    validator: (value) => confirmPasswordValidator(
                        value, PasswordController.text),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10,bottom: 8),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: CityController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        label: Text("City"),
                        prefixIcon: Icon(Icons.location_city_outlined),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(borderRadius))),
                    validator: (value) => cityValidator(value),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10,bottom: 8),
                  child: InkWell(
                    child: TextFormField(
                      enabled: false,
                      decoration: InputDecoration(
                          label: Text("Date of Birth : $DateOfBirthController"),
                          prefixIcon: Icon(Icons.date_range_outlined),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(borderRadius))),
                      validator: (value) => dateOfBirthValidator(value),
                    ),
                    onTap: () async {
                      DateTime? datePicked = await showDatePicker(
                          context: context,
                          // initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now());
                      if (datePicked != null) {
                        setState(() {
                          date = datePicked;
                          DateOfBirthController =
                              "${date.day}/${date.month}/${date.year}";
                          print("Time : $datePicked");
                        });
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10,bottom: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      submitForm();
                    },
                    child: Text("SignUp", style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Already Have an Account??",
                      style: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                        child: Text(
                          "LogIn",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
