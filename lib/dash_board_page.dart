import 'dart:async';

import 'package:flutter/material.dart';
import 'reusable_widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'global_state.dart';

class DashBoardPage extends StatefulWidget {
  DashBoardPage({required Key key}) : super(key: key);

  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;
var currentUser = "not defined";
getUser() async {
  currentUser = _auth.currentUser != null
      ? _auth.currentUser!.toString()
      : "No user logged in";
  print('Current User in Async:' + currentUser);
}

class _DashBoardPageState extends State<DashBoardPage> {
  final regText = Text('Reg Text');
  final phoneText = Text('Phone Text');

  late Position _currentPosition;

  // test locations
  // Walgreens on white 37.326294, -121.797924
  CameraPosition _initialPos = CameraPosition(
    target: LatLng(37.326294, -121.797924),
    zoom: 14.4746,
  );

  LatLng _lastMapPosition = LatLng(37.326294, -121.797924);
  // markers to show on the map
  final Set<Marker> _markers = {};
  Marker initialMarker = Marker(
      markerId: MarkerId('walgreens'),
      position: LatLng(37.326294, -121.797924));

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  Completer<GoogleMapController> _controller = Completer();

  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator();

    geolocator
        // ignore: deprecated_member_use
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        // add marker
        _markers.add(Marker(
          // This marker id can be anything that uniquely identifies each marker.
          markerId: MarkerId('Random ID'),
          position: _lastMapPosition,
          infoWindow: InfoWindow(
            title: 'Really cool place',
            snippet: '5 Star Rating',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ));
      });
    }).catchError((e) {
      print(e);
    });

    //update in firestore with latest location
  }

  @override
  Widget build(BuildContext context) {
    getUser();
    return Scaffold(
      appBar: ReusableWidgets.getAppBar("Dashboard"),
      drawer: ReusableWidgets.getDrawer(context),
      body: Center(
        child: Column(
          //shrinkWrap: true,
          //padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            regText,
            phoneText,
            Text("AuthUser: " + GlobalState.uid),
            //if (_currentPosition != null)
            Text(
                "LAT: ${_currentPosition.latitude}, LNG: ${_currentPosition.longitude}"),
            TextButton(
              child: Text("Get location"),
              onPressed: () {
                _getCurrentLocation();
              },
            ),
            Expanded(
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _initialPos,
                markers: _markers,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
