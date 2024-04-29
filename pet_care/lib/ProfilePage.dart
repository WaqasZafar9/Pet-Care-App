import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/phoneAuthentication.dart';

class ProfilePage extends StatefulWidget {

  Map<String,dynamic> userData;

  ProfilePage({super.key,required this.userData});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.pinkAccent.shade100,
              borderRadius: BorderRadius.circular(10)),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          color: Colors.white70,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 0, right: 10, top: 50, bottom: 0),
                child: ListTile(
                  onTap: () {
                    print("Clicked");
                  },
                  leading: CircleAvatar(
                    radius: 30,
                    child: Image.asset("assets/images/petPic.png"),
                    backgroundColor: Colors.white70,
                  ),
                  title: Text(
                    widget.userData["Name"],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  subtitle: Text(widget.userData["Email"]),
                  trailing: IconButton(
                    icon: widget.userData["isVerified"] == true ? Icon(Icons.verified_user) : Icon(Icons.add),
                    onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>PhoneAuthentication(userData: widget.userData,) ,));
                  },),
                ),
              ),
              Divider(
                indent: 40,
                endIndent: 40,
                thickness: 1.3,
                height: 5,
              ),
              TextButton(
                  onPressed: () {},
                  child: Text(
                    "Change Password",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )
              ),
              Divider(),
              TextButton(
                  onPressed: () {},
                  child: Text(
                    "Support",
                    style: TextStyle(
                        decorationStyle: TextDecorationStyle.solid,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  )),
              Divider(),
              TextButton(
                  onPressed: () {},
                  child: Text(
                    "Terms & Conditons",
                    style: TextStyle(
                        decorationStyle: TextDecorationStyle.solid,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  )),
              Divider(),
              TextButton(
                  onPressed: () {},
                  child: Text(
                    "LogOut",
                    style: TextStyle(
                        decorationStyle: TextDecorationStyle.solid,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  )),
            ],
          ),
        ),
      )
    ]);
  }
}
