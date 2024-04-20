
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: [
            Card(

            )
            ,

            Text("Change Password"),
            Text("Support"),
            Text("Terms & Conditons"),
            Text("LogOut"),

          ],
        ),
    );
  }
}
