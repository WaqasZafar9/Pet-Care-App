
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  int index=0;

  List<Widget> _screens=<Widget>[
  Container(color: Colors.lime,),
  Container(color: Colors.blue,),
  Container(color: Colors.teal,),
  Container(color: Colors.greenAccent,),
  ];

  var userName="Fuzail";
  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 4,
      child: Scaffold(

        appBar: AppBar(
          title: Text("Welcome " + userName),
          backgroundColor: Colors.greenAccent,
          // centerTitle: true,
        ),
        body: _screens.elementAt(index),
        bottomNavigationBar: Container(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GNav(
                backgroundColor: Colors.black,
                color: Colors.white,
                activeColor: Colors.white,
                tabBackgroundColor: Colors.grey.shade800,
                gap: 8,
                onTabChange: (value) {
                  setState(() {
                    index=value;
                  });
                },
                tabs:[
                  GButton(
                    icon:Icons.person_2,
                    text: "Profile",
                  ),
                  GButton(
                    icon: Icons.search,
                    text: "Shop",
                  ),
                  GButton(
                    icon: Icons.search,
                    text: "Track",
                  ),
                  GButton(
                    icon: Icons.search,
                    text: "Home",
                  ),
                ]),
          ),
        ),

      ),
    );

  }
}
