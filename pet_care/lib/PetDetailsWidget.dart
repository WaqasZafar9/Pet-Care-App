import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pet_care/ColorsScheme.dart';
import 'package:pet_care/addTaskContainer.dart';
import 'package:pet_care/petReminderDetailsWidget.dart';
import 'package:pet_care/showTaskDetailsContainer.dart';
import 'package:pet_care/uihelper.dart';

class PetDetailsWidget extends StatefulWidget {
  const PetDetailsWidget({super.key});

  @override
  State<PetDetailsWidget> createState() => _PetDetailsWidgetState();
}

class _PetDetailsWidgetState extends State<PetDetailsWidget> {
  bool isAddTask = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.transparent, borderRadius: BorderRadius.circular(7)),
        child: Stack(children: [
          Column(
            children: [
              isAddTask != true
                  ? Expanded(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                            color: stackedColor,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(7),
                                topLeft: Radius.circular(7))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.values.first,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                backgroundImage:
                                    AssetImage("assets/images/petPic.png"),
                                radius: 78,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Jerry",
                                    style: TextStyle(
                                        fontSize: headingFont-3,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 3),
                                    child: Text(
                                      "My Lovely Pet ! ",
                                      style: TextStyle(
                                          fontSize: subHeadingFont-3,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : SizedBox(),
              isAddTask != true
                  ? Expanded(
                      flex: 9,
                      child: InkWell(
                          onTap: () {},

                          /// TODO fix scrolling issue

                          child: ListView(children: [petReminderDetails()])
                      ),
                    )
                  : Expanded(
                      child: InkWell(
                          onTap: () {},
                          child:
                              SingleChildScrollView(child: addTaskContainer())),
                    ),
              isAddTask != true
                  ? Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isAddTask = !isAddTask;
                            uiHelper.customAlertBox(
                                () {}, context, isAddTask.toString());
                          });
                        },
                        child: isAddTask != true
                            ? Text(
                                "Add Task",
                                style: TextStyle(
                                    fontSize: subHeadingFont,
                                    fontWeight: FontWeight.w400),
                              )
                            : Text(
                                "Task Details",
                                style: TextStyle(
                                    fontSize: subHeadingFont,
                                    fontWeight: FontWeight.w400),
                              ),
                        style: ButtonStyle(
                          // minimumSize: MaterialStateProperty.all(Size(1000, 10),),
                          minimumSize: MaterialStateProperty.all(Size.infinite),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(7.0),
                            bottomRight: Radius.circular(7.0),
                          ))),
                        ),
                      ))
                  : SizedBox()
              // Visibility(
              //     visible: isAddTask,
              //     child: addTaskContainer()
              // )
            ],
          ),
        ]));
  }
}
