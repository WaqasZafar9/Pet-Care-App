import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pet_care/addPetForm.dart';
import 'package:pet_care/petDetails.dart';

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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.pinkAccent.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
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
                    itemCount: petData.length , // Add one more item for "Add Pet"
                    itemBuilder: (context, index) {
                      var pet = petData[index].data() as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(pet["Photo"]),
                            ),
                            title: Text(pet["Name"]),
                            subtitle: Text(pet["Breed"]),
                            contentPadding: EdgeInsets.all(20),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => petDetails(petData: pet),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 7,
            left: MediaQuery.of(context).size.width * 0.02,
            right: MediaQuery.of(context).size.width * 0.02,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(170, 120, 120, 0.8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                ),
                minimumSize: Size(10, 70)
              ),
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
