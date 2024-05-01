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
          color: Color.fromRGBO(10, 101, 10, 0.2),
          child: Form(
            key: _SignupFormKey,
            child: Column(
              children: [
                Container(
                    // color: Colors.grey,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Opacity(
                              opacity: 0.6,
                              child: InkWell(
                                  onTap: () => showAlertBox(),
                                  child: pickedImage != null
                                      ? CircleAvatar(
                                          radius: 40,
                                          backgroundImage:
                                              FileImage(pickedImage!),
                                        )
                                      : CircleAvatar(
                                          radius: 41,
                                          child: Stack(children: [
                                            Positioned(
                                              top: 15,
                                              left: 20,
                                              child: Icon(
                                                Icons.person,
                                                size: 40,
                                              ),
                                            ),
                                            Positioned(
                                              top: 53,
                                              left: 30,
                                              child: Icon(
                                                Icons.add,
                                                size: 20,
                                              ),
                                            ),
                                            Positioned(
                                              top: 52,
                                              child: Opacity(
                                                opacity: 0.3,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.blueGrey,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              bottomLeft: Radius
                                                                  .circular(40),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          40))),
                                                  width: 80,
                                                  height: 30,
                                                ),
                                              ),
                                            )
                                          ]),
                                        ))),
                        ),
                        Text(
                          "SignUp",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 48,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: NameController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        label: Text("Name"),
                        prefixIcon: Icon(Icons.drive_file_rename_outline),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25))),
                    validator: (value) => nameValidator(value),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: PhoneNoController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        label: Text("PhoneNo"),
                        prefixIcon: Icon(Icons.phone_rounded),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25))),
                    validator: (value) => phoneNoValidator(value),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: EmailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        label: Text("Email"),
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25))),
                    validator: (value) => emailValidator(value),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: PasswordController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        label: Text("Password"),
                        prefixIcon: Icon(Icons.password_rounded),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25))),
                    validator: (value) => passwordValidator(value),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: ConfirmPasswordController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        label: Text("Confirm Password"),
                        prefixIcon: Icon(Icons.password_rounded),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25))),
                    validator: (value) => confirmPasswordValidator(
                        value, PasswordController.text),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: CityController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        label: Text("City"),
                        prefixIcon: Icon(Icons.location_city_outlined),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25))),
                    validator: (value) => cityValidator(value),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    child: TextFormField(
                      enabled: false,
                      decoration: InputDecoration(
                          label: Text("Date of Birth : $DateOfBirthController"),
                          prefixIcon: Icon(Icons.date_range_outlined),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25))),
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
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      submitForm();
                    },
                    child: Text("SignUp"),
                    style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(180, 50)),
                        elevation: MaterialStateProperty.all(5)),
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
                SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
