import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class trackingPet extends StatefulWidget {
  const trackingPet({super.key});

  @override
  State<trackingPet> createState() => _trackingPetState();
}

class _trackingPetState extends State<trackingPet> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();
  String dropdownvalue = 'Item 1';
  LatLng _pGooglPlex = LatLng(-33.86, 151.20);
  late GoogleMapController mapController;

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  // List of items in our dropdown menu
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  var values = {
    "Item 1": {"Name": "Fuzail1", "Email": "fuzailraza161@gmail.com","Lat":-33.86,"Long": 151.20},
    "Item 2": {"Name": "Fuzail2", "Email": "fuzailraza161@gmail.com","Lat":-33.86,"Long": 151.20},
    "Item 3": {"Name": "Fuzail3", "Email": "fuzailraza161@gmail.com","Lat":-33.86,"Long": 151.20},
    "Item 4": {"Name": "Fuzail4", "Email": "fuzailraza161@gmail.com","Lat":-33.86,"Long": 151.20},
    "Item 5": {"Name": "Fuzail5", "Email": "fuzailraza161@gmail.com","Lat":-33.86,"Long": 151.20}
  };

  printValues(key) {
    print("Name : ${values[key]?["Name"]} Email ${values[key]?["Name"]}");
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = mapController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

        child: Stack(children: [
          Container(
            // height: 720,
            color: Colors.blue,
            child: GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.hybrid ,
              onMapCreated: _onMapCreated,
                initialCameraPosition:
                    CameraPosition(target: _pGooglPlex, zoom: 13),
              markers: {
                const Marker(
                  markerId: MarkerId('Sydney'),
                  position: LatLng(-33.86, 151.20),
                  infoWindow: InfoWindow(
                    title: "First Map API",
                    snippet: "Snipped of API",
                  )
                )
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              // width: 400,
              height: 100,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                    printValues(newValue);
                    print("Map Controller Values ${mapController.mapId}");
                  },
                ),
              ),
            ),
          ),
        ]),

      ),

    );
  }
}
