import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pet_care/CommunityScreen.dart';
import 'package:pet_care/CommunityTestScreen.dart';
import 'package:pet_care/ProfilePage.dart';
import 'package:pet_care/TrackingPet.dart';
import 'package:pet_care/TrackingPetGPT.dart';
import 'package:pet_care/gptScreen.dart';
import 'package:pet_care/perScreenDynamicFinal.dart';
import 'package:pet_care/shopping.dart';
import 'package:pet_care/trackingPetDynamic.dart';
import 'package:pet_care/trackingPetFinal.dart';

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
    petScreenDynamic(userData: {}),
    gptScreen(),
    trackingPetDynamic(email: ""),
    shopping(),
    CommunityScreen(userData: {
      "Email": "fuzailraza161@gmail.com",
      "Pic": "https://firebasestorage.googleapis.com/v0/b/pettify-96749.appspot.com/o/ProfilePics%2Ffuzailraza161%40gmail.com?alt=media&token=cfb1f919-11da-489e-bcc2-274a4525b28d"
    }),
  ];

  @override
  void initState() {
    Name = widget.userData["Name"].toString();
    if (Name.length > 11) {
      Name = Name.substring(0, 11);
    }
    super.initState();
    _screens[0] = petScreenDynamic(userData: widget.userData);
    // _screens[2] = trackingPetDynamic(email: widget.userData["Email"]);
    _screens[2] = TrackingPetGPT(email: widget.userData["Email"]);
    // _screens[3] = ProfilePage(userData: widget.userData);
    _screens[4] = CommunityScreen(
      userData: {
        "Email": widget.userData["Email"],
        "Pic": widget.userData["Pic"]
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          elevation: 5,
          title: ListTile(
            title: Text(
              "Welcome $Name",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  index = 4;
                });
              },
              icon: FaIcon(
                FontAwesomeIcons.users,
                color: Colors.white,
              ),
            ),
          ),
        ),
        body: AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: _screens.elementAt(index),
        ),
        bottomNavigationBar: GNav(
          rippleColor: Colors.tealAccent.shade100,
          hoverColor: Colors.tealAccent.shade200,
          haptic: true,
          tabBorderRadius: 15,
          tabActiveBorder: Border.all(color: Colors.black, width: 1),
          tabBorder: Border.all(color: Colors.grey, width: 1),
          tabShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 8)
          ],
          curve: Curves.easeOutExpo,
          duration: Duration(milliseconds: 400),
          gap: 8,
          color: Colors.grey[600],
          activeColor: Colors.teal,
          iconSize: 24,
          tabBackgroundColor: Colors.teal.withOpacity(0.1),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          tabMargin: EdgeInsets.all(4),
          backgroundColor: Colors.blueGrey.shade800,
          onTabChange: (value) {
            setState(() {
              index = value;
            });
          },
          tabs: [
            GButton(
              icon: FontAwesomeIcons.house,
              text: "Home",
            ),
            GButton(
              icon: FontAwesomeIcons.shoppingCart,
              text: "Shop",
            ),
            GButton(
              icon: FontAwesomeIcons.mapMarkerAlt,
              text: "Track",
            ),
            GButton(
              icon: Icons.person,
              text: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
