import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pet_care/ColorsScheme.dart';
import 'package:pet_care/DataBase.dart';
import 'package:pet_care/HomePage/showTaskDetailsContainer.dart';
import 'package:pet_care/HomePage/showTaskDetailsContainerDark.dart';
import 'package:pet_care/uihelper.dart';

class petReminderDetailsDark extends StatefulWidget {
  final String petID;
  petReminderDetailsDark({Key? key, required this.petID}) : super(key: key);

  @override
  _PetReminderDetailsState createState() => _PetReminderDetailsState();
}

class _PetReminderDetailsState extends State<petReminderDetailsDark> {
  var data;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var fetchedData = await DataBase.readRemainderData(widget.petID);
    setState(() {
      data = fetchedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          // color: Colors.grey.shade200,
          gradient: subheadingBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(6))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Reminders",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: subHeadingColor),
              ),
            ),
            Divider(color: Colors.black, endIndent: 10),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Center(
                    child: Text(
                      "Title",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color:subHeadingColortwo),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Text(
                      "Time",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: subHeadingColortwo),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Center(
                    child: Text(
                      "Date",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: subHeadingColortwo),
                    ),
                  ),
                ),
                Expanded(flex: 1, child: Container()),
              ],
            ),
            Divider(thickness: 2, indent: 30, endIndent: 30),
            data == null
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : ListView.separated(
                    separatorBuilder: (context, index) {
                      return Divider(indent: 5, endIndent: 10);
                    },
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return showTaskDetailsContainerDark(
                                  remainderDetail: data[index],
                                  petID: widget.petID,
                                );
                              },
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                flex: 5,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    data[index]["title"] as String,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: subTextColor),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Center(
                                  child: Text(
                                    data[index]["Time"] as String,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: subTextColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Center(
                                  child: Text(
                                    data[index]["Date"] as String,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: subTextColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    data[index]["isSilent"] =
                                        !(data[index]["isSilent"] as bool);
                                  });

                                  final snackBar = SnackBar(
                                    elevation: 0,
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.transparent,
                                    content: AwesomeSnackbarContent(
                                      title: 'Ring!',
                                      message: 'Notifications Turned ON!',
                                      contentType: ContentType.success,
                                    ),
                                  );

                                  final snackBarSilent = SnackBar(
                                    elevation: 0,
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.transparent,
                                    content: AwesomeSnackbarContent(
                                      title: 'Silent!',
                                      message: 'Notifications Turned OFF!',
                                      contentType: ContentType.warning,
                                      color: Colors.blueGrey,
                                    ),
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    data[index]["isSilent"] == true
                                        ? snackBarSilent
                                        : snackBar,
                                  );
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, bottom: 8),
                                  child: FaIcon(
                                    data[index]["isSilent"] == true
                                        ? FontAwesomeIcons.clock
                                        : FontAwesomeIcons.userClock,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
