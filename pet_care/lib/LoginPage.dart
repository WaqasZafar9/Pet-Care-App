
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pet_care/SignUpPage.dart';
import 'package:pet_care/uihelper.dart';

class Login extends StatefulWidget{
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var EmailController=TextEditingController();
  var PasswordController=TextEditingController();
  var _passwordVisible=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text("Pet Care"),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 1080,
          color: Color.fromRGBO(10, 101, 10, 0.2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Image(height: 200,image: AssetImage("assets/images/petPic.png")),
             SizedBox(height: 50,),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: TextField(
                  controller: EmailController,
                 keyboardType:TextInputType.emailAddress ,
                 decoration: InputDecoration(
                   labelText: "Email",
                   prefixIcon: Icon(Icons.email_outlined),
                 ),
               ),
             ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: TextField(
                 controller: PasswordController,
                 keyboardType:TextInputType.emailAddress ,
                 obscureText: _passwordVisible,
                 decoration: InputDecoration(
                   labelText: "Password",
                   prefixIcon: Icon(Icons.password_rounded),
                   suffixIcon: IconButton(icon: Icon(_passwordVisible
                       ? Icons.visibility_off_outlined
                       : Icons.visibility_outlined,), onPressed: () {
        
                     setState(() {
                       _passwordVisible = !_passwordVisible;
                     });
        
                   },)
                 ),
               ),
             ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: ElevatedButton(onPressed: (){
        
               }, child: Text("LogIn"),style: ButtonStyle(
                 minimumSize:MaterialStateProperty.all(Size(180,50)) ,
                 elevation: MaterialStateProperty.all(5)
               ),
               ),
             ),
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 Text("Don't Have an Account??",style: TextStyle(fontSize: 16),),
                 TextButton(onPressed: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
                 }, child: Text("SignUp",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),))
               ],
             ),
             SizedBox(height: 420,)
            ],
          ),
        
        ),
      ),

    );
  }
}