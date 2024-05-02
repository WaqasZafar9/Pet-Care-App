import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_care/DataBase.dart';
import 'package:pet_care/uihelper.dart';

class CommunityScreen extends StatefulWidget {
  final Map<String,dynamic> userData;

  CommunityScreen({Key? key, required this.userData}) : super(key: key);

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  var titleColor = Colors.blue.shade100,
      bottomColor =  Colors.blue.shade200,
      centerBodyColor = Colors.blue.shade300,
      messageColor = Colors.greenAccent.shade100,
      messageBorderColor = Colors.grey.shade700,
      titleBorderColor = Colors.black,
      bottomBorderColor = Colors.black,
      centerBodyBorderColor = Colors.black,
      inputBorderColor = Colors.purple;
  TextEditingController messageController = TextEditingController();

  // Todo try to remove url exrtra space

  void sendMessage() {
    Map<String, dynamic> messageData = {
      "Email": widget.userData["Email"],
      "message": messageController.value.text.toString(),
      "isImage": false,
      "Time": DateTime.now().toIso8601String(),
      "url": widget.userData["Pic"] // Convert to ISO 8601 format
    };

    var response = DataBase.saveMessageData("CommunityMessages", messageData);
    if (response == true) {
      uiHelper.customAlertBox(() {}, context, "Send");
    } else {
      uiHelper.customAlertBox(() {}, context, response.toString());
    }
  }

  getURL(email) async {
    Map<String, dynamic> user = await DataBase.readData("UserData", email);
    return user["Pic"];
  }

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
      var url = await DataBase.sendImage("CommunityMessagesPics", tempImage);

      // Todo try to remove url exrtra space

      Map<String, dynamic> messageData = {
        "Email": widget.userData["Email"],
        "message": url,
        "isImage": true,
        "Time": DateTime.now().toIso8601String(), // Convert to ISO 8601 format
        "url": widget.userData["Pic"]
      };

      var response =
          await DataBase.saveMessageData("CommunityMessages", messageData);

      if (response == true) {
        return uiHelper.customAlertBox(() {}, context, "Send");
      } else {
        return uiHelper.customAlertBox(() {}, context, response.toString());
      }
    } catch (ex) {
      print("Error ${ex.toString()}");
    }
  }

  sendImage() {
    showAlertBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 630),
                child: Container(
                  height: 65,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: bottomColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    border: Border.all(color: bottomBorderColor),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: ListTile(
                      title: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                              borderSide: BorderSide(color: inputBorderColor),
                            ),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  sendImage();
                                },
                                icon: Icon(Icons.add))),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          sendMessage();
                          // sendImage();
                          setState(() {
                            messageController.text = "";
                          });
                        },
                        icon: Icon(
                          Icons.send,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Container(
                  height: 580,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: centerBodyColor,
                    border: Border.all(color: centerBodyBorderColor),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Column(
                      children: [
                        Expanded(
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("CommunityMessages")
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.active) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                    // Todo Fix Url Option
                                    itemBuilder: (context, index) {
                                      var time =
                                          snapshot.data?.docs[index]["Time"];
                                      // String url=getURL(snapshot.data?.docs[index]["Email"]);
                                      String url=snapshot.data?.docs[index]["url"];
                                      // String url = "https://firebasestorage.googleapis.com/v0/b/pettify-96749.appspot.com/o/ProfilePics%2Ffuzailraza161%40gmail.com?alt=media&token=cfb1f919-11da-489e-bcc2-274a4525b28d";
                                      String email =
                                          snapshot.data?.docs[index]["Email"];

                                      return Container(
                                        margin: EdgeInsets.only(bottom: 8),
                                        padding: EdgeInsets.only(bottom: 8),
                                        // width: RenderErrorBox.minimumWidth,
                                        child: ListTile(
                                          leading: url != null
                                              ? CircleAvatar(
                                                  radius: 20,
                                                  backgroundImage:
                                                      NetworkImage(url),
                                                  backgroundColor:
                                                      Colors.white70,
                                                )
                                              : CircleAvatar(
                                                  radius: 30,
                                                  child: Icon(Icons.person),
                                                  backgroundColor:
                                                      Colors.white70,
                                                ),
                                          title: snapshot.data?.docs[index]
                                                      ["isImage"] ==
                                                  false
                                              ? Text(snapshot.data?.docs[index]
                                                  ["message"],
                                          )
                                              : Image(
                                                  image: NetworkImage(
                                                      snapshot.data?.docs[index]
                                                          ["message"])),
                                          // subtitle: Text(snapshot.data?.docs[index]["message"]),
                                          trailing: Icon(Icons.add),
                                        ),
                                        decoration: BoxDecoration(
                                          color: messageColor,
                                          border: Border.all(
                                              color: messageBorderColor),
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: snapshot.data?.docs.length,
                                  );
                                } else {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: titleColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  border: Border.all(color: titleBorderColor),
                ),
                child: Center(
                  child: Text(
                    "Welcome to Community",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
