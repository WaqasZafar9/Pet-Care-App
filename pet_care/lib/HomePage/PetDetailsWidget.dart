import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/ColorsScheme.dart';
import 'package:pet_care/HomePage/addTaskContainer.dart';
import 'package:pet_care/HomePage/petReminderDetailsWidget.dart';
import 'package:pet_care/uihelper.dart';

class PetDetailsWidget extends StatefulWidget {
  Map<String, dynamic>? petData;

  PetDetailsWidget({super.key, required this.petData});

  @override
  State<PetDetailsWidget> createState() => _PetDetailsWidgetState();
}

class _PetDetailsWidgetState extends State<PetDetailsWidget> {
  bool isAddTask = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
          if (!isAddTask)
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.teal.shade100,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
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
                          color: Colors.teal.shade900,
                        ),
                      ),
                      Text(
                        widget.petData!["Breed"],
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.teal.shade700,
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
              child: isAddTask
                  ? SingleChildScrollView(
                child: addTaskContainer(petId: widget.petData!["Email"]),
              )
                  : ListView(
                children: [
                  petReminderDetails(petID: widget.petData!["Email"]),
                ],
              ),
            ),
          ),

          // Button Section
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isAddTask = !isAddTask;
                  uiHelper.customAlertBox(() {}, context, isAddTask.toString());
                });
              },
              child: Text(
                isAddTask ? "Task Details" : "Add Task",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.teal.shade700),
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 16.0)),
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
