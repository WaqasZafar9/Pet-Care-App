
import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Pet Care"),
      ),
      body: Container(
        child: Column(
          children: [
            uiHelper.customTextField(NameController, "Name", Icons.drive_file_rename_outline, false),
            uiHelper.customTextField(NameController, "PhoneNo:", Icons.phone_rounded, false),
            uiHelper.customTextField(NameController, "Password", Icons.password_rounded, false),
            uiHelper.customTextField(NameController, "Confirm Password", Icons.password_rounded, false),
            uiHelper.customTextField(NameController, "City", Icons.location_city_outlined, false),
            uiHelper.customDateField(() {DatePickerDialog(firstDate: DateTime(1947), lastDate: DateTime.now()); }, DateOfBirthController, "Date of Birth", Icons.date_range_outlined, false)
            ,Padding(
            padding: const EdgeInsets.all(8.0),
        child: InkWell(
          child: TextField(
            controller: DateOfBirthController,
            obscureText: false,

            decoration: InputDecoration(
                label: Text("Date of Birth"),
                prefixIcon: Icon(Icons.date_range_outlined),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25)
                )
            ),
          ),
          onTap: () {
            showTimePicker(context: context, initialTime: TimeOfDay.now());
          },
        ),
      ),
          ],
        ),
      ),
    );
  }
}