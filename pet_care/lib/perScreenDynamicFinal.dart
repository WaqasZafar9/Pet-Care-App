import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
          child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection(widget.userData["Email"])
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Container(
                      width: RenderErrorBox.minimumWidth*1.3,
                      height: RenderErrorBox.minimumWidth / 1.3,
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
                }
                var petData = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: petData.length,
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
      ),]
    );
  }
}
