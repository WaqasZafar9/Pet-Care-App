
import 'package:flutter/material.dart';

class trackingPet extends StatefulWidget {
  const trackingPet({super.key});

  @override
  State<trackingPet> createState() => _trackingPetState();
}

class _trackingPetState extends State<trackingPet> {

  String dropdownvalue = 'Item 1';

  // List of items in our dropdown menu
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children:[
          Container(
            height: 720,
            color: Colors.blue,



          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              // width: 400,
              height: 100,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: DropdownButton(

                  dropdownColor: Colors.grey,
                  
                  borderRadius: BorderRadius.circular(10),
                  
                  isExpanded: true,


                  // Initial Value
                  value: dropdownvalue,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),

                  // Array list of items
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Image.asset("assets/images/petPic.png"),
                        ),
                        title: Text(items),
                        subtitle: Text("Subs"),
                        splashColor: Colors.yellow,
                        // trailing: Icon(Icons.keyboard_arrow_down_rounded),
                      ),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                    });
                  },
                ),
              ),
            ),
          )
      ]
      ),
    );
  }
}