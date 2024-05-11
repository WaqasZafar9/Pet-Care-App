import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
    return FutureBuilder<QuerySnapshot>(
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
              child: Text(
                'No pets found.',
                style: TextStyle(fontSize: 18),
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
    );
  }
}
