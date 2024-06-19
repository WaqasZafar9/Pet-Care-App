import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/ColorsScheme.dart';
import 'package:pet_care/HomePage/addTaskContainer.dart';
import 'package:pet_care/HomePage/addTaskContainerDark.dart';
import 'package:pet_care/HomePage/petRemainderDetailsWidgetDark.dart';
import 'package:pet_care/HomePage/petReminderDetailsWidget.dart';
import 'package:pet_care/uihelper.dart';

class PetDetailsWidgetDark extends StatefulWidget {
  Map<String, dynamic>? petData;

  PetDetailsWidgetDark({super.key, required this.petData});

  @override
  State<PetDetailsWidgetDark> createState() => _PetDetailsWidgetDarkState();
}

class _PetDetailsWidgetDarkState extends State<PetDetailsWidgetDark> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Pet Info Section
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: BackgroundOverlayColorReverse,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                widget.petData == null
                    ? CircleAvatar(
                        radius: 50,
                        child: Image.asset("assets\\images\\petPic.png"),
                        backgroundColor: Colors.white70,
                      )
                    : CircleAvatar(
                        backgroundImage: NetworkImage(widget.petData!["Photo"]),
                        radius: 50,
                      ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.petData!["Name"],
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: TextColor,
                      ),
                    ),
                    Text(
                      widget.petData!["Breed"],
                      style: TextStyle(
                        fontSize: 18,
                        color: TextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Pet Reminders / Add Task Section
          Expanded(
            flex: 9,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  petReminderDetailsDark(petID: widget.petData!["Email"]),
                ],
              ),
            ),
          ),

          // Button Section
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          addTaskContainerDark(petId: widget.petData!["Email"]),
                    ));
              },
              child: Text(
                "Add Task",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(buttonColor),
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical: 16.0)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
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
