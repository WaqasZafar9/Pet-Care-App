
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pet_care/uihelper.dart';

class DataBase {

  static Future<Map<String, dynamic>> readData(String collection, String email) async {
    var db = FirebaseFirestore.instance;
    final docRef = db.collection(collection).doc(email);
    Map<String, dynamic> userData = {};

    try {
      final snapshot = await docRef.get();
      if (snapshot.exists) {
        userData = snapshot.data() as Map<String, dynamic>;
      } else {
        print('Document does not exist');
      }
    } catch (error) {
      print('Error fetching document: $error');
      // Handle the error, e.g., show an error message
    }

    return userData;
  }

  static  readAllData()async{
    var db = FirebaseFirestore.instance;
    print("Data Read");
    await db.collection("UserData").get().then((event) {
      for (var doc in event.docs) {
        print("${doc.id} => ${doc.data()["Email"]}");
      }
    });
  }

  static Future<dynamic> saveUserData(collection,userData) async{

    try {
      var db = FirebaseFirestore.instance;

      await db.collection(collection).doc(userData["Email"]).set(userData,SetOptions(merge: false)).then((value) => print("Written Successfully")).onError((e, _) => print("Error writing document: $e"));

      return true;
    }
    on FirebaseAuthException catch(ex){
      return  ex.code.toString();
    }
  }

  static Future<dynamic> saveMessageData(collection,userData) async{

    try {
      var db = FirebaseFirestore.instance;

      await db.collection(collection).doc().set(userData,SetOptions(merge: false)).then((value) => print("Written Successfully")).onError((e, _) => print("Error writing document: $e"));

      return true;
    }
    on FirebaseAuthException catch(ex){
      return  ex.code.toString();
    }
  }

  static Future<bool> updateUserData(collection,userid,updatedData) async{

    var data={
      "isVerified": false
    };
    bool returnValue=false;

    var db=FirebaseFirestore.instance;
    final userDocument = db.collection(collection).doc(userid);
    userDocument.update(updatedData).then(
            (value) => returnValue=true,
        onError: (e) => returnValue=false);

    print("UserData ${userDocument.snapshots().listen((event) {print(event.data());})}");
    print("Updated Data _+++ $updatedData ++ $userid  Verified ++ $returnValue");

    return returnValue;

  }

  static Future<dynamic>? deleteUserData(collection,userID){

    var db=FirebaseFirestore.instance;

    db.collection(collection).doc(userID).delete().then(
          (doc) => print("Document deleted"),
      onError: (e) => print("Error updating document $e"),
    );

    return null;


  }

  static Future<dynamic>? deleteSpecificField(collection,userID,deletedData){

    var db=FirebaseFirestore.instance;

    final updates = <String, dynamic>{
      deletedData: FieldValue.delete(),
    };

    db.collection(collection).doc(userID).update(updates).then(
          (doc) => print("Document deleted"),
      onError: (e) => print("Error updating document $e"),
    );

    return null;


  }

  static Future<dynamic>? uploadImage(email,collection,pickedImage)async{

    try {
      print("Upload 1");
      UploadTask uploadTask = FirebaseStorage.instance.ref(collection).child(
          email).putFile(pickedImage!);
      print("Upload 2 :- ${uploadTask.toString()}");
      TaskSnapshot taskSnapshot = await uploadTask;
      print("Upload 3");
      String url = await taskSnapshot.ref.getDownloadURL();
      print("Upload 4");
      return url;
    }
    on FirebaseException catch(ex){
      print("Error : - ${ex.toString()} endedddd");
      return null;
    }
  }



}