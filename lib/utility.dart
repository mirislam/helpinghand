// An Utility class
import 'package:cloud_firestore/cloud_firestore.dart';
import 'global_state.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:location/location.dart';

class Utility {
  static void insertProfile(
      String uid, Map<String, dynamic> profileData) async {}

  static Future<Position> getCurrentLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    Position position;
    await geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position pos) {
      position = pos;
      print('Location gotten:' + position.toString());
    }).catchError((e) {
      print('Failed to get location ' + e.toString());
    });

    return position;
  }

  static Future<String> updateProfile(
      String uid, Map<String, dynamic> profileData) async {
    print('Utility.updateProfile ' + profileData.toString());
    if (profileData['location'] == null) {
      profileData['location'] = GlobalState.geoPoint;
    }
    String result = 'Profile has been updated..';
    String error = 'Error in updating';
    await Firestore.instance
        .collection('profiles')
        .document(uid)
        .setData(profileData)
        .catchError((e) {
      print('utility.updateProfile Error: ' + e.toString());
      result = 'Error in Updating:' + e.toString();
    }).then((result) {
      print('Updating profile successful');
    }).catchError((onError) {
      print('Updating profile failed');
    });
    print('Updating profile result:' + result);
    return result;
  }

  
}
