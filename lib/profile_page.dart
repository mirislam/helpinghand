import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'reusable_widgets.dart';
import 'global_state.dart';
import 'utility.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController emailController =
      new TextEditingController(text: GlobalState.profile['email']);
  TextEditingController phoneController =
      new TextEditingController(text: GlobalState.profile['phone']);
  TextEditingController nameController =
      new TextEditingController(text: GlobalState.profile['name']);
  String _profileUpdateMessage = '';
  bool isSwitched = false;

  String _updateText = 'Profile Updated Successfully';
  bool _updateProfileCardVisible = false;
  Icon _updateIcon = Icon(Icons.info, color: Colors.green[400], size: 28.0);

  void _updateProfile(BuildContext context) {
    print('Updating profile');
    var profileData = {
      "id": GlobalState.uid,
      "uid": GlobalState.uid,
      "name": nameController.text,
      "email": emailController.text,
      "zip": '12345',
      "phone": phoneController.text,
      "volunteer": true,
      "timestamp": Timestamp.now(),
      "location:": GlobalState.position,
    };

    _profileUpdateMessage = "Updating profile please wait..";
    Utility.updateProfile(GlobalState.uid, profileData).then((String result) {
      setState(() {
        print('Result from update:' + result);
        _profileUpdateMessage = result;
        _updateProfileCardVisible = true;
      });
    }).catchError((e) {
      print('Error in profile_page update ' + e.toString());
      print(e);
      setState(() {
        _updateIcon = Icon(Icons.error, color: Colors.red, size: 28.0);
        _profileUpdateMessage = 'Error:' + e.toString();
        _updateProfileCardVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print('ProfileInfo1:' + GlobalState.profile.toString());
    final email = Padding(
        padding: EdgeInsets.all(10.0),
        child: TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Your Email',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
        ));

    final profileUpdateCard = Padding(
        padding: EdgeInsets.all(10.0),
        child: Visibility(
            visible: _updateProfileCardVisible,
            child: Center(
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: _updateIcon,
                      //Image.asset('assets/mobile_pass.jpg'),
                      title: Text(_updateText),
                    ),
                  ],
                ),
              ),
            )));

    final phone = Padding(
        padding: EdgeInsets.all(10.0),
        child: TextFormField(
          controller: phoneController,
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: '+1 408 555 1212',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
        ));

    final name = Padding(
        padding: EdgeInsets.all(10.0),
        child: TextFormField(
          controller: nameController,
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'John Brown',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
        ));

    
    final volunteer = Padding(
        padding: EdgeInsets.only(bottom: 10.0),
        child: Row(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text("Will you be a Volunteer? ")),
            Switch(
              value: isSwitched,
              onChanged: (value) {
                setState(() {
                  isSwitched = value;
                  print(isSwitched);
                });
              },
              activeTrackColor: Colors.purpleAccent,
              activeColor: Colors.purple[900],
            ),
          ],
        ));

    final validatePhone = Padding(
        padding: EdgeInsets.only(bottom: 10.0),
        child: Row(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text("Validate phone number using SMS? ")),
            Icon(Icons.check)
          ],
        ));

    final profileCard = Padding(
        padding: EdgeInsets.only(bottom: 50.0),
        child: Center(
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.account_circle,
                      color: Colors.purple[900], size: 48.0),
                  //Image.asset('assets/mobile_pass.jpg'),
                  title: Text('Update Your Profile Information'),
                  subtitle: Text(
                      'If you like to be a volunteer on this platform and help lederly neighbors, please check box below.'),
                ),
                name,
                phone,
                email,
                volunteer,
              ],
            ),
          ),
        ));

    final submitButton = RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text('Update'),
      onPressed: () {
        _updateProfile(context);
        //Navigator.of(context).pushNamed('/register');
      },
      color: Colors.purple[900],
      textColor: Colors.white,
      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      splashColor: Colors.grey,
    );

    return Scaffold(
      appBar: ReusableWidgets.getAppBar("Profile"),
      drawer: ReusableWidgets.getDrawer(context),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
          children: <Widget>[profileCard, submitButton, profileUpdateCard],
        ),
      ),
    );
  }
}
