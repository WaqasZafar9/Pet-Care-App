
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pet_care/CredentialsScreen/SignUpPageForm.dart';
import 'package:pet_care/DataBase.dart';
import 'package:pet_care/CredentialsScreen/ForgotPassword.dart';
import 'package:pet_care/GoogleNavBar.dart';
import 'package:pet_care/uihelper.dart';


class Login extends StatefulWidget{
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  login(email,password) async{

    UserCredential? userCredential;
    try{
      userCredential=await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value) async{

        Map<String,dynamic> userData=await DataBase.readData("UserData",EmailController.value.text);
        await uiHelper.customAlertBox((){},context, "LoginIn + $userData");
        await Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Tests( userData: userData,)));
      });

    }
    on FirebaseAuthException catch(ex){
      return uiHelper.customAlertBox((){},context, ex.code.toString());
    }

  }

  var EmailController=TextEditingController();
  var PasswordController=TextEditingController();
  var _passwordVisible=true;
  final GlobalKey<FormState> _LoginFormKey=GlobalKey<FormState>();

  void _submitForm(){
    if(_LoginFormKey.currentState!.validate()){
      login(EmailController.value.text, PasswordController.value.text);
      uiHelper.customAlertBox((){},context, "Form Valid");
    }
    else{
      uiHelper.customAlertBox((){},context, "Form Not Valid");
    }

  }



  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    print(credential.toString());
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }


  String? validateEmail(value){

    if(value.isEmpty){
      return "Please Enter Email";
    }
    else {
      final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
      if(!emailRegex.hasMatch(value)){
        return "Please Enter Valid Email";
      }
    }
    return null;

  }

  String? passwordValidator(value){

    if(value=="123"){
      return "Password not Valid";
    }
    return null;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text("Pet Care")),
      ),
      body: SingleChildScrollView(
        child: Container(
          // height: 1080,
          color: Color.fromRGBO(10, 101, 10, 0.2),
          child: Form(
            key: _LoginFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height:80),
                Opacity(opacity: 0.5,
                    child: Image(height: 200,image: AssetImage("assets/images/petPic.png"))),
                SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.only(left:28.0,right:28.0,bottom:15.0),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: EmailController,
                    keyboardType:TextInputType.emailAddress ,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) => validateEmail(value),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:28.0,right:28.0,bottom:15.0),
                  child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      validator:(value) =>  passwordValidator(value)
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(onPressed: (){
                    _submitForm();

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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpForm()));
                    }, child: Text("SignUp",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),))
                  ],
                ),
                TextButton(onPressed:() => Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPassword(),)), child: Text("Forgot Password ?")),
                ElevatedButton(onPressed: (){
                  signInWithGoogle();

                }, child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("SignIN with Google",),
                    FaIcon(FontAwesomeIcons.googlePlus)
                  ],
                ),
                  style: ButtonStyle(


                  ),
                ),
                SizedBox(
                  height: 65,
                )
              ],
            ),
          ),

        ),
      ),

    );
  }
}