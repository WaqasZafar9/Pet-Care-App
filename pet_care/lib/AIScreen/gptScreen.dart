import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_gemini/google_gemini.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_care/DataBase.dart';
import 'package:pet_care/AIScreen/TypingIndicator.dart';
import 'package:pet_care/apiKey.dart';
import 'package:shared_preferences/shared_preferences.dart';

class gptScreen extends StatefulWidget {
  const gptScreen({super.key});

  @override
  State<gptScreen> createState() => _GptScreenState();
}

class _GptScreenState extends State<gptScreen> {
  List<Map<dynamic, dynamic>> messageList = [
    {
      "IsUser": false,
      "message": "Hi. I am your AI Doctor.\nHow can I assist you?",
    }
  ];

  TextEditingController messageController = TextEditingController();
  bool isLoading = false, isImageSelected = false;
  late File selectedImage;

  @override
  void initState() {
    super.initState();
    getSaveMessages();
  }

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
      if (photo == null) {
        return;
      }
      final tempImage = File(photo.path);
      setState(() {
        selectedImage = tempImage;
        isImageSelected = true;
        messageList.add({
          "IsUser": true,
          "message": "",
          "image": selectedImage.path,
        });
      });
    } catch (ex) {
      setState(() {
        selectedImage = File("");
        isImageSelected = false;
      });
      print("Error ${ex.toString()}");
    }
  }

  geminiModelProVision(message) async {
    String apiResponse = message;

    final gemini = GoogleGemini(
      apiKey: GEMINIAPI,
    );

    await gemini
        .generateFromTextAndImages(query: message, image: selectedImage)
        .then((value) {
      apiResponse = value.text;
    }).catchError((e) => print(e));

    setState(() {
      isImageSelected = false;
      selectedImage = File("");
    });
    return apiResponse;
  }

  geminiModelPro(message) async {
    final model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: GEMINIAPI,
    );
    final content = [Content.text(message)];
    final response = await model.generateContent(content);
    return response.text;
  }

  getResponse(String text) async {
    setState(() {
      isLoading = true;
      messageList.add({"IsUser": false, "message": "Loading..."});
    });

    String response = "";
    if (isImageSelected) {
      response = await geminiModelProVision(text);
    } else {
      response = await geminiModelPro(text);
    }

    setState(() {
      isLoading = false;
      messageList.removeLast(); // Remove the loading message
      messageList.add({"IsUser": false, "message": response});
      saveMessages(messageList);
    });
  }

  getSaveMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('messageList')) {
      String jsonString = prefs.getString('messageList') ?? '[]';
      List<dynamic> jsonList = json.decode(jsonString);
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (message['message'] == "Loading...")
                                // CircularProgressIndicator(
                                //   valueColor: AlwaysStoppedAnimation<Color>(
                                //       Colors.blueGrey),
                                // )
                                TypingIndicator()
                              else
                                Text(
                                  message['message'],
                                  style: TextStyle(
                                    color: message['IsUser']
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              if (message.containsKey('image'))
                                SizedBox(
                                  height: 200,
                                  width: 200,
                                  child: Image.file(
                                    File(message['image']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                            ],
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
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    suffixIcon: IconButton(
                      onPressed: () {
                        showAlertBox();
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
