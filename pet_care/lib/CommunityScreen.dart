import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:pet_care/DataBase.dart';
import 'package:pet_care/uihelper.dart';

class communityScreen extends StatefulWidget {
  String email = "";
  communityScreen({super.key, required this.email});

  @override
  State<communityScreen> createState() => _communityScreenState();
}

class _communityScreenState extends State<communityScreen> {

  // Todo change colors accordingly
  var titleColor = Colors.pinkAccent.shade700,
      bottomColor = Colors.grey.shade500,
      centerBodyColor = Colors.yellow,
      messageColor = Colors.grey,
      messageBorderColor = Colors.grey.shade700;
  TextEditingController messageController = TextEditingController();

  sendMessage() {
    Map<String, dynamic> messageData = {
      "Email": widget.email,
      "message": messageController.value.text.toString(),
      // "Time":"${DateTime.now().hour}:${DateTime.now().minute}"
      "Time": DateTime.now()
    };
    uiHelper.customAlertBox(() {}, context, messageData.toString());
    var response = DataBase.saveMessageData("CommunityMessages", messageData);
    if (response == true) {
      uiHelper.customAlertBox(() {}, context, "Send");
    } else {
      uiHelper.customAlertBox(() {}, context, response.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return
    Scaffold(
      body: Stack(children: [
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(children: [
          Padding(
            ///Send Chat wala
            padding: const EdgeInsets.only(top: 630),
            child: Container(
              height: double.maxFinite,
              width: double.maxFinite,
              decoration: BoxDecoration(
                  color: bottomColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: ListTile(
                  title: TextField(
                    controller: messageController,
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        sendMessage();
                      },
                      icon: Icon(
                        Icons.send,
                        size: 30,
                      )),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Container(
              ///Messages wala
              height: 580,
              width: double.maxFinite,
              color: centerBodyColor,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      ////Messgae likha hus show krna wala
                      margin: EdgeInsets.only(top: 10),
                      width: RenderErrorBox.minimumWidth,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "First Message First Message First Message First Message First Message First Message  "),
                      ),
                      decoration: BoxDecoration(
                          color: messageColor,
                          border: Border.all(color: messageBorderColor),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10))),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            //title wala
            height: 50,
            decoration: BoxDecoration(
                color: titleColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            child: Center(
                child: Text(
              "Welcome to Community",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
          ),
        ]),
      )
    ])
    );
  }
}
