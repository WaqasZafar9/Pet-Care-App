import 'dart:async';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pet_care/apiKey.dart';

class TrackingPet extends StatefulWidget {
  const TrackingPet({Key? key}) : super(key: key);

  @override
  State<TrackingPet> createState() => _TrackingPetState();
}

class _TrackingPetState extends State<TrackingPet> {
  Location _locationController = Location();
  LatLng? _current;
  LatLng pos = LatLng(31.5607552, 74.378948);
  List<LatLng> polylineCoordinates = [];
  bool isRouting = false;
  late BitmapDescriptor markerIcon;
  final Completer<GoogleMapController> _MapController =
  Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
    customMarkerImages();
    getPolyPoints();
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

    if (_permissionGuranted == PermissionStatus.denied) {

      _permissionGuranted = await _locationController.requestPermission();
      if (_permissionGuranted != PermissionStatus.granted) {
        return;
      }
      else {
        _locationController.onLocationChanged
            .listen((LocationData currentLocation) {
          if (currentLocation.latitude != null &&
              currentLocation.longitude != null) {
            setState(() {
              _current = LatLng(currentLocation.latitude!, currentLocation.longitude!);
              print("Location : $_current");
              print("Location : $pos");
              print(polylineCoordinates);
              if(isRouting) {
                reFocus(_current!);
              }
            });
          }
        });
      }
    }
  }

  Future<void> customMarkerImages() async {
    markerIcon=BitmapDescriptor.defaultMarker;
    await BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/images/petPic.ico").then((icon) {
      markerIcon=icon;
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getPolyPoints();
          isRouting = true;
        },
        child: Icon(Icons.route),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: pos,
              zoom: 13,
            ),
            polylines: {
              if (isRouting)
                Polyline(
                  polylineId: PolylineId("Route"),
                  points: polylineCoordinates,
                  color: Colors.blue,
                  width: 6,
                ),
            },
            markers: {
              Marker(
                markerId: MarkerId("Pet"),
                position: pos,
                icon: markerIcon,
              ),
            },
            onMapCreated: (GoogleMapController controller) {
              // Do something with the controller if needed
              _MapController.complete(controller);
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance.collection("PetData").get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No pets found.'));
                  }
                  var items = snapshot.data!.docs.map((doc) => doc.id).toList();
                  String? dropdownValue = items.first;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                          DocumentSnapshot<Map<String, dynamic>> selectedDoc =
                          snapshot.data!.docs.firstWhere((doc) => doc.id == newValue) as DocumentSnapshot<Map<String, dynamic>>;
                          pos = LatLng(
                            selectedDoc.data()?['Lat'] as double? ?? 0.0,
                            selectedDoc.data()?['Long'] as double? ?? 0.0,
                          );
                          polylineCoordinates=[];
                          isRouting=false;
                        });
                      },
                      items: items.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void getPolyPoints() async {
    polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        APIKEY,
        PointLatLng(pos.latitude, pos.longitude),
        PointLatLng(pos.latitude + 0.03, pos.longitude),
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

  Future<void> reFocus(LatLng position) async {
    final GoogleMapController controller = await _MapController.future;
    CameraPosition newCameraPostion =
    CameraPosition(target: position, zoom: 13);
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(newCameraPostion));
  }
}
