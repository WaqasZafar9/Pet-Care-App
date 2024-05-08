import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pet_care/petDetails.dart';
import 'package:pet_care/uihelper.dart';

class petScreenDynamic extends StatefulWidget {
  Map<String,dynamic> userData;
  petScreenDynamic({super.key,required this.userData});

  @override
  State<petScreenDynamic> createState() => _petScreenDynamicState();
}

class _petScreenDynamicState extends State<petScreenDynamic> {

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.pinkAccent.shade100,
              borderRadius: BorderRadius.circular(10)),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          color: Colors.white70,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.transparent),
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("PetData")
                  .doc(widget.userData["Email"]+"1")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (!snapshot.requireData.exists) {
                    return Center(
                      child: Container(
                        width: RenderErrorBox.minimumWidth,
                        height: RenderErrorBox.minimumWidth / 1.5,
                        decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(10),
                            border:
                            Border.all(color: Colors.pinkAccent.shade200)),
                        child: Center(
                            child: Text(
                              "Error ${snapshot.error.toString()}",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            )),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    // print("Snap Data : ${snapshot.data.toString()}");
                    // Todo  setList Info

                    // list = snapshot.data!["petIds"];
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => petDetails(petData: snapshot.data!.data(),),));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.pinkAccent.shade100,
                                  borderRadius: BorderRadius.circular(13)),
                              child: ListTile(
                                style: ListTileStyle.drawer,
                                leading: CircleAvatar(
                                    backgroundImage: NetworkImage(snapshot.data!["Photo"])),
                                contentPadding: EdgeInsets.all(30),
                                title: Text(
                                    "${snapshot.data!["Name"]} + $index"),
                                subtitle: Text(
                                    "${snapshot.data!["Breed"]} "),
                                trailing: Icon(
                                  Icons.ads_click,
                                  color: Colors.pinkAccent.shade700,
                                ),
                              ),
                            ),
                          ),
                        );
                      },

                      // Todo  Fix The Iterator lenght
                      itemCount: 1,
                    );
                  }
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ),
      )
    ]);
  }
}
