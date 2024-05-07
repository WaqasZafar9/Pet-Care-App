import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pet_care/apiKey.dart';
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
    // customMarker(LatLng(31.5607552, 74.378948));
    customMarkerImages();
    customMarkerBytes();
    getPolyPoints();
  }


  Location _locationController = Location();
  String title = "";

  LatLng? _current;
  LatLng pos = LatLng(31.5607552, 74.378948);

  final Completer<GoogleMapController> _MapController =
      Completer<GoogleMapController>();
  String dropdownvalue = 'Item 1';

  bool isRouting=false;



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
      "Lat": 31.5107662,
      "Long": 74.378948
    },
    "Item 2": {
      "Name": "Fuzail2",
      "Email": "fuzailraza161@gmail.com",
      "Lat": 31.5309572,
      "Long": 74.378948
    },
    "Item 3": {
      "Name": "Fuzail3",
      "Email": "fuzailraza161@gmail.com",
      "Lat": 31.5607482,
      "Long": 74.378948
    },
    "Item 4": {
      "Name": "Fuzail4",
      "Email": "fuzailraza161@gmail.com",
      "Lat": 31.5901342,
      "Long": 74.378948
    },
    "Item 5": {
      "Name": "Fuzail5",
      "Email": "fuzailraza161@gmail.com",
      "Lat": 31.5803752,
      "Long": 74.378948
    }
  };

  List<LatLng> polylineCoordinates = [];


  List<Marker> _marker = <Marker>[];

  String picPath = "assets/images/petPic.png";

  Uint8List? markerImage;

  Future<Uint8List> getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    return (await frameInfo.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void customMarkerBytes() async {
    final Uint8List markerIcon = await getBytesFromAssets(picPath, 100);
    _marker.add(Marker(
        markerId: MarkerId('01'),
        position: (pos),
        infoWindow: InfoWindow(
          title: "First Map API",
          snippet: "Snipped of API",
        ),
        icon: BitmapDescriptor.fromBytes(markerIcon)));
  }
  late BitmapDescriptor markerIcon;

  void customMarkerImages() async{

    markerIcon=BitmapDescriptor.defaultMarker;
    await BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/images/petPic.ico").then((icon) {

      markerIcon=icon;


    },);

  }

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
      uiHelper.customAlertBox(() {}, context, "Located2 Inner 1 $_permissionGuranted");

      _permissionGuranted = await _locationController.requestPermission();
      await uiHelper.customAlertBox(() {}, context, "Located2 Inner 2 $_permissionGuranted");
      if (_permissionGuranted != PermissionStatus.granted) {
        await uiHelper.customAlertBox(() {}, context, "Located2 Inner Blocked Block $_permissionGuranted");
        return;
      }
      else {
        uiHelper.customAlertBox(() {}, context, "Located2 Final Block");
        _locationController.onLocationChanged
            .listen((LocationData currentLocation) {
          if (currentLocation.latitude != null &&
              currentLocation.longitude != null) {
            setState(() {
              _current = LatLng(currentLocation.latitude!, currentLocation.longitude!);
              // pos=LatLng(pos.latitude  +  0.0000052, pos.longitude +  0.000058) ;
              print("Location : $_current");
              print("Location : $pos");
              print(polylineCoordinates);
              if(isRouting) {
                reFocus(_current!);
              }
              // uiHelper.customAlertBox(() { }, context, "Located");
            });
          }
        });
      }
    }
  }

  Future<void> reFocus(LatLng position) async {
    final GoogleMapController controller = await _MapController.future;
    CameraPosition newCameraPostion =
        CameraPosition(target: position, zoom: 13);
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(newCameraPostion));
  }


  void getPolyPoints() async {
    polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          APIKEY,
          PointLatLng(_current!.latitude, _current!.longitude),
          PointLatLng(pos.latitude, pos.longitude));
      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      }
    }catch (ex){
      uiHelper.customAlertBox(() { }, context, ex.toString());
    }



    setState(() {

    });
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
                  getPolyPoints();
                  isRouting=true;
                },
                icon: Icon(
                  Icons.route,
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Color.fromRGBO(10, 111, 112, 0.3)),
                ),
              ),
            ),

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
                  backgroundColor: MaterialStateProperty.all(
                      Color.fromRGBO(10, 111, 112, 0.3)),
                ),
              ),
            ),

            IconButton(
              onPressed: () {
                reFocus(pos);
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
        // Todo Add Dynamic Data from Database
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
                      polylines: {
                        Polyline(
                            polylineId: PolylineId("Route"),
                            points: polylineCoordinates,
                            color: Colors.blue,
                            width: 6,
                          jointType: JointType.bevel
                        ),
                      },
                      markers: {
                        Marker(
                          markerId: MarkerId("Id1"),
                          icon:markerIcon,
                          position: (pos),
                          infoWindow: InfoWindow(
                            title: title,
                            snippet: "Snipped of API",
                          ),
                        ),
                        Marker(
                          markerId: MarkerId("Id2"),
                          position: LatLng(pos.latitude+0.03,pos.longitude),
                          infoWindow: InfoWindow(
                            title: title,
                            snippet: "Snipped of API",
                          ),
                        ),
                        // _marker[0]
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
                      title = values[dropdownvalue]!["Name"].toString();
                      pos = LatLng(values[dropdownvalue]!["Lat"] as double,
                          values[dropdownvalue]!["Long"] as double);
                      polylineCoordinates=[];
                      isRouting=false;
                    });

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