import 'package:flutter/material.dart';


class Temp extends StatefulWidget {
  const Temp({super.key, required this.title});

  final String title;

  @override
  State<Temp> createState() => _TempState();
}

class _TempState extends State<Temp> {


  @override
  Widget build(BuildContext context) {

    var names=["Fuzail","Raza","Zeeshan"];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body:Container(
        child: Padding(
            padding: EdgeInsets.all(10),
            child:ListView.separated(itemBuilder: (context, index) {
              return   Container(
                margin: EdgeInsets.only(bottom: 10),
                width: 400,
                height: 200,
                color: Colors.purple,
                child:
                Center(
                  child:
                  Text(names[index],style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
              separatorBuilder:(context,index){

                return Divider(height: 10,color: Colors.amber,thickness: 10) ;

              },
              itemCount: names.length,
            )
        ),
      ),

    );
  }
}
