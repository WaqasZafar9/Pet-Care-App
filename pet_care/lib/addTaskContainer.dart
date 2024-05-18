

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/DataBase.dart';
import 'package:pet_care/uihelper.dart';

class addTaskContainer extends StatefulWidget {
  String petId="";
  addTaskContainer({super.key,required this.petId});

  @override
  State<addTaskContainer> createState() => _addTaskContainerState();
}

class _addTaskContainerState extends State<addTaskContainer> {

  DateTime date = DateTime.now();
  TimeOfDay timeOfDay = TimeOfDay(hour: 12, minute: 1);

  GlobalKey<FormState> taskFormKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late String timeController;
  late String dateController;
  bool isSilent=false;
  @override
  void initState() {
    // TODO: implement initState
    dateController= "${date.day}/${date.month}/${date.year}";
    timeController=  "${(timeOfDay.hour % 12 == 0 ? 12 : timeOfDay.hour % 12).toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')} ${timeOfDay.hour < 12 ? 'AM' : 'PM'}";

    super.initState();
  }

  saveData() async{
    if(taskFormKey.currentState!.validate()){

      Map<String,dynamic> taskData={
        "title":titleController.text,
        "Details":descriptionController.text,
        "Time":timeController,
        "Date":dateController,
        "isSilent":isSilent,
        //Todo Uncomment Field Accordingly
        // "isCompleted":false
      };

      var response = await DataBase.saveMessageData(widget.petId, taskData);

      if(response == true){
        uiHelper.customAlertBox(() { }, context, "Task Added Successfully");
      }else{
        uiHelper.customAlertBox(() { }, context, response.toString());
      }

    }
    else{
      uiHelper.customAlertBox(() { }, context, "Please Fill Out all Details");
    }
  }

  titleValidator(value){

    if(value==""){
      return "Please Enter Task Title";
    }
    return null;

  }
  descriptionValidator(value){

    if(value==""){
      return "Please Enter Task Description";
    }
    return null;

  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 714,
      decoration: BoxDecoration(
          color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4)),
      child: Column(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                  child: Center(
                      child: Text(
                        "TASK",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500),
                      )),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(208, 187, 187, 1),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(7),
                          topRight: Radius.circular(7))))),
          Expanded(
              flex: 8,
              child: Container(
                color: Color.fromRGBO(64, 64, 64, 0.01),
                child: Form(
                  key: taskFormKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            "Title",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        TextFormField(
                          maxLength: 16,
                          controller: titleController,
                          autovalidateMode:
                          AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                              hintText: ("Enter Your Task Title"),
                              prefixIcon: Icon(
                                  Icons.drive_file_rename_outline),
                              border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(25))),
                          validator: (value) => titleValidator(value),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 6, left: 10.0),
                          child: Text(
                            "Description",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        SingleChildScrollView(
                          child: SizedBox(
                            height:
                            200, // Set the initial height here
                            child: TextFormField(
                              controller: descriptionController,
                              autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                              maxLines: null,
                              decoration: InputDecoration(
                                hintText: "Description of Your Task",
                                prefixIcon:
                                Icon(Icons.note_alt_outlined),
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(25),
                                ),
                              ),
                              validator: (value) => descriptionValidator(value),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(203, 182, 182, 0.3),
                                borderRadius: BorderRadius.circular(7)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("Remainder :- ",style: TextStyle(
                                  fontSize: 20
                                ),),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.do_not_disturb_on_total_silence,size:isSilent==true ? 30 : 25, color: isSilent==true ? Colors.teal: Colors.black,),
                                      onPressed: () {
                                        setState(() {
                                          isSilent=true;
                                        });
                                      },
                                    ),
                                    Text("Silent",style: TextStyle(
                                        color: isSilent==true ? Colors.teal: Colors.black
                                    ),),
                                    IconButton(
                                      icon: Icon(Icons.do_not_disturb_on_total_silence,size:isSilent!=true ? 30 : 25,color: isSilent!=true ? Colors.teal: Colors.black),
                                      onPressed: () {
                                        setState(() {
                                          isSilent=false;
                                        });
                                      },
                                    ),
                                    Text("Ring",style: TextStyle(
                                        color: isSilent!=true ? Colors.teal: Colors.black
                                    )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                        ,
                        Container(
                          decoration: BoxDecoration(
                              color:
                              Color.fromRGBO(203, 182, 182, 0.3),
                              borderRadius: BorderRadius.circular(7)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "Date :-",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        DateTime? datePicked =
                                        await showDatePicker(
                                          context: context,
                                          firstDate:
                                          DateTime.now(),
                                          lastDate: DateTime(2100) ,
                                        );
                                        if (datePicked != null) {
                                          setState(() {
                                            date = datePicked;
                                            dateController = "${date.day}/${date.month}/${date.year}";
                                            print("Time : $datePicked");
                                          });
                                        }
                                      },
                                      child: Text(dateController),
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(7.0),
                                              topRight: Radius.circular(7.0),
                                            ))),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: [
                                    Text("Time :-",
                                        style:
                                        TextStyle(fontSize: 20)),
                                    ElevatedButton(
                                      onPressed: () async{
                                        TimeOfDay? timePicked =
                                        await showTimePicker(context: context, initialTime: TimeOfDay.now());
                                        if (timePicked != null) {
                                          setState(() {
                                            timeOfDay = timePicked;
                                            timeController = "${timeOfDay.hour}:${date.minute}";
                                            print("Time : $timeController");
                                          });
                                        }

                                      },
                                      child: Text(
                                          timeController
                                      ),
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(7.0),
                                              bottomRight: Radius.circular(7.0),
                                            ))),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )),
          Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: () {
                  saveData();
                },
                child: Text(
                  "Add Task",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Color.fromRGBO(208, 187, 187, 1),
                  ),
                  minimumSize:
                  MaterialStateProperty.all(Size.infinite),
                  shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(7.0),
                            bottomRight: Radius.circular(7.0),
                          ))),
                ),
              ))
        ],
      ),
    );
  }
}
