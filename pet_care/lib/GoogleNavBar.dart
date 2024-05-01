import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pet_care/CommunityScreen.dart';
import 'package:pet_care/CommunityTestScreen.dart';
import 'package:pet_care/ProfilePage.dart';
import 'package:pet_care/TrackingPet.dart';
import 'package:pet_care/petScreen.dart';

class Tests extends StatefulWidget {
  Map<String, dynamic> userData;
  Tests({super.key, required this.userData});

  @override
  State<Tests> createState() => _TestsState();
}

class _TestsState extends State<Tests> {
  String Name = "";

  int index = 0;

  List<Widget> _screens = <Widget>[
    petScreen(userData: {},),
    Container(
      color: Colors.blue,
    ),
    trackingPet(),
    ProfilePage(userData: {}),
    communityScreen(

      email: "fuzailraza161@gmail.com",
    ),
  ];

  @override
  void initState() {
    Name = widget.userData["Name"].toString();
    if (Name.length > 11) {
      Name = Name.substring(0, 11);
    }
    super.initState();
    _screens[0]=petScreen(userData: widget.userData);
    _screens[3] = ProfilePage(userData: widget.userData);
    _screens[4] = CommunityScreen(email: widget.userData["Email"]);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: ListTile(
            // leading: CircleAvatar(
            //   radius: 15,
            //   child: Image.asset("assets/images/petPic.png"),
            //   backgroundColor: Colors.white70,
            // ),
            title: Text(
              "Welcome ${Name}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: IconButton(
                onPressed: () {
                  setState(() {
                    // Todo uncomment accrodingly
                    index = 4;
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => communityScreen(email: widget.userData["Email"]),));
                  });
                },
                icon: FaIcon(FontAwesomeIcons.amazon)),
          ),
          // centerTitle: true,
        ),
        body: _screens.elementAt(index),
        bottomNavigationBar: GNav(
            rippleColor:
                Colors.grey.shade800, // tab button ripple color when pressed
            hoverColor: Colors.grey.shade700, // tab button hover color
            haptic: true, // haptic feedback
            tabBorderRadius: 15,
            tabActiveBorder:
                Border.all(color: Colors.black, width: 1), // tab button border
            tabBorder:
                Border.all(color: Colors.grey, width: 1), // tab button border
            tabShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 8)
            ], // tab button shadow
            curve: Curves.easeOutExpo, // tab animation curves
            duration: Duration(milliseconds: 400), // tab animation duration
            gap: 8, // the tab button gap between icon and text
            color: Colors.grey[600], // unselected icon color
            activeColor:
                Colors.pinkAccent.shade100, // selected icon and text color
            iconSize: 24, // tab button icon size
            tabBackgroundColor:
                Colors.purple.withOpacity(0.1), // selected tab background color
            padding: EdgeInsets.symmetric(
                horizontal: 20, vertical: 6), // navigation bar padding
            tabMargin: EdgeInsets.all(4),
            backgroundColor: Colors.blueGrey.shade500,
            onTabChange: (value) {
              setState(() {
                index = value;
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
              // GButton(
              //   icon: (FontAwesomeIcons.com),
              //   text: "Community",
              // ),
              GButton(
                icon: (FontAwesomeIcons.mapLocationDot),
                text: "Track",
              ),
              GButton(
                icon: Icons.person_2,
                text: "Profile",
              ),
            ]),
      ),
    );
  }
}
