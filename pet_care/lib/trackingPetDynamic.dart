import 'dart:async';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pet_care/apiKey.dart';
import 'package:pet_care/uihelper.dart';

class trackingPetDynamic extends StatefulWidget {
  final String email;

  trackingPetDynamic({Key? key, required this.email}) : super(key: key);

  @override
  _trackingPetDynamicState createState() => _trackingPetDynamicState();
}

class _trackingPetDynamicState extends State<trackingPetDynamic> {
  String? dropdownValue;
  String photoUrl="";
  late List<String> items = [];
  late QuerySnapshot<Map<String, dynamic>> querySnapshot;
  Location _locationController = Location();
  String title = "";
  LatLng? _current;
  LatLng pos = LatLng(31.5607552, 74.378948);
  final Completer<GoogleMapController> _mapController =
  Completer<GoogleMapController>();
  bool isRouting = false;
  List<LatLng> polylineCoordinates = [];
  List<Marker> _markers = <Marker>[];
  String picPath = "assets/images/petPic.png";
  late BitmapDescriptor markerIcon;

  @override
  void initState() {
    super.initState();
    fetchData();
    getLocationUpdates();
    customMarkerImages();
  }

  Future<void> fetchData() async {
    try {
      querySnapshot = await FirebaseFirestore.instance
          .collection("PetData")
          .where("Email", isEqualTo: widget.email+"1")
          .get();


      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          items = querySnapshot.docs.map((doc) => doc.id).toList();
          dropdownValue = items.first;
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();

    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    _permissionGranted = await _locationController.hasPermission();

    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      } else {
        _locationController.onLocationChanged
            .listen((LocationData currentLocation) {
          if (currentLocation.latitude != null &&
              currentLocation.longitude != null) {
            setState(() {
              _current = LatLng(currentLocation.latitude!,
                  currentLocation.longitude!);
              if (isRouting) {
                reFocus(_current!);
              }
            });
          }
        });
      }
    }
  }

  Future<void> reFocus(LatLng position) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition newCameraPosition =
    CameraPosition(target: position, zoom: 13);
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

  Future<void> customMarkerImages() async {
    markerIcon = BitmapDescriptor.defaultMarker;
    await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, "assets/images/petPic.ico")
        .then((icon) {
      markerIcon = icon;
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
                  isRouting = true;
                  getPolyPoints();
                },
                icon: Icon(
                  Icons.route,
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Color.fromRGBO(10, 111, 112, 0.3),
                  ),
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
                    Color.fromRGBO(10, 111, 112, 0.3),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                reFocus(pos);
              },
              icon: FaIcon(FontAwesomeIcons.amazonPay),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Color.fromRGBO(10, 111, 112, 0.3),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              color: Colors.blue,
              child: _current == null
                  ? Center(
                child: CircularProgressIndicator(),
              )
                  : GoogleMap(
                myLocationEnabled: true,
                mapType: MapType.normal,
                onMapCreated: (GoogleMapController controller) {
                  _mapController.complete(controller);
                },
                initialCameraPosition:
                CameraPosition(target: _current!, zoom: 13),
                polylines: {
                  Polyline(
                    polylineId: PolylineId("Route"),
                    points: polylineCoordinates,
                    color: Colors.blue,
                    width: 6,
                    jointType: JointType.bevel,
                  ),
                },
                markers: {
                  Marker(
                    markerId: MarkerId("Id1"),
                    icon: markerIcon,
                    position: (pos),
                    infoWindow: InfoWindow(
                      title: title,
                      snippet: "Snipped of API",
                    ),
                  ),
                  Marker(
                    markerId: MarkerId("Id2"),
                    position:
                    LatLng(pos.latitude + 0.03, pos.longitude),
                    infoWindow: InfoWindow(
                      title: title,
                      snippet: "Snipped of API",
                    ),
                  ),
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton(
                    dropdownColor: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                    isExpanded: true,
                    value: dropdownValue,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    items: items.map((String item) {
                      return DropdownMenuItem(
                        value: item,
                        child: ListTile(
                          leading: photoUrl=="" ? CircleAvatar(
                            child: Image.asset("assets/images/petPic.png"),
                          ) :  CircleAvatar(
                            backgroundImage:  NetworkImage(photoUrl) ,
                          ),
                          title: Text(item),
                          subtitle: Text("Subs"),
                          splashColor: Colors.yellow,
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) async {
                      setState(() {
                        dropdownValue = newValue!;
                      });

                      try {
                        DocumentSnapshot<Map<String, dynamic>> selectedDoc =
                        await FirebaseFirestore.instance
                            .collection(widget.email + "1")
                            .doc(newValue)
                            .get();

                        if (selectedDoc.exists) {
                          setState(() {
                            photoUrl=selectedDoc.data()?['Photo'];
                            uiHelper.customAlertBox(() { }, context, photoUrl);
                            title = selectedDoc.data()?['Name'] ?? '';
                            uiHelper.customAlertBox(() { }, context, title);
                            pos = LatLng(
                              selectedDoc.data()?['Lat'] as double? ?? 0.0,
                              selectedDoc.data()?['Long'] as double? ?? 0.0,
                            );
                            polylineCoordinates = [];
                            isRouting = false;
                          });
                        }
                      } catch (e) {
                        print('Error fetching document: $e');
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getPolyPoints() async {
    polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        APIKEY,
        PointLatLng(_current!.latitude, _current!.longitude),
        PointLatLng(pos.latitude, pos.longitude),
      );
      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      }
    } catch (ex) {
      print(ex.toString());
    }

    setState(() {});
  }
}
