import 'package:flutter/material.dart';
import 'reusable_widgets.dart';

class AboutPage extends StatefulWidget {
  AboutPage({required Key key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ReusableWidgets.getAppBar("About Us"),
        drawer: ReusableWidgets.getDrawer(context),
        body: Center(
          child: Text("About Page"),
        ));
  }
}
