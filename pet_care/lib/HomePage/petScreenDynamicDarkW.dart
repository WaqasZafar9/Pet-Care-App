import 'dart:io';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pet_care/AIScreen/gptScreen.dart';
import 'package:pet_care/AIScreen/gptScreenDark.dart';
import 'package:pet_care/ColorsScheme.dart';
import 'package:pet_care/Community/CommunityTestScreen.dart';
import 'package:pet_care/HomePage/addPetForm.dart';
import 'package:pet_care/HomePage/petDetails.dart';
import 'package:pet_care/CredentialsScreen/phoneAuthentication.dart';
import 'package:pet_care/Shoping/shopping.dart';
import 'package:pet_care/Tracking/trackingSoloPet.dart';
import 'package:simple_shadow/simple_shadow.dart';

class petScreenDynamicDarkW extends StatefulWidget {
  final Map<String, dynamic> userData;

  const petScreenDynamicDarkW({Key? key, required this.userData})
      : super(key: key);

  @override
  _petScreenDynamicDarkWState createState() => _petScreenDynamicDarkWState();
}

class _petScreenDynamicDarkWState extends State<petScreenDynamicDarkW> {

  var picsPath=[
    "assets/images/HomeScreenPics/Tracking.png",
    "assets/images/HomeScreenPics/Doctor.png",
    "assets/images/HomeScreenPics/Doctor.png",
    "assets/images/HomeScreenPics/Shop.png"
  ];
  var texts=[
    "Pet Track",
    "Pet Doctor",
    "Pet Community",
    "Pet Shop"
  ];
  var pages=[

  ];
  @override
  void initState() {
    pages=[
      gptScreenDark(),
      gptScreen(),
      CommunityScreen(userData: widget.userData),
      shopping()
    ];
    // TODO: implement initState
    super.initState();
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
                      padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                      child: SimpleShadow(
                        child: BlurryContainer(
                          color: Color(0xff584A79),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 19.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hi " + widget.userData["Name"],
                                  style: TextStyle(
                                      fontSize: headingSize, color: TextColor),
                                ),
                                Text(
                                  "Welcome Back 👋",
                                  style: TextStyle(
                                      fontSize: headingSize, color: TextColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 7,
                      child: Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                            gradient: BackgroundOverlayColor,
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: BlurryContainer(
                                color: Color(0xff584A79),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 11),
                                  child: Text("Our Services",
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20,
                                      color: TextColor,
                                    ),),
                                ),
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height/4,
                              child: ListView.builder(itemBuilder: (context, index) {

                                return Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15.0, bottom: 15.0, left: 22.0),
                                  child: SimpleShadow(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => pages[index]));
                                      },
                                      child: Container(
                                        width: 215,
                                        decoration: BoxDecoration(
                                            gradient: cardColor,
                                            borderRadius: BorderRadius.circular(20)),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 100,
                                              width: 100,
                                              child: Image.asset(
                                                // "assets/images/HomeScreenPics/Tracking.png"
                                                  picsPath[index]
                                              ),
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
                    flex: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: BackgroundOverlayColor,
                            borderRadius: BorderRadius.circular(6)),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 7,bottom: 7),
                              child: BlurryContainer(
                                color: Color(0xff584A79),
                                padding: EdgeInsets.all(0),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 11),
                                  child: Text("Your Pets",
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20,
                                      color: TextColor,
                                    ),),
                                ),
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height/2.7,
                              width: MediaQuery.of(context).size.width,
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection(widget.userData["Email"])
                                    .snapshots(),
                                builder:
                                    (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (!snapshot.hasData ||
                                      snapshot.data!.docs.isEmpty) {
                                    return Center(
                                      child: Container(
                                        width: RenderErrorBox.minimumWidth * 1.3,
                                        height: RenderErrorBox.minimumWidth / 1.3,
                                        decoration: BoxDecoration(
                                          gradient: listTileColor,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.pinkAccent.shade200),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Error ${snapshot.error.toString()}",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
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
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 9.0,vertical: 5),
                                        child: SimpleShadow(
                                          child: Container(
                                            width: 363,
                                            height: 100,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                gradient: index%2!=0 ? listTileColor:listTileColorSecond
                                            ),
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
                                              title: Text(pet["Name"],style: TextStyle(
                                                  color: TextColor
                                              ),),
                                              subtitle: Text(pet["Breed"],style: TextStyle(
                                                  color: TextColor
                                              ),),
                                              trailing: IconButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              trackingPetSolo(
                                                                  petData: pet,
                                                                  email:
                                                                  widget.userData[
                                                                  "Email"]),
                                                        ));
                                                  },
                                                  icon: Icon(Icons.map)),
                                              contentPadding: EdgeInsets.all(20),
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        petDetails(petData: pet),
                                                  ),
                                                );
                                              },
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
              left: MediaQuery.of(context).size.width * 0.02,
              right: MediaQuery.of(context).size.width * 0.02,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // backgroundColor: Color.fromRGBO(128, 213, 196, 0.6),
                    backgroundColor: Color.fromRGBO(53, 47, 68, 0.8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                    ),
                    minimumSize: Size(10, 60)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          addPetForm(userData: widget.userData),
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
