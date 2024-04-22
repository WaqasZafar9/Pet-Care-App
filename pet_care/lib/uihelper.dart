


import 'package:flutter/material.dart';
import 'package:pet_care/LoginPage.dart';

class uiHelper {

  static customTextField(TextEditingController controller,String text,IconData iconData,bool toHide){

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        obscureText: toHide,

        decoration: InputDecoration(
            label: Text(text),
            prefixIcon: Icon(iconData),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25)
            )
        ),
      ),
    );

  }
  static customTextFormField({
    required String? Function(String?)? validator,
    required TextEditingController controller,
    required String text,
    required IconData iconData,
    bool toHide = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: text,
          prefixIcon: Icon(iconData),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        validator: validator,
      ),
    );
  }

  static customDateField(VoidCallback voidCallback,TextEditingController controller,String text,IconData iconData,bool toHide){

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        child: TextField(
          controller: controller,
          obscureText: toHide,

          decoration: InputDecoration(
              label: Text(text),
              prefixIcon: Icon(iconData),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25)
              )
          ),
        ),
        onTap: () => voidCallback(),
      ),
    );

  }

  static customButton(VoidCallback voidCallback,String text){
    return SizedBox(
      width: 200,
      height: 50,
      child: ElevatedButton( onPressed: () => voidCallback(),
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)
              )
          ),
          child: Text(text,style: const TextStyle(color: Colors.lightBlueAccent,fontSize: 20),)),
    );

  }

  static customAlertBox(VoidCallback voidCallback,BuildContext context,String text){

    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text(text,style: const TextStyle(fontSize: 18)),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child:Center(child: Text("OK")),
            onLongPress: voidCallback,)
        ],
      );
    });

  }
}