import 'package:flutter/material.dart';
import 'reusable_widgets.dart';

class ValidatePhonePage extends StatefulWidget {
  ValidatePhonePage({Key key}) : super(key: key);

  @override
  _ValidatePhonePageState createState() => _ValidatePhonePageState();
}

class _ValidatePhonePageState extends State<ValidatePhonePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ReusableWidgets.getAppBar("Validate Phone"),
        drawer: ReusableWidgets.getDrawer(context),
        body: Center(
          child: Text("Validae Phone"),
        ));
  }
}