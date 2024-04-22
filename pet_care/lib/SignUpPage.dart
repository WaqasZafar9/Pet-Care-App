
import 'package:flutter/material.dart';
import 'package:pet_care/LoginPage.dart';
import 'package:pet_care/uihelper.dart';

class SignUp extends StatefulWidget{
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var NameController=TextEditingController();
  var PhoneNoController=TextEditingController();
  var EmailController=TextEditingController();
  var PasswordController=TextEditingController();
  var ConfirmPasswordController=TextEditingController();
  var CityController=TextEditingController();
  var DateOfBirthController=TextEditingController();
  var PetController=TextEditingController();

  @override
  Widget build(BuildContext context) {

    DateTime date=DateTime(2024);

    return Scaffold(
      appBar: AppBar(
        title: Text("Pet Care"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                  // color: Colors.grey,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(image: AssetImage("assets/images/petPic.png"),width: 60,height: 50,)

                      ,

                      Text(
                        "SignUp",
                        style: TextStyle(
                        fontWeight: FontWeight.bold,fontSize: 48,color: Colors.teal,),
                      ),
                    ],
                  )
              ),

              uiHelper.customTextField(NameController, "Name", Icons.drive_file_rename_outline, false),
              uiHelper.customTextField(PhoneNoController, "PhoneNo", Icons.phone_rounded, false),
              uiHelper.customTextField(EmailController, "Email", Icons.phone_rounded, false),
              uiHelper.customTextField(PasswordController, "Password", Icons.password_rounded, true),
              uiHelper.customTextField(ConfirmPasswordController, "Confirm Password", Icons.password_rounded, true),
              uiHelper.customTextField(CityController, "City", Icons.location_city_outlined, false),

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
                  String email=EmailController.value.text;
                  String password=PasswordController.value.text;
                  final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                  final RegExp passwordRejex=RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$');
                  final RegExp NameRejex = RegExp(r'\d');
                  final RegExp PhoneNoRejex=RegExp(r'^(0)?\d{3}-?\d{7}$');
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
                    uiHelper.customAlertBox((){},context, "Phone No must be in 03XXXXXXXXX Format");
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