import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pet_care/uihelper.dart';


class trackingPet extends StatefulWidget {
  const trackingPet({super.key});

  @override
  State<trackingPet> createState() => _trackingPetState();
}

class _trackingPetState extends State<trackingPet> {
  @override
  void initState() {
    super.initState();
    getLocationUpdates();
    customMarker(LatLng(31.5607552, 74.378948));
  }


  init() {
    getLocationUpdates();
  }

  Location _locationController = Location();

  LatLng? _current = null;

  final Completer<GoogleMapController> _MapController =
      Completer<GoogleMapController>();
  String dropdownvalue = 'Item 1';
  LatLng _pGooglPlex = LatLng(-33.86, 151.20);
  late GoogleMapController mapController;
  // Future<void> newCoordinates(index) async {
  //   final GoogleMapController controller = await _controller.future;
  //   await controller.animateCamera(CameraUpdate.newCameraPosition(cordinatesList[index]));
  // }

  var cordinatesList = [
    CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(37.43296265331129, -122.08832357078792),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414)
  ];

  // List of items in our dropdown menu
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  var values = {
    "Item 1": {
      "Name": "Fuzail1",
      "Email": "fuzailraza161@gmail.com",
      "Lat": -33.86,
      "Long": 151.20
    },
    "Item 2": {
      "Name": "Fuzail2",
      "Email": "fuzailraza161@gmail.com",
      "Lat": -33.86,
      "Long": 151.20
    },
    "Item 3": {
      "Name": "Fuzail3",
      "Email": "fuzailraza161@gmail.com",
      "Lat": -33.86,
      "Long": 151.20
    },
    "Item 4": {
      "Name": "Fuzail4",
      "Email": "fuzailraza161@gmail.com",
      "Lat": -33.86,
      "Long": 151.20
    },
    "Item 5": {
      "Name": "Fuzail5",
      "Email": "fuzailraza161@gmail.com",
      "Lat": -33.86,
      "Long": 151.20
    }
  };

  List<Marker> _marker=<Marker>[];

  String picPath="assets/images/petPic.png";

  Uint8List? makrerImage;

  Future<Uint8List> getBytesFromAssets(String path,int width) async{

    ByteData data=await rootBundle.load(path);
    ui.Codec codec=await ui.instantiateImageCodec(data.buffer.asUint8List(),targetHeight: width);
    ui.FrameInfo frameInfo=await codec.getNextFrame();
    return (await frameInfo.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();

  }


  printValues(key) {
    print("Name : ${values[key]?["Name"]} Email ${values[key]?["Name"]}");
  }

   void customMarker (LatLng pos) async{

    final Uint8List markerIcon=await getBytesFromAssets(picPath, 100);
    _marker.add( Marker(
        markerId: MarkerId('01'),
        position: (pos),
        infoWindow: InfoWindow(
          title: "First Map API",
          snippet: "Snipped of API",
        ),
      icon: BitmapDescriptor.fromBytes(markerIcon)
    ));

  }

  // void _onMapCreated(GoogleMapController controller) {
  //   mapController = controller;
  // }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGuranted;

    _serviceEnabled = await _locationController.serviceEnabled();

    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    _permissionGuranted = await _locationController.hasPermission();

    // Todo Solve this error
    uiHelper.customAlertBox(() {}, context, "Located2 $_permissionGuranted");
    if (_permissionGuranted == PermissionStatus.denied) {
      uiHelper.customAlertBox(() {}, context, "Located2");

      _permissionGuranted = await _locationController.requestPermission();
      if (_permissionGuranted != PermissionStatus.granted) {
        return;
      }
    }
    else{
      _locationController.onLocationChanged
          .listen((LocationData currentLocation) {
        if (currentLocation.latitude != null &&
            currentLocation.longitude != null) {
          setState(() {
            _current =
                LatLng(currentLocation.latitude!, currentLocation.longitude!);
            print("Location : $_current");
            uiHelper.customAlertBox(() { }, context, "Located");
          });
        }
      });
    }

  }

  Future<void> reFocus(LatLng position) async {
    final GoogleMapController controller = await _MapController.future;
    CameraPosition newCameraPostion =
        CameraPosition(target: position, zoom: 13);
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(newCameraPostion));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: IconButton(
                onPressed: () {
                  reFocus(_current!);
                },
                icon: Icon(
                  Icons.person,
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Color.fromRGBO(10, 111, 112, 0.3)),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                reFocus(const LatLng(31.5607552, 74.378948));
                // init();
              },
              icon: FaIcon(FontAwesomeIcons.amazonPay),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Color.fromRGBO(10, 111, 112, 0.3))),
            ),
          ],
        ),
      ),
      body: Container(
        child: Stack(children: [
          Container(
              // height: 720,
         color: Colors.blue,
              child: _current == null
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : GoogleMap(
          myLocationEnabled: true,
                      // myLocationButtonEnabled: true,
                      mapType: MapType.normal,
                      onMapCreated: (GoogleMapController controller) {
                        _MapController.complete(controller);
                      },
                      initialCameraPosition:
                          CameraPosition(target: _current!, zoom: 13),
                      markers: {
                        _marker[0]
                      },
                    )),
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
