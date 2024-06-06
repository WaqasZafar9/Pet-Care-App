import 'dart:io';
import 'dart:math';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pet_care/ColorsScheme.dart';
import 'package:pet_care/DataBase.dart';
import 'package:pet_care/HomePage/petScreenDynamicDark.dart';
import 'package:pet_care/uihelper.dart';

class CommunityScreenDark extends StatefulWidget {
  final Map<String,dynamic> userData;

  CommunityScreenDark({Key? key, required this.userData}) : super(key: key);

  @override
  State<CommunityScreenDark> createState() => _CommunityScreenDarkState();
}

class _CommunityScreenDarkState extends State<CommunityScreenDark> {

  bool showSpinner=false;

  // var titleColor = Colors.blue.shade100,
  //     bottomColor =  Colors.blue.shade200,
  //     centerBodyColor = Colors.blue.shade300,
  //     messageColor = Colors.greenAccent.shade100,
  //     messageBorderColor = Colors.grey.shade700,
  //     titleBorderColor = Colors.black,
  //     bottomBorderColor = Colors.black,
  //     centerBodyBorderColor = Colors.black,
  //     inputBorderColor = Colors.purple;
  var titleColor = Colors.teal.shade300,
      bottomColor =  Colors.teal.shade200,
      centerBodyColor = Colors.teal.shade100,
      messageColor = Colors.blueGrey.shade100,
      messageBorderColor = Colors.teal,
      titleBorderColor = Colors.black,
      bottomBorderColor = Colors.black,
      centerBodyBorderColor = Colors.black,
      inputBorderColor = Colors.teal;
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

  // Todo Fix The Naming of File

  String randomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  pickImage(ImageSource imageSource) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageSource);
      if (photo == null) {
        return;
      }
      final tempImage = File(photo.path);

      setState(() {
        showSpinner=true;
      });

      var url = await DataBase.uploadImage(randomString(12),"CommunityMessagesPics", tempImage);

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

      setState(() {
        showSpinner=false;
      });

      if (response == true) {
        setState(() {
          showSpinner=false;
        });
        return uiHelper.customAlertBox(() {}, context, "Send");
      } else {
        setState(() {
          showSpinner=false;
        });
        return uiHelper.customAlertBox(() {}, context, response.toString());
      }
    } catch (ex) {
      setState(() {
        showSpinner=false;
      });
      print("Error ${ex.toString()}");
    }
  }

  sendImage() {
    showAlertBox();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        blur: 1,
        child: Scaffold(
          body: Stack(
            children:[
              Container(
                decoration: BoxDecoration(
                  gradient: BackgroundOverlayColor,
                ),
                child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      // height: 50,
                      decoration: BoxDecoration(
                        // color: titleColor,
                        color: buttonColor,
                        // borderRadius: BorderRadius.only(
                        //   topLeft: Radius.circular(10),
                        //   topRight: Radius.circular(10),
                        // ),
                        // border: Border.all(color: titleBorderColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: ()=>{
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => petScreenDynamicDark(userData: widget.userData),))
                    },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0,right: 16.0),
                              child: Container(
                                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.015),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.05),
                                  color: Colors.transparent,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  CupertinoIcons.back,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "Welcome to Pettify Community",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.grey.shade400),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Container(
                      // height: 580,
                      // width: double.maxFinite,
                      color: Colors.transparent,
                      child: Padding(
                        padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
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

                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 8),
                                      child: BlurryContainer(
                                        color: buttonColor,
                                        borderRadius:email!=widget.userData["Email"] ? BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        ) : BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          topLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ) ,
                                        child: Container(

                                          margin: EdgeInsets.only(bottom: 8),
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
                                                : SizedBox(
                                              height: 200,
                                              width: 100,
                                              child: Image(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      snapshot.data?.docs[index]
                                                      ["message"])),
                                            ),
                                            // subtitle: Text(snapshot.data?.docs[index]["message"]),
                                          ),
                                          decoration: BoxDecoration(
                                            // color: messageColor,
                                            color: Colors.transparent,
                                            // gradient: cardColor,
                                            // border: Border.all(
                                            //     color: messageBorderColor),
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              topLeft: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                            ),
                                          ),
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
                    ),
                  ),
                  Expanded(
                    flex: 1,
                      child: Container(color: Colors.transparent,))
                  // Positioned(
                  //   bottom: 7,
                  //   left: MediaQuery.of(context).size.width * 0.02,
                  //   right: MediaQuery.of(context).size.width * 0.02,
                  //   child: Container(
                  //     // height: 75,
                  //     width: double.maxFinite,
                  //     decoration: BoxDecoration(
                  //       color: bottomColor,
                  //       borderRadius: BorderRadius.only(
                  //         bottomLeft: Radius.circular(10),
                  //         bottomRight: Radius.circular(10),
                  //       ),
                  //       border: Border.all(color: bottomBorderColor),
                  //     ),
                  //     child: Padding(
                  //       padding: const EdgeInsets.only(bottom: 12.0),
                  //       child: ListTile(
                  //         title: TextField(
                  //           maxLines: null,
                  //           controller: messageController,
                  //           decoration: InputDecoration(
                  //               border: OutlineInputBorder(
                  //                 borderRadius: BorderRadius.only(
                  //                   topRight: Radius.circular(10),
                  //                   bottomLeft: Radius.circular(10),
                  //                 ),
                  //               ),
                  //               enabledBorder: OutlineInputBorder(
                  //                 borderRadius: BorderRadius.only(
                  //                   topRight: Radius.circular(10),
                  //                   bottomLeft: Radius.circular(10),
                  //                 ),
                  //                 borderSide: BorderSide(color: inputBorderColor),
                  //               ),
                  //               suffixIcon: IconButton(
                  //                   onPressed: () {
                  //                     sendImage();
                  //                   },
                  //                   icon: Icon(Icons.add))),
                  //         ),
                  //         trailing: IconButton(
                  //           onPressed: () {
                  //             sendMessage();
                  //             // sendImage();
                  //             setState(() {
                  //               messageController.text = "";
                  //             });
                  //           },
                  //           icon: Icon(
                  //             Icons.send,
                  //             size: 30,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),

                ],
                            ),
              ),
              Positioned(
                bottom: 7,
                left: MediaQuery.of(context).size.width * 0.02,
                right: MediaQuery.of(context).size.width * 0.02,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff2A2438),
                        blurRadius: 18,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: TextField(
                      maxLines: null,
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Color(0xff79777D),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        suffixIcon: IconButton(
                          onPressed: () {
                            sendImage();
                          },
                          icon: Icon(Icons.add),
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 16,
                      ),
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
                        color: Color.fromRGBO(92, 84, 112, 1),
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),

            ]
          ),
        ),
      ),
    );
  }
}
