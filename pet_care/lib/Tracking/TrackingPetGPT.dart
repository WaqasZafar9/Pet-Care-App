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

class TrackingPetGPT extends StatefulWidget {
  final String email;

  const TrackingPetGPT({super.key, required this.email});

  @override
  State<TrackingPetGPT> createState() => _TrackingPetState();
}

class _TrackingPetState extends State<TrackingPetGPT> {
  Location _locationController = Location();
  LatLng? _current;
  LatLng pos = LatLng(31.5607552, 74.378948);
  List<LatLng> polylineCoordinates = [];
  bool isRouting = false;
  late BitmapDescriptor markerIcon;
  final Completer<GoogleMapController> _MapController = Completer<GoogleMapController>();
  String dropdownValue = '';
  List<String> items = [];
  Map<String, dynamic> petData = {};

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
    customMarkerImages();
    fetchPetData();
  }

  Future<void> fetchPetData() async {
    final snapshot = await FirebaseFirestore.instance.collection(widget.email).get();
    if (snapshot.docs.isNotEmpty) {
      setState(() {
        items = snapshot.docs.map((doc) => doc.id).toList();
        dropdownValue = items.first;
        updatePetPosition(snapshot.docs.first);
      });
    }
  }

  Future<void> updatePetPosition(DocumentSnapshot doc) async {
    setState(() {
      petData = doc.data() as Map<String, dynamic>;
      pos = LatLng(petData['Lat'] as double, petData['Long'] as double);
      polylineCoordinates = [];
      isRouting = false;
    });
  }

  Future<void> getLocationUpdates() async {
    bool serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    _locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        setState(() {
          _current = LatLng(currentLocation.latitude!, currentLocation.longitude!);
          if (isRouting) {
            reFocus(_current!);
          }
        });
      }
    });
  }

  Future<void> customMarkerImages() async {
    markerIcon = BitmapDescriptor.defaultMarker;
    markerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty,
        "assets/images/petPic.ico"
    );
  }

  Future<void> getPolyPoints() async {
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

  Future<void> reFocus(LatLng position) async {
    final GoogleMapController controller = await _MapController.future;
    CameraPosition newCameraPosition = CameraPosition(target: position, zoom: 13);
    await controller.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
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
                  isRouting = true;
                },
                icon: Icon(Icons.route),
                color: Colors.white,
                iconSize: 30,
                tooltip: 'Get Route',
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
                icon: Icon(Icons.person),
                color: Colors.white,
                iconSize: 30,
                tooltip: 'Refocus on Current Location',
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Color.fromRGBO(10, 111, 112, 0.3)),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                reFocus(pos);
              },
              icon: FaIcon(FontAwesomeIcons.amazonPay),
              color: Colors.white,
              iconSize: 30,
              tooltip: 'Refocus on Pet Location',
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Color.fromRGBO(10, 111, 112, 0.3)),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          _current == null
              ? Center(child: CircularProgressIndicator())
              : GoogleMap(
            myLocationEnabled: true,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              _MapController.complete(controller);
            },
            initialCameraPosition: CameraPosition(target: _current!, zoom: 13),
            polylines: {
              if (isRouting)
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
                markerId: MarkerId("Pet"),
                icon: markerIcon,
                position: pos,
                infoWindow: InfoWindow(
                  title: petData['Name'] ?? 'Pet',
                  snippet: "Current Location",
                ),
              ),
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
                future: FirebaseFirestore.instance.collection(widget.email).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No pets found.'));
                  }
                  var items = snapshot.data!.docs.map((doc) => doc.id).toList();
                  String dropdownValue = items.first;

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
}
