import 'package:flutter/material.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black38),
        textTheme: TextTheme(
            displayLarge: TextStyle(fontSize: 18,color: Colors.blueGrey),
            titleMedium: TextStyle(fontSize: 12,color: Colors.purple,fontStyle: FontStyle.italic)
        ),
        useMaterial3: true,
        // primarySwatch: Colors.amber
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var firstInput=TextEditingController();
  var names=["Fuzail","Raza","Waqas","Zeeshan","Faseeh"];
  bool isObscured=true;
  var time =DateTime.timestamp();
  // var formatedDate=
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body:
      Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Selecte Date",style: TextStyle(fontSize: 25),),
                ElevatedButton(onPressed: () async {
                  DateTime? datePicked= await showDatePicker(
                      context: context,
                      // initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2024));
                  if (datePicked!=null){
                    print("Time : $datePicked");
                  }
                }, child:  Text("Select "),
                ),
                Text("Select Time"),
                ElevatedButton(onPressed: () async {
                  TimeOfDay? pcikedTime=await  showTimePicker(context: context,
                      initialTime: TimeOfDay.now(),
                      initialEntryMode: TimePickerEntryMode.dial);
                  if (pcikedTime!=null){
                    print("Time : $pcikedTime");
                  }

                }, child: const Text("Select"))
              ],
            ),
          )
      ),

    );
  }
}
