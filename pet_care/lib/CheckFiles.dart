

import 'package:flutter/material.dart';
import 'package:pet_care/Community/CommunityScreen.dart';
import 'package:pet_care/CredentialsScreen/ForgotPassword.dart';
import 'package:pet_care/CredentialsScreen/SignUpPage.dart';
import 'package:pet_care/GoogleNavBar.dart';
import 'package:pet_care/CredentialsScreen/LoginPage.dart';
import 'package:pet_care/HomePage/HomePage.dart';
import 'package:pet_care/PaymentForm.dart';
import 'package:pet_care/ProfilePage.dart';
import 'package:pet_care/SplashScreen.dart';
import 'package:pet_care/Tracking/TrackingPet.dart';
import 'package:pet_care/CredentialsScreen/phoneAuthentication.dart';

class checkFiles extends StatelessWidget {
  const checkFiles({super.key});

  @override
  Widget build(BuildContext context) {

    Map<String,dynamic> userData={
      "Name":"Jerry",
      "Email":"fuzailraza161@gmail.com",
      "isVerified":false,
      "PhoneNo":"+923014384681"
    };
    return Scaffold(
      appBar: AppBar(
        title: Text("Check Files"),
      ),
      body:Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Center(child: ElevatedButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => Login(),)), child: Text("Login"))),
            ElevatedButton(onPressed: ()=>Navigator.pushNamed(context, 'Signup Page'), child: const Text("Signup Called")),
            ElevatedButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => Tests(userData: {
              "Name":"Test Call"
            }),)), child: Text("Google NavBar")),
            ElevatedButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(userData: userData,),)), child: Text("HomePage")),
            ElevatedButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentForm( ),)), child: Text("Payment Form")),
            ElevatedButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPassword(),)), child: Text("Forgot PassWord")),
            ElevatedButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneAuthentication(userData: userData,),)), child: Text("Phone Authentication")),
            ElevatedButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(userData: userData),)), child: Text("Profile Page")),
            ElevatedButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen(),)), child: Text("Splash Screen")),
            ElevatedButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp(),)), child: Text("SignUp Page")),
            ElevatedButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => trackingPet(),)), child: Text("Pet Track")),
            ElevatedButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => communityScreen(email: userData["Email"],),)), child: Text("Community Screen")),
            ElevatedButton(onPressed: ()=> ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Paid Successfully"))), child: Text("Click")),



          ],
        ),
      ),
    );
  }
}
