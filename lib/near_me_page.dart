import 'dart:collection';

import 'package:flutter/material.dart';
import 'reusable_widgets.dart';
import 'global_state.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'loading_dialog.dart';

class NearMePage extends StatefulWidget {
  NearMePage({required Key key}) : super(key: key);

  @override
  _NearMePageState createState() => _NearMePageState();
}

final GlobalKey<State> _keyLoader = new GlobalKey<State>();

class _NearMePageState extends State<NearMePage> {
  GoogleMapController mapController;
  double _sliderValue = 0.0;
  static double _origZoomLevel = 14.4746;
  static double _zoomLevel = _origZoomLevel;

  // pre defined messages for chat
  var _messages = [
    'I need help with grocery',
    'Need to run some errands',
    'Can you please pickup medicine from pharmacy?',
    'Need a ride to doctor\'s office'
  ];
  var _selectedMessage;

  Firestore firestore = Firestore.instance;
  Geoflutterfire geo = Geoflutterfire();
  //BehaviorSubject<double> radius = BehaviorSubject(seedValue: 100.0);

  static final CameraPosition _initialPos = CameraPosition(
    //target: LatLng(37.326294, -121.797924),
    target:
        LatLng(GlobalState.position.latitude, GlobalState.position.longitude),
    zoom: _zoomLevel,
  );

// we will populate this markers set with information retrieved from firestore
  Set<Marker> _markers = {};
  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  _findOthers() async {
    print("Finding others nearby");
    // we will get locations from firestore and add here
    // TOSA: 37.323925, -121.795182
    // CVS: 37.316348, -121.791566
    // Lee's Sandwich 37.314744, -121.790225
    // Jubilee church: 37.320290, -121.787082
    Marker tosa = Marker(
        markerId: MarkerId('tosa'), position: LatLng(37.323925, -121.795182));

    //Get the locations from Firebase
    // limit to same zip as current user
    DocumentReference docRefLocation =
        Firestore.instance.collection("locations").document(GlobalState.uid);

    var zip;
    await docRefLocation.get().then((locDataSnapshot) {
      if (locDataSnapshot.exists) {
        print("USER Location:" + locDataSnapshot.data.toString());

        zip = locDataSnapshot.data['zip'];
        print('User location zip is:' + zip);
      } else {
        print("Error: User does not have location?");
      }
    });

    // find all other locations in this zip
    Map<dynamic, Map<String, dynamic>> userInfo;
    Map<String, dynamic> userLocationMap = HashMap<String, dynamic>();
    Map<String, dynamic> userProfileMap = HashMap<String, dynamic>();

    Set<Marker> markers = {};
    List<String> userIds = [];

    /** 
     * print("Calling all locations within zip " + zip);
    await Firestore.instance
        .collection("locations")
        .where("zip", isEqualTo: zip)
        .getDocuments()
        .then((qsnapshot) {
      List<DocumentSnapshot> docs = qsnapshot.documents;
      if (docs != null) {
        for (var doc in docs) {
          userIds.add(doc.data['id']);
          var gp = doc.data['location']['geopoint'];
          userLocationMap[doc.data['id']] = LatLng(
              gp.latitude, gp.longitude); //doc.data['location']['geopoint'];
        }
      }
    });
    **/
    // Get all locations
    print('Getting all locations');
    await Firestore.instance
        .collection("locations")
        .getDocuments()
        .then((qsnapshot) {
      print(qsnapshot);
      List<DocumentSnapshot> docs = qsnapshot.documents;
      print(docs.length);
      for (var doc in docs) {
        userIds.add(doc.data['id']);
        var gp = doc.data['location']['geopoint'];
        userLocationMap[doc.data['id']] = LatLng(
            gp.latitude, gp.longitude); //doc.data['location']['geopoint'];
      }
    });

    // get all profilesprint("Calling all locations within zip");
    print("Calling all profiles within zip " + userIds.toString());
    await Firestore.instance
        .collection("profiles")
        .where("uid", whereIn: userIds)
        .getDocuments()
        .then((psnapshot) {
      List<DocumentSnapshot> profiles = psnapshot.documents;
      for (var profile in profiles) {
        userProfileMap[profile['id']] = profile;
      }
    });

    // create maerkers
    for (var mid in userIds) {
      //GeoPoint geoPoint = userLocationMap[mid];
      LatLng latLng = userLocationMap[mid];
      var customIcon = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(devicePixelRatio: 2.5, size: Size(128, 128)),
          'assets/helping_hand_map_marker-128.png');
      if (Platform.isIOS) {
        customIcon = await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.5, size: Size(128, 128)),
            'assets/helping_hand_map_marker-48.png');
      }
      if (mid == GlobalState.uid && !userProfileMap[mid]['volunteer']) {
        // keep it to purple
        customIcon =
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      } else if (userProfileMap[mid]['volunteer']) {
        //customIcon =
        //BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      } else {
        if (mid != GlobalState.uid) {
          customIcon =
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
        }
      }

      Marker marker = Marker(
          icon: customIcon,
          markerId: MarkerId(mid),
          position: latLng,
          infoWindow: InfoWindow(
              onTap: () {
                print("Infowindow tapped " + userProfileMap[mid]['name']);
                _showSendMessageDialog(context, userProfileMap, mid);
              },
              title: userProfileMap[mid]['name'],
              snippet: userProfileMap[mid]['email']));

      markers.add(marker);
    }

    setState(() {
      _markers = markers;
    });
  }

  TextEditingController messageController = new TextEditingController(text: '');

  Future<String> _sendMessage(String message, String senderId,
      String receiverId, String senderName, String receiverName) async {
    print("Sending message");
    var messageData = {
      "senderId": senderId,
      "receiverId": receiverId,
      "message": message,
      "senderName": senderName,
      "receiverName": receiverName,
      "timestamp": Timestamp.now()
    };
    print("Sending DB message to FireBase " + DateTime.now().toString());
    Firestore.instance.collection('messages').document().setData(messageData);
    print("Inserted message " + DateTime.now().toString());
    return "Message sent";
  }

  _showSendMessageDialog(
      BuildContext context, Map<String, dynamic> userProfileMap, String mid) {
    print("showSendMessageDialog..");
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.mail,
                            color: Colors.purple[900], size: 48.0),
                        title: Text('Sending message to'),
                        subtitle: Text(userProfileMap[mid]['name']),
                      ),
                    ),
                    TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: 'Type a Message'),
                    ),
                    OverflowBar(
                      alignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 120,
                          child: GestureDetector(
                              onTap: () {
                                _handleMessageSubmit(
                                    context,
                                    messageController.text,
                                    GlobalState.uid,
                                    userProfileMap[mid]['uid'],
                                    GlobalState.profile['name'],
                                    userProfileMap[mid]['name']);
                              },
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text('Send'),
                                color: Colors.purple[900],
                                textColor: Colors.white,
                                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                splashColor: Colors.grey,
                              )),
                        ),
                        SizedBox(
                            width: 120,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text('Cancel'),
                              onPressed: () {
                                //Navigator.of(context).pushNamed('/signin');
                                Navigator.pop(context);
                              },
                              color: Colors.purple[500],
                              textColor: Colors.white,
                              padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                              splashColor: Colors.grey,
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<void> _handleMessageSubmit(
      BuildContext context,
      String message,
      String senderUid,
      String receiverUid,
      String senderName,
      String receiverName) async {
    print("_handleMessageSubmit...");
    Dialogs.showLoadingDialog(
        context, _keyLoader, 'Sending Message..'); //invoking login
    await _sendMessage(messageController.text, senderUid, receiverUid,
        senderName, receiverName);
    Navigator.of(context, rootNavigator: true).pop(); //close the dialoge
    //Navigator.pushReplacementNamed(context, "/nearme");
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    print('GlobalProfileState ' + GlobalState.profile.toString());
    return Scaffold(
        appBar: ReusableWidgets.getAppBar("Near Me"),
        drawer: ReusableWidgets.getDrawer(context),
        body: Stack(children: [
          GoogleMap(
              initialCameraPosition: _initialPos,
              onMapCreated: _onMapCreated,
              markers: _markers,
              myLocationEnabled:
                  true, // Add little blue dot for device location, requires permission from user
              mapType: MapType.normal),
          Positioned(
              bottom: 120,
              right: 10,
              child: ClipOval(
                child: Material(
                  color: Colors.purple[100], // button color
                  child: InkWell(
                    splashColor: Colors.purple[200], // inkwell color
                    child: SizedBox(
                        width: 56,
                        height: 56,
                        child: Icon(
                          Icons.search,
                          color: Colors.purple[700],
                        )),
                    onTap: () => _findOthers(),
                  ),
                ),
              )),
          Positioned(
            bottom: 50,
            left: 10,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.purple[700],
                inactiveTrackColor: Colors.purple[100],
                trackShape: RoundedRectSliderTrackShape(),
                trackHeight: 4.0,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                thumbColor: Colors.purple[900],
                overlayColor: Colors.purple,
                overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                tickMarkShape: RoundSliderTickMarkShape(),
                activeTickMarkColor: Colors.purple[700],
                inactiveTickMarkColor: Colors.purple[100],
                valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                valueIndicatorColor: Colors.deepPurple,
                valueIndicatorTextStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
              child: Slider(
                value: _sliderValue,
                min: 0,
                max: 50,
                divisions: 10,
                label: '$_sliderValue',
                onChanged: _updateSlider,
              ),
            ),
          )
        ]));
  }

  _updateSlider(value) {
    setState(() {
      _sliderValue = value;
      _zoomLevel = _origZoomLevel + (value / 4.0);
    });
    print('Slider changed ' +
        value.toString() +
        ' zoom=' +
        _zoomLevel.toString());
  }
}
