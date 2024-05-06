
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatelessWidget {
  Map<String,dynamic> userData;
   HomePage({super.key,required this.userData});

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 4,
      child: Scaffold(

        appBar: AppBar(
          title: Text("Welcome ${userData["Name"]}" ),
          // centerTitle: true,
          bottom:  const TabBar(tabs: [
            Tab(
              // icon: FaIcon(FontAwesomeIcons.user),,
                icon:Icon(Icons.person_2,size: 36,)
            ),
            Tab(
              icon: FaIcon(FontAwesomeIcons.cartShopping),
            ),
            Tab(
              icon: FaIcon(FontAwesomeIcons.mapLocationDot),
            ),
            Tab(
              icon: FaIcon(FontAwesomeIcons.house),
            ),
          ]
          ),
        ),
        body: TabBarView(children: [
          Container(
            color:Colors.tealAccent
          ),
          Container(
              color:Colors.lime
          ),
          Container(
              color:Colors.blue
          ),
          Container(
              color:Colors.teal
          ),
        ]),
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
                  if(value==1){
                     Container(
                      color: Colors.blue,
                    );
                  }
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
