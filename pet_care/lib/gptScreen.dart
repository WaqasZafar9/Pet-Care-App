import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_gemini/google_gemini.dart';
import 'package:pet_care/apiKey.dart';
import 'package:pet_care/uihelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class gptScreen extends StatefulWidget {
  const gptScreen({super.key});

  @override
  State<gptScreen> createState() => _GptScreenState();
}

class _GptScreenState extends State<gptScreen> {



  List<Map<dynamic, dynamic>> messageList = [
    {"IsUser": false, "message": "Hi.I am your AI Doctor.\nHow can i Assist you ??"}
  ];

  TextEditingController messageController = TextEditingController();
  bool isLoading = false;


  geminiModel(message)async{

    String apiResponse = message;

    final gemini = GoogleGemini(
      apiKey: GEMINIAPI,
    );

    await gemini.generateFromText(message).then((value) {
      apiResponse = value.text;
    }).catchError((e) => print(e));

    return apiResponse;
  }

  gptModel(){



  }


  getResponse(String text) async {

    setState(() {
      isLoading = true;
      messageList.add({"IsUser": false, "message": "Loading..."});
    });

    String response= await geminiModel(text);

    setState(() {
      isLoading = false;
      messageList.removeLast();  // Remove the loading message
      messageList.add({"IsUser": false, "message": response});
      saveMessages(messageList);
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSaveMessages();
  }

  getSaveMessages() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('messageList')) {
    }else {
      // messageList.removeLast();
      String jsonString = prefs.getString('messageList') ?? '[]';
      List<dynamic> jsonList = json.decode(jsonString);
      print("Json List ${jsonList.toString()}");
      setState(() {
        messageList =
            jsonList.map((item) => item as Map<dynamic, dynamic>).toList();
      });

    }
  }

  saveMessages(List<Map<dynamic, dynamic>> messages) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = json.encode(messages);
    await prefs.setString('messageList', jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey.shade100,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              height: double.maxFinite,
              width: double.maxFinite,
              color: Colors.blueGrey.shade100,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.08,
                ),
                child: ListView.builder(
                  itemCount: messageList.length,
                  itemBuilder: (context, index) {
                    var message = messageList[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: message['IsUser']
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: message['IsUser']
                                ? Colors.teal.shade400
                                : Colors.grey.shade300,
                            borderRadius: message['IsUser']
                                ? BorderRadius.only(
                                topRight: Radius.circular(15),
                                topLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15))
                                : BorderRadius.only(
                                topRight: Radius.circular(15),
                                topLeft: Radius.circular(15),
                                bottomLeft: Radius.circular(15)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child:
                          // Todo Make animation more beautiful
                          message['message'] == "Loading..."
                              ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.blueGrey),
                          )
                              :
                          Text(
                            message['message'],
                            style: TextStyle(
                              color: message['IsUser']
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
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
                    color: Colors.grey.shade400,
                    blurRadius: 12,
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
                    fillColor: Colors.white,
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                trailing: IconButton(
                  onPressed: () {
                    if (messageController.text.isNotEmpty) {
                      setState(() {
                        messageList.add({
                          "IsUser": true,
                          "message": messageController.text,
                        });
                        getResponse(messageController.text);
                        messageController.clear();
                      });
                    }
                  },
                  icon: Icon(
                    Icons.send,
                    color: Colors.teal,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
