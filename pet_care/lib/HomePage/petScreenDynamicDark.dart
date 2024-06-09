import 'dart:io';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pet_care/AIScreen/gptScreen.dart';
import 'package:pet_care/AIScreen/gptScreenDark.dart';
import 'package:pet_care/ColorsScheme.dart';
import 'package:pet_care/Community/CommunityScreenDark.dart';
import 'package:pet_care/Community/CommunityTestScreen.dart';
import 'package:pet_care/CredentialsScreen/LoginPage.dart';
import 'package:pet_care/DataBase.dart';
import 'package:pet_care/HomePage/addPetForm.dart';
import 'package:pet_care/HomePage/addPetFormDark.dart';
import 'package:pet_care/HomePage/petDetails.dart';
import 'package:pet_care/CredentialsScreen/phoneAuthentication.dart';
import 'package:pet_care/HomePage/petDetailsDark.dart';
import 'package:pet_care/Shoping/shopping.dart';
import 'package:pet_care/Tracking/trackingSoloPet.dart';
import 'package:pet_care/uihelper.dart';
import 'package:simple_shadow/simple_shadow.dart';

class petScreenDynamicDark extends StatefulWidget {
  final Map<String, dynamic> userData;

  const petScreenDynamicDark({Key? key, required this.userData})
      : super(key: key);

  @override
  _petScreenDynamicDarkState createState() => _petScreenDynamicDarkState();
}

class _petScreenDynamicDarkState extends State<petScreenDynamicDark> {
  var picsPath = [
    "assets/images/HomeScreenPics/Tracking.png",
    "assets/images/HomeScreenPics/Doctor.png",
    "assets/images/HomeScreenPics/Doctor.png",
    "assets/images/HomeScreenPics/Shop.png"
  ];
  var texts = ["Pet Track", "Pet Doctor", "Pet Community", "Pet Shop"];
  var pages = [];
  @override
  void initState() {
    pages = [
      gptScreenDark(),
      gptScreen(),
      // CommunityScreen(userData: widget.userData),
      CommunityScreenDark(userData: widget.userData),
      shopping()
    ];
    // TODO: implement initState
    super.initState();
  }

