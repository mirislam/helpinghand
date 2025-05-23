import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helping_hands/utility.dart';
import 'global_state.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  var userInfo = authResult.additionalUserInfo.profile;
  print('FireBase User: ' + userInfo.toString());

//save it as global variables
  GlobalState.uid = user.uid;

//get location data
  Position position = await Utility.getCurrentLocation();
  Geoflutterfire geo = Geoflutterfire();

  List<Placemark> placemarks = await Geolocator()
      .placemarkFromCoordinates(position.latitude, position.longitude);
  var postalCode = placemarks[0].postalCode;

  // cache the state
  GlobalState.position = position;
  GlobalState.geoPoint = GeoPoint(position.latitude, position.longitude);
  final GeoPoint geoPoint = GeoPoint(position.latitude, position.longitude);

  DocumentReference docRef =
      Firestore.instance.collection("profiles").document(user.uid);
  var data;
  await docRef.get().then((dataSnapshot) {
    if (dataSnapshot.exists) {
      print("USER Profile:" + dataSnapshot.data.toString());
      GlobalState.profile = dataSnapshot.data;

      data = dataSnapshot.data['email'];
      print('User already has a profile:' + data);
    } else {
      print("User does not have a profile");
      var profileData = {
        "id": user.uid,
        "uid": user.uid,
        "name": userInfo['name'],
        "email": userInfo['email'],
        "zip": postalCode,
        "phone": '',
        "volunteer": false
      };
      GlobalState.profile = profileData;
    }
  });

  GeoFirePoint point =
      geo.point(latitude: position.latitude, longitude: position.longitude);
  var locationData = {
    "id": user.uid,
    "location": point.data,
    "zip": postalCode,
    "timestamp": Timestamp.now()
  };
  Firestore.instance
      .collection('locations')
      .document(user.uid)
      .setData(locationData);

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  return 'signInWithGoogle succeeded: $user';
}

void signOutGoogle() async {
  await googleSignIn.signOut();

  print("User Sign Out");
}
