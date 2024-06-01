import 'dart:async';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pet_care/DataBase.dart';
import 'package:pet_care/apiKey.dart';
import 'package:pet_care/uihelper.dart';

class trackingPetSolo extends StatefulWidget {

  Map<String,dynamic> petData;
  String email;
  trackingPetSolo({super.key,required this.petData,required this.email});

  @override
  State<trackingPetSolo> createState() => _trackingPetSoloState();
}

class _trackingPetSoloState extends State<trackingPetSolo> {

  late Map<String, dynamic> querySnapshot;


  Location _locationController = Location();
  String title = "",subtitle="";

  LatLng? _current;
  LatLng pos = LatLng(31.5607552, 74.378948);

  final Completer<GoogleMapController> _MapController =
  Completer<GoogleMapController>();

  bool isRouting=false;


  List<LatLng> polylineCoordinates = [];


  List<Marker> _marker = <Marker>[];

  String picPath = "https://firebasestorage.googleapis.com/v0/b/pettify-96749.appspot.com/o/PetPics%2F2ytt5qm8zpkl?alt=media&token=598ba9b9-36a9-448b-a690-e8f03508e8ac";

  Uint8List? markerImage;

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
    // customMarker(LatLng(31.5607552, 74.378948));
    customMarkerImages();
    customMarkerBytes();
    getPolyPoints();
    fetchLocation();
    setData();
  }


  Future<void> fetchLocation() async {
    try {
      print(widget.email);
      print(widget.petData["Email"]);
      querySnapshot = await DataBase.readData(widget.email, widget.petData["Email"]);

      if (querySnapshot.isNotEmpty) {
        setState(() {
          pos=LatLng(querySnapshot["LAT"],querySnapshot["LONG"]);
          title=querySnapshot["Name"];
          subtitle=querySnapshot["oneLine"];
          uiHelper.customAlertBox(() { }, context, "title: $title subtitle $subtitle");
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  setData(){
    title=widget.petData["Name"];
    subtitle=widget.petData["oneLine"];
    pos=LatLng(widget.petData["LAT"],widget.petData["LONG"]);
    picPath=widget.petData["Photo"];

  }


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
              fetchLocation();
              // pos=LatLng(pos.latitude  +  0.0000052, pos.longitude +  0.000058) ;
              print("Location : $_current");
              print("Location : $pos");
              print("Title : $title");
              print("Subtitle : $subtitle");
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
                  // Marker(
                  //   markerId: MarkerId("Id2"),
                  //   position: LatLng(pos.latitude+0.03,pos.longitude),
                  //   infoWindow: InfoWindow(
                  //     title: title,
                  //     snippet: "Snipped of API2",
                  //   ),
                  // ),
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
                child: ListTile(
                  title: Text(title),
                  subtitle: Text(subtitle),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage:  NetworkImage(picPath),
                    backgroundColor: Colors.white70,
                  ),
                )
              ),
            ),
          ),
        ]),
      ),
    );
  }
}