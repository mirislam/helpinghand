import 'package:flutter/material.dart';
import 'reusable_widgets.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ReusableWidgets.getAppBar("Dashboard"),
        drawer: ReusableWidgets.getDrawer(context),
        body: Center(
          child: Text("Profile Page"),
        ));
  }
}
