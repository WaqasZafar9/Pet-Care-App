import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/HomePage/petDetails.dart';

class petScreenDynamicStreamBuilder extends StatefulWidget {
  final Map<String, dynamic> userData;

  const petScreenDynamicStreamBuilder({Key? key, required this.userData}) : super(key: key);

  @override
  _petScreenDynamicStreamBuilderState createState() => _petScreenDynamicStreamBuilderState();
}

class _petScreenDynamicStreamBuilderState extends State<petScreenDynamicStreamBuilder> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(widget.userData["Email"])
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(fontSize: 18),
            ),
          );
        }
        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
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
