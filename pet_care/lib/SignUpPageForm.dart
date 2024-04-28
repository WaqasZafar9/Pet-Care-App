
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/LoginPage.dart';
import 'package:pet_care/uihelper.dart';

class SignUpForm extends StatefulWidget{
  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {

  saveUserData(userData){

    return false;
  }


  signUP(userData) async{

    UserCredential? userCredential;

    try{
      userCredential=await FirebaseAuth.instance.createUserWithEmailAndPassword(email: userData["Email"], password: userData["Password"] ).then((value) {
        if(saveUserData(userData)) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Login()));
        }
        else{
          return uiHelper.customAlertBox((){},context, "User SignUp Failed");
        }
        return null;
      }
      );
    }
    on FirebaseAuthException catch(ex){
      return uiHelper.customAlertBox((){},context, ex.code.toString());
    }

  }




  void submitForm(){

    if(_SignupFormKey.currentState!.validate()){
      String email=EmailController.value.text;
      String password=PasswordController.value.text;

      Map userData={
        "Name":NameController.value.text,
        "Email":EmailController.value.text,
        "PhoneNo":PhoneNoController.value.text,
        "Password":PasswordController.value.text,
        "City":CityController.value.text,
        "DateOfBirth":DateOfBirthController.value.text,
        "Pic":null
      };

      signUP(userData);
      uiHelper.customAlertBox((){},context, "Form Valid");
    }
    else{
      uiHelper.customAlertBox((){},context, "Form Not Valid");
    }
    uiHelper.customAlertBox((){},context, "Remaining Call");
    String email=EmailController.value.text;
    String password=PasswordController.value.text;
    final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    final RegExp passwordRejex=RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$');
    final RegExp NameRejex = RegExp(r'\d');
    final RegExp PhoneNoRejex=RegExp(r'^\+92\d{10}$');
    String Name=NameController.value.text;
    String PhoneNo=PhoneNoController.value.text;
    String Email=EmailController.value.text;
    String Password=PasswordController.value.text;
    String ConfirmPassword=ConfirmPasswordController.value.text;
    String City=CityController.value.text;

    if(Name.isEmpty || PhoneNo.isEmpty || Email.isEmpty || Password.isEmpty || ConfirmPassword.isEmpty || City.isEmpty  ){
      uiHelper.customAlertBox((){},context, "PLease Fill All Fields!");
    }
    else if(Name.contains(NameRejex)){
      uiHelper.customAlertBox((){},context, "Name Not Valid.Must Not Contains Numbers!");
    }
    else if(!PhoneNo.contains(PhoneNoRejex)){
      uiHelper.customAlertBox((){},context, "Phone No must be in +92XXXXXXXXXX Format");
    }
    else if(!email.contains(emailRegex)){
      uiHelper.customAlertBox((){},context, "Email Not Valid!");
    }
    else if(password!=ConfirmPassword){
      uiHelper.customAlertBox((){},context, "Password and Confirm Passwords Must be Same");
    }
    else if(!Password.contains(passwordRejex)){
      uiHelper.customAlertBox((){},context, "Password Must Contains at Least One Lower Case,Upper Case,Digit,8 Letters Length");
    }
    else if(City.contains(NameRejex)){
      uiHelper.customAlertBox((){},context, "City Not Valid.Must Not Contains Numbers!");
    }
    else{
      uiHelper.customAlertBox((){},context, "SignUp SuccessFully");
    }
  }

  String? nameValidator(value){
    if(value.isEmpty ){
      return( "PLease Enter Name");
    }
    final RegExp NameRejex = RegExp(r'\d');
    if(value.contains(NameRejex)){
      return( "Name Not Valid.Must Not Contains Numbers!");
    }
    return null;
  }
  String? phoneNoValidator(value){
    if(value.isEmpty ){
      return( "PLease Enter PhoneNo");
    }
    final RegExp PhoneNoRejex=RegExp(r'^\+92\d{10}$');
    if(!value.contains(PhoneNoRejex)){
      return( "Phone No must be in +92XXXXXXXXXX Format");
    }
    return null;
  }
  String? emailValidator(value){
    if(value.isEmpty ){
      return("PLease Enter Email");
    }
    final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if(!value.contains(emailRegex)){
      return( "Email Not Valid!");
    }
    return null;
  }
  String? passwordValidator(value){
    if(value.isEmpty ){
      return( "PLease Enter Password");
    }
    final RegExp passwordRejex=RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$');
    if(!value.contains(passwordRejex)){
      return( "Password Must Contains at Least One Lower Case,Upper Case,Digit,8 Letters Length");
    }
    return null;
  }
  String? confirmPasswordValidator(value,ConfirmPassword){
    if(value!=ConfirmPassword){
      return("Password and Confirm Passwords Must be Same");
    }
    return null;
  }
  String? cityValidator(value){
    if(value.isEmpty ){
      return( "PLease Enter City");
    }
    final RegExp NameRejex = RegExp(r'\d');
    if(value.contains(NameRejex)){
      return( "City Not Valid.Must Not Contains Numbers!");
    }
    return null;
  }
  String? dateOfBirthValidator(value){
    if(value.isEmpty ){
      return( "PLease Enter Date of  birth");
    }
    return null;
  }

  var NameController=TextEditingController();
  var PhoneNoController=TextEditingController();
  var EmailController=TextEditingController();
  var PasswordController=TextEditingController();
  var ConfirmPasswordController=TextEditingController();
  var CityController=TextEditingController();
  var DateOfBirthController=TextEditingController();
  var PetController=TextEditingController();
  final GlobalKey<FormState> _SignupFormKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    DateTime date=DateTime(2024);

    return Scaffold(
      appBar: AppBar(
        title: Text("Pet Care"),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromRGBO(10, 101, 10, 0.2),
          child: Form(
            key: _SignupFormKey,
            child: Column(
              children: [
                Container(
                  // color: Colors.grey,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Opacity(opacity: 0.6,
                            child: Image(image: AssetImage("assets/images/petPic.png"),width: 60,height: 50,))
                        ,

                        Text(
                          "SignUp",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,fontSize: 48,color: Colors.teal,),
                        ),
                      ],
                    )
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: NameController,
                    keyboardType:TextInputType.emailAddress ,
                    decoration: InputDecoration(
                        label: Text("Name"),
                        prefixIcon: Icon(Icons.drive_file_rename_outline),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25)
                        )
                    ),
                    validator: (value) => nameValidator(value),
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: PhoneNoController,
                    keyboardType:TextInputType.emailAddress ,
                    decoration: InputDecoration(
                        label: Text("PhoneNo"),
                        prefixIcon: Icon(Icons.phone_rounded),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25)
                        )
                    ),
                    validator: (value) => phoneNoValidator(value),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: EmailController,
                    keyboardType:TextInputType.emailAddress ,
                    decoration: InputDecoration(
                        label: Text("Email"),
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25)
                        )
                    ),
                    validator: (value) => emailValidator(value),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: PasswordController,
                    keyboardType:TextInputType.emailAddress ,
                    decoration: InputDecoration(
                        label: Text("Password"),
                        prefixIcon: Icon(Icons.password_rounded),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25)
                        )
                    ),
                    validator: (value) => passwordValidator(value),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: ConfirmPasswordController,
                    keyboardType:TextInputType.emailAddress ,
                    decoration: InputDecoration(
                        label: Text("Confirm Password"),
                        prefixIcon: Icon(Icons.password_rounded),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25)
                        )
                    ),
                    validator: (value) => confirmPasswordValidator(value,PasswordController.text),
                  ),
                ),Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: CityController,
                    keyboardType:TextInputType.emailAddress ,
                    decoration: InputDecoration(
                        label: Text("City"),
                        prefixIcon: Icon(Icons.location_city_outlined),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25)
                        )
                    ),
                    validator: (value) => cityValidator(value),
                  ),
                ),


                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Row(
                      children: [
                        InkWell(
                          child: const Text("Date of Birth : ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                          onTap: () async {
                            DateTime? datePicked= await showDatePicker(
                                context: context,
                                // initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2024));
                            if (datePicked!=null){
                              date=datePicked;
                              print("Time : $datePicked");
                            }
                          },
                        ),
                        Text("$date")
                      ],
                    ),
                  ),
                )
                ,
                // Row(
                //   children: [
                //     ElevatedButton(onPressed: () async {
                //       DateTime? datePicked= await showDatePicker(
                //           context: context,
                //           // initialDate: DateTime.now(),
                //           firstDate: DateTime(2020),
                //           lastDate: DateTime(2024));
                //       if (datePicked!=null){
                //         print("Time : $datePicked");
                //       }
                //     }, child:  Text("Select "),
                //     ),
                //   ],
                // ),
                uiHelper.customDateField(() {DatePickerDialog(firstDate: DateTime(1947), lastDate: DateTime.now()); }, DateOfBirthController, "Date of Birth", Icons.date_range_outlined, false),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(onPressed: (){
                    submitForm();


                  }, child: Text("SignUp"),style: ButtonStyle(
                      minimumSize:MaterialStateProperty.all(Size(180,50)) ,
                      elevation: MaterialStateProperty.all(5)
                  ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Already Have an Account??",style: TextStyle(fontSize: 16),),
                    TextButton(onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
                    }, child: Text("LogIn",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


//
//
// Row(
// children: [
// TextField(
// controller: DateOfBirthController,
// obscureText: false,
//
// decoration: InputDecoration(
// label: Text("Date of Birth"),
// prefixIcon: Icon(Icons.date_range_outlined),
// border: OutlineInputBorder(
// borderRadius: BorderRadius.circular(25)
// )
// ),
// ),
// ElevatedButton(onPressed: () async {
// DateTime? datePicked= await showDatePicker(
// context: context,
// // initialDate: DateTime.now(),
// firstDate: DateTime(2020),
// lastDate: DateTime(2024));
// if (datePicked!=null){
// print("Time : $datePicked");
// }
// }, child:  Text("Select "),
// )
// ],
// ),