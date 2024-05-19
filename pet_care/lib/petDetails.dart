import 'package:flutter/material.dart';
import 'package:pet_care/ColorsScheme.dart';
import 'package:pet_care/PetDetailsWidget.dart';

class petDetails extends StatefulWidget {
  Map<String, dynamic>? petData;
  petDetails({super.key, required this.petData});

  @override
  State<petDetails> createState() => _petDetailsState();
}

class _petDetailsState extends State<petDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pet Details",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal.shade700,
        elevation: 5,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.teal.shade50,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: PetDetailsWidget(petData: widget.petData),
        ),
      ),
    );
  }
}
