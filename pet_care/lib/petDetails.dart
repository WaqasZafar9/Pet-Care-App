import 'package:flutter/material.dart';
import 'package:pet_care/ColorsScheme.dart';
import 'package:pet_care/PetDetailsWidget.dart';
import 'package:pet_care/showTaskDetailsContainer.dart';

class petDetails extends StatefulWidget {
  const petDetails({super.key});

  @override
  State<petDetails> createState() => _petDetailsState();
}

class _petDetailsState extends State<petDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome Fuzail"),
        backgroundColor: Colors.grey.shade500,
      ),

      /// ToDO Remove Drawer Property

      endDrawer: Drawer(
        child: ListView(
            children: [ showTaskDetailsContainer()]),
      ),
      body: Container(
        color: primaryColorBackground,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: PetDetailsWidget(),
        ),
      ),

    );
  }
}
