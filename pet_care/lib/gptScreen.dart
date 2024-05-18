
import 'package:chat_gpt_flutter/chat_gpt_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pet_care/apiKey.dart';

class gptScreen extends StatefulWidget {
  const gptScreen({super.key});

  @override
  State<gptScreen> createState() => _gptScreenState();
}

class _gptScreenState extends State<gptScreen> {

  TextEditingController messageController=TextEditingController();

  String response="My Response";

  getResponse(String text) async{

    String apiResponse=text;




    setState(() {
      response=apiResponse;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        Container(
          height: double.maxFinite,
          width: double.maxFinite,
          color: Colors.blueGrey.shade400,
          child: Padding(
            padding: EdgeInsets.only(bottom: (MediaQuery.of(context).size.height - (MediaQuery.of(context).size.height- 87 ) ) ),
            child: Container(
              color: Colors.blue,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.only( topLeft: Radius.circular(7),bottomLeft: Radius.circular(7),topRight: Radius.circular(7))
                        ),
                        child: Text(response)),
                  ),
                ],
              )
            ),
          ),
        ),

        Positioned(
          bottom: 7,
          left: MediaQuery.of(context).size.width * 0.02,
          right: MediaQuery.of(context).size.width * 0.02,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(6),
                bottomRight: Radius.circular(6)
              )

            ),
            child: ListTile(
              title: TextField(
                maxLines: null,
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
                      borderSide: BorderSide(color: Colors.black54),
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {
                        },
                        icon: Icon(Icons.add))),
              ),
              trailing: IconButton(
                onPressed: () {

                  getResponse(messageController.text);
                  messageController.text="";

                },
                icon: Icon(
                  Icons.send,
                  size: 30,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
