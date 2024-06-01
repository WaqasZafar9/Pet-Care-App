import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pet_care/ColorsScheme.dart';

class showTaskDetailsContainer extends StatefulWidget {

  Map<String,dynamic> remainderDetail;
  showTaskDetailsContainer({super.key,required this.remainderDetail});

  @override
  State<showTaskDetailsContainer> createState() =>
      _showTaskDetailsContainerState();
}

class _showTaskDetailsContainerState extends State<showTaskDetailsContainer> {
  bool isSilent=false;
  double headingFont = 20, subHeadingFont = 16;
  String title = "No Data",
      description =
          "No Data No DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo DataNo Data";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    title=widget.remainderDetail["title"];
    description=widget.remainderDetail["Details"];
    isSilent=widget.remainderDetail["isSilent"];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 550,
      // width: MediaQuery.of(context).size.width/1.04,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade500,width: 2),
          color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10 )),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
        ),

        child: Column(
          children: [
            SizedBox(
                height:12 ,
                child: Divider(color: Colors.grey.shade400,thickness: 5,indent: 120,endIndent: 120,)
            ),
            Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 8.0),
                  child: Column(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadiusDirectional.only(topStart: Radius.circular(6),topEnd: Radius.circular(6)),
                                color: Color.fromRGBO(203, 182, 182, 0.8),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    title,
                                    style: TextStyle(
                                      fontSize: headingFont + 4,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Divider()
                                ],
                              ),
                            ),
                          )),
                      Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0,right: 8.0,bottom: 6),
                            child: Container(
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadiusDirectional.only(bottomStart: Radius.circular(6),bottomEnd: Radius.circular(6)),
                                color: Color.fromRGBO(203, 182, 182, 0.5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  child: Text(
                                    description,
                                    style: TextStyle(
                                      fontSize: subHeadingFont,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                )),
            Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 20, bottom: 30),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(7),
                        color: Color.fromRGBO(203, 182, 182, 0.7),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Time",
                                style: TextStyle(
                                    fontSize: headingFont,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(widget.remainderDetail["Time"],
                                  style: TextStyle(
                                      fontSize: subHeadingFont,
                                      fontWeight: FontWeight.w600))
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Date",
                                  style: TextStyle(
                                      fontSize: headingFont,
                                      fontWeight: FontWeight.bold)),
                              Text(widget.remainderDetail["Date"],
                                  style: TextStyle(
                                      fontSize: subHeadingFont,
                                      fontWeight: FontWeight.w600))
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("Reaminder",
                                  style: TextStyle(
                                      fontSize: headingFont,
                                      fontWeight: FontWeight.bold)),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.do_not_disturb_on_total_silence,size:isSilent==true ? 30 : 25, color: isSilent==true ? Colors.teal: Colors.black,),
                                        onPressed: () {
                                          setState(() {
                                            // Todo Fix Silent Update in DataBase Also . check all stack call for silent update

                                            isSilent=true;
                                          });
                                        },
                                      ),
                                      // Text("Silent",style: TextStyle(
                                      //     color: isSilent==true ? Colors.teal: Colors.black
                                      // ),),
                                    ],
                                  ),

                                  Column(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.do_not_disturb_on_total_silence,size:isSilent!=true ? 30 : 25,color: isSilent!=true ? Colors.teal: Colors.black),
                                        onPressed: () {
                                          setState(() {
                                            isSilent=false;
                                          });
                                        },
                                      ),
                                      // Text("Ring",style: TextStyle(
                                      //     color: isSilent!=true ? Colors.teal: Colors.black
                                      // )),
                                    ],
                                  ),

                                ],
                              ),
                            ],
                          ),
                        ],
                      )),
                )),
            Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () {
                    final snackBarSilent = SnackBar(
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: 'Congratulations !!!',
                        message: 'Succussfully! Marked Completed!',
                        contentType: ContentType.success,
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBarSilent);
                  },
                  child: Text(
                    "Mark as Completed",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  style: ButtonStyle(
                    // minimumSize: MaterialStateProperty.all(Size(1000, 10),),
                    minimumSize: MaterialStateProperty.all(Size.infinite),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(7.0),
                      bottomRight: Radius.circular(7.0),
                    ))),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
