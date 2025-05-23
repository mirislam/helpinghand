import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GlobalState {
  static FirebaseAuth auth;
  static String uid;
  static FirebaseUser firebaseUser;
  static Map<String, dynamic> profile;
  static Position position;
  static GeoPoint geoPoint;
}
