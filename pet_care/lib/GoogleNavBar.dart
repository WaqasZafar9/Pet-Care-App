
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pet_care/ProfilePage.dart';

class Tests extends StatefulWidget {
  const Tests({super.key});

  @override
  State<Tests> createState() => _TestsState();
}

class _TestsState extends State<Tests> {
  int index=0;

  List<Widget> _screens=<Widget>[
    Container(color: Colors.lime,),
    Container(color: Colors.blue,),
    Container(color: Colors.teal,),
    ProfilePage(),
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
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GNav(
              rippleColor: Colors.grey.shade800, // tab button ripple color when pressed
              hoverColor: Colors.grey.shade700, // tab button hover color
              haptic: true, // haptic feedback
              tabBorderRadius: 15,
              tabActiveBorder: Border.all(color: Colors.black, width: 1), // tab button border
              tabBorder: Border.all(color: Colors.grey, width: 1), // tab button border
              tabShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 8)], // tab button shadow
              curve: Curves.easeOutExpo, // tab animation curves
              duration: Duration(milliseconds: 400), // tab animation duration
              gap: 8, // the tab button gap between icon and text
              color: Colors.grey[800], // unselected icon color
              activeColor: Colors.purple, // selected icon and text color
              iconSize: 24, // tab button icon size
              tabBackgroundColor: Colors.purple.withOpacity(0.1), // selected tab background color
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5), // navigation bar padding
              onTabChange: (value) {
                setState(() {
                  index=value;
                });
              },
              tabs: [
                GButton(
                  icon: (FontAwesomeIcons.house),
                  text: "Home",
                ),

                GButton(
                  icon: (FontAwesomeIcons.cartShopping),
                  text: "Shop",
                ),
                GButton(
                  icon: (FontAwesomeIcons.mapLocationDot),
                  text: "Track",
                ),
                GButton(
                  icon:Icons.person_2,
                  text: "Profile",
                ),

              ]
          ),
        ),

      ),
    );

  }
}
