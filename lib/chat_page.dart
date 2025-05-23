import 'package:flutter/material.dart';
import 'reusable_widgets.dart';

class ChatPage extends StatefulWidget {
  ChatPage({required Key key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ReusableWidgets.getAppBar("Chat"),
        drawer: ReusableWidgets.getDrawer(context),
        body: Center(
          child: Text("Chat Page"),
        ));
  }
}