  deletePet(petID) async{

    try {
      await DataBase.deleteCollection(petID);
      await DataBase.deleteUserData(widget.userData["Email"], petID);
      return true;
    }
    catch (ex){
      return false;
    }

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(gradient: backgroundColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 6.0, top: 15.0, bottom: 8),
                      child: SimpleShadow(
                        child: Row(
                          children: [
                            Container(
                              height: 97,
                              decoration: BoxDecoration(
                                  gradient: titleBackgroundColor,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 9.0),
                                child: Row(
                                  children: [
                                    widget.userData["Pic"] != null
                                        ? CircleAvatar(
                                            radius: 30,
                                            backgroundImage: NetworkImage(
                                                widget.userData["Pic"]),
                                            backgroundColor: Colors.white70,
                                          )
                                        : CircleAvatar(
                                            radius: 30,
                                            backgroundImage: AssetImage(
                                                "assets/images/petPic.png"),
                                            backgroundColor: Colors.white70,
                                          ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 24.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Hi " + widget.userData["Name"],
                                            style: TextStyle(
                                                fontSize: headingSize,
                                                color: TextColor),
                                          ),
                                          Text(
                                            "Welcome Back 👋",
                                            style: TextStyle(
                                                fontSize: headingSize,
                                                color: TextColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: appBarColor,
                                  borderRadius: BorderRadius.all(Radius.circular(12))
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    IconButton(
                                      disabledColor: Colors.blueGrey.shade600,
                                      icon: widget.userData["isVerified"] == true
                                          ? Icon(
                                              Icons.published_with_changes_outlined,
                                              color: Colors.grey.shade400,
                                            )
                                          : Icon(Icons.unpublished_outlined,color: Colors.grey.shade400,),
                                      onPressed:
                                          widget.userData["isVerified"] == false
                                              ? () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            PhoneAuthentication(
                                                          userData: widget.userData,
                                                        ),
                                                      ));
                                                }
                                              : null,
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          await FirebaseAuth.instance.signOut();
                                          await Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Login()));
                                        },
                                        icon: Icon(
                                          Icons.logout_rounded,
                                          color: Colors.grey,
                                          size: 30,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 6,
                      child: Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                            gradient: BackgroundOverlayColor,
                            borderRadius: BorderRadius.circular(0)),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: headingBackgroundColor,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 11),
                                  child: Text(
                                    "Our Services",
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20,
                                      color: TextColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height / 5,
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15.0, bottom: 15.0, left: 22.0),
                                    child: SimpleShadow(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      pages[index]));
                                        },
                                        child: Container(
                                          width: 166,
                                          height: 169,
                                          decoration: BoxDecoration(
                                              gradient: cardColor,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: 83,
                                                width: 74,
                                                child: Image.asset(
                                                    // "assets/images/HomeScreenPics/Tracking.png"
                                                    picsPath[index]),
                                              ),
                                              Text(
                                                // "Pet Track",
                                                texts[index],
                                                style: TextStyle(
                                                  fontSize: headingSize - 2,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: texts.length,
                                scrollDirection: Axis.horizontal,
                              ),
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                    flex: 12,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6.0, bottom: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: BackgroundOverlayColor,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(6),
                                topLeft: Radius.circular(6),
                                bottomRight: Radius.circular(3),
                                bottomLeft: Radius.circular(3))),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 7, bottom: 7),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: headingBackgroundColor),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 11),
                                  child: Text(
                                    "Your Pets",
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20,
                                      color: TextColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height / 2.4,
                              width: MediaQuery.of(context).size.width,
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection(widget.userData["Email"])
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (!snapshot.hasData ||
                                      snapshot.data!.docs.isEmpty) {
                                    return Center(
                                      child: BlurryContainer(
                                        color: buttonColor,
                                        child: Container(
                                          width:
                                              RenderErrorBox.minimumWidth * 1.3,
                                          height:
                                              RenderErrorBox.minimumWidth / 1.6,
                                          decoration: BoxDecoration(
                                            // gradient: listTileColor,
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Text(
                                              // "Error ${snapshot.error.toString()}",
                                              "No Pet Added Yet !!!",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey.shade500),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  var petData = snapshot.data!.docs;

                                  return ListView.builder(
                                    itemCount: petData
                                        .length, // Add one more item for "Add Pet"
                                    itemBuilder: (context, index) {
                                      var pet = petData[index].data()
                                          as Map<String, dynamic>;
                                      return Dismissible(

                                        key: Key(petData[index].id),
                                        direction: DismissDirection.endToStart,
                                        onDismissed: (direction) async {
                                          var isDeleted = await deletePet(pet["Email"]);
                                          if (isDeleted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Pet ${petData[index]["Name"]} deleted'),
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Failed to delete ${petData[index]["Name"]}'),
                                              ),
                                            );
                                          }
                                        },
                                        background: Container(
                                          alignment: Alignment.centerRight,
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                            BorderRadius.circular(10),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        ),


                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0,
                                              bottom: 8.0,
                                              left: 12.0,
                                              right: 12.0),
                                          child: SimpleShadow(
                                            child: Container(
                                              width: 363,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  gradient: index % 2 != 0
                                                      ? listTileColor
                                                      : listTileColorSecond),
                                              child: ListTile(
                                                titleTextStyle: TextStyle(
                                                    fontSize: 22,
                                                    color: Colors.teal.shade700),
                                                subtitleTextStyle: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black45),
                                                leading: CircleAvatar(
                                                  radius: 30,
                                                  backgroundImage:
                                                      NetworkImage(pet["Photo"]),
                                                ),
                                                title: Text(
                                                  pet["Name"],
                                                  style:
                                                      TextStyle(color: TextColor),
                                                ),
                                                subtitle: Text(
                                                  pet["Breed"],
                                                  style:
                                                      TextStyle(color: TextColor),
                                                ),
                                                trailing: GestureDetector(
                                                  onTap: () async{
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              trackingPetSolo(
                                                                  petData: pet,
                                                                  email: widget
                                                                          .userData[
                                                                      "Email"]),
                                                        ));

                                                  },
                                                  child: Image.asset(
                                                    "assets/images/HomeScreenPics/Tracking.png",
                                                    height: 50,
                                                    width: 35,
                                                  ),
                                                ),
                                                contentPadding:
                                                    EdgeInsets.all(20),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          petDetailsDark(
                                                              petData: pet),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 7,
              left: 0,
              // left: MediaQuery.of(context).size.width * 0.02,
              right: 0,
              // right: MediaQuery.of(context).size.width * 0.02,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    // backgroundColor: Color.fromRGBO(128, 213, 196, 0.6),
                    backgroundColor: buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                    ),
                    minimumSize: Size(10, 40)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          addPetFormDark(userData: widget.userData),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'Add Pet',
                    style: TextStyle(
                        fontSize: headingSize,
                        fontWeight: FontWeight.w500,
                        color: TextColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
