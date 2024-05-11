import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_care/petDetails.dart';

import 'apiKey.dart';

class trackingPetDynamic extends StatefulWidget {
  final String email;

  const trackingPetDynamic({Key? key, required this.email}) : super(key: key);

  @override
  _TrackingPetDynamicState createState() => _TrackingPetDynamicState();
}

class _TrackingPetDynamicState extends State<trackingPetDynamic> {
  String? dropdownValue;
  late List<String> items = [];
  late QuerySnapshot<Map<String, dynamic>> querySnapshot;
  String photoUrl = "";
  LatLng pos = LatLng(31.5607552, 74.378948);
  List<LatLng> polylineCoordinates = [];
  bool isRouting = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      querySnapshot = await FirebaseFirestore.instance
          .collection(widget.email)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Your Pets'),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: dropdownValue,
              onChanged: (String? newValue) async {
                setState(() {
                  dropdownValue = newValue!;
                });

                try {
                  DocumentSnapshot<Map<String, dynamic>> selectedDoc =
                  await FirebaseFirestore.instance
                      .collection("PetData")
                      .doc(newValue)
                      .get();

                  if (selectedDoc.exists) {
                    setState(() {
                      photoUrl = selectedDoc.data()?['Photo'] ?? "";
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
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                isRouting = true;
                getPolyPoints();
              },
              child: Text('Start Routing'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Stack(
                children: [
                  GoogleMap(
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
                        icon: BitmapDescriptor.defaultMarker,
                      ),
                    },
                  ),
                ],
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
}
