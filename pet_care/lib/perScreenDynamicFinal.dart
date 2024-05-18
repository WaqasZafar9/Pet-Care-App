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
    return Stack(
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
                  itemCount: petData.length + 1, // Add one more item for "Add Pet"
                  itemBuilder: (context, index) {
                    if (index == petData.length) {
                      // This is the last item, show "Add Pet" card
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Colors.grey.shade200,
                          child: ListTile(
                            leading: Icon(Icons.add, size: 40, color: Colors.grey.shade600),
                            title: Text("Add Pet", style: TextStyle(color: Colors.grey.shade700, fontSize: 20,fontWeight: FontWeight.w500)),
                            contentPadding: EdgeInsets.only(left: 95,bottom: 6,top: 6),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => addPetForm(userData: widget.userData),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }
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
      ],
    );
  }
}
