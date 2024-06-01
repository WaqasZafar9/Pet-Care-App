import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pet_care/HomePage/addPetForm.dart';
import 'package:pet_care/HomePage/petDetails.dart';
import 'package:pet_care/CredentialsScreen/phoneAuthentication.dart';
import 'package:pet_care/Tracking/trackingSoloPet.dart';
import 'package:simple_shadow/simple_shadow.dart';

class petScreenDynamic extends StatefulWidget {
  final Map<String, dynamic> userData;

  const petScreenDynamic({Key? key, required this.userData}) : super(key: key);

  @override
  _petScreenDynamicState createState() => _petScreenDynamicState();
}

class _petScreenDynamicState extends State<petScreenDynamic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white70,
            ),
          ),
          Column(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0,right: 4.0,top: 8.0),
                  child: SimpleShadow(
                    child: Card(
                      shape: RoundedRectangleBorder(

                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(12),
                          onTap: () {
                            print("Clicked");
                          },
                          // dense: true,
                          iconColor: Colors.teal,

                          //Todo : Remove else if as Pic never be null
                          leading: widget.userData["Pic"]!=null ? CircleAvatar(
                            radius: 30,
                            backgroundImage:  NetworkImage(widget.userData["Pic"]),
                            backgroundColor: Colors.white70,
                          ) :
                          CircleAvatar(
                            radius: 30,
                            backgroundImage:  AssetImage("assets/images/petPic.png"),
                            backgroundColor: Colors.white70,
                          )
                          ,
                          title: Text(
                            widget.userData["Name"],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          subtitle: Text(widget.userData["Email"]),
                          trailing: IconButton(
                            disabledColor: Colors.blueGrey.shade600,
                            icon: widget.userData["isVerified"] == true ? Icon(Icons.verified_user) : FaIcon(FontAwesomeIcons.squareMinus),
                            onPressed: widget.userData["isVerified"]==false ? (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>PhoneAuthentication(userData: widget.userData,) ,));
                            } : null
                            ,),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 9,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(6)
                    ),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection(widget.userData["Email"])
                          .snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Container(
                              width: RenderErrorBox.minimumWidth * 1.3,
                              height: RenderErrorBox.minimumWidth / 1.3,
                              decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.pinkAccent.shade200),
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
                          itemCount:
                              petData.length, // Add one more item for "Add Pet"
                          itemBuilder: (context, index) {
                            var pet = petData[index].data() as Map<String, dynamic>;
                            return Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: SimpleShadow(
                                opacity: 0.2,
                                sigma: 4,
                                offset: Offset(3, 4),
                                child: Card(
                                  // elevation: 5,
                                  color: Colors.blueGrey.shade100,
                                  child: ListTile(
                                    titleTextStyle: TextStyle(
                                      fontSize: 22,
                                      color: Colors.teal.shade700
                                    ),
                                    subtitleTextStyle: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black45
                                    ),
                                    leading: CircleAvatar(radius: 30,
                                      backgroundImage: NetworkImage(pet["Photo"]),
                                    ),
                                    title: Text(pet["Name"]),
                                    subtitle: Text(" "+pet["Breed"]),
                                    trailing: IconButton(onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => trackingPetSolo(petData: pet, email: widget.userData["Email"]),));
                                    }, icon: Icon(Icons.map)),
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
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 7,
            left: MediaQuery.of(context).size.width * 0.02,
            right: MediaQuery.of(context).size.width * 0.02,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  // backgroundColor: Color.fromRGBO(128, 213, 196, 0.6),
                  backgroundColor: Color.fromRGBO(0, 150, 136, 0.6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                  ),
                  minimumSize: Size(10, 70)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => addPetForm(userData: widget.userData),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Add Pet',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
