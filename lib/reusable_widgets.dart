import 'package:flutter/material.dart';
import 'package:helping_hands/global_state.dart';
import 'about_page.dart';
import 'profile_page.dart';
import 'dash_board_page.dart';
import 'chat_page.dart';
import 'near_me_page.dart';
import 'messages_page.dart';

class ReusableWidgets {
  static getAppBar(String title) {
    return AppBar(
      title: Text(title),
      backgroundColor: Colors.purple[900],
    );
  }

  static getDrawer(BuildContext context) {
    print("GetDrawer Profile:" + GlobalState.profile.toString());
    print("GetDrawer uid:" + GlobalState.uid);
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.purple[900],
            ),
            accountName: GlobalState.uid == null
                ? Text("Not Logged in")
                : Text(GlobalState.profile['name']),
            accountEmail: GlobalState.uid == null
                ? Text("Not Logged in")
                : Text(GlobalState.profile['email']),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.purple[700],
              child: Text(
                GlobalState.profile['name'].toString().substring(0, 1),
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          ListTile(
            title: Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => ProfilePage()));
            },
          ),
          ListTile(
            title: Text('Near Me'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => NearMePage()));
            },
          ),
          ListTile(
            title: Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => DashBoardPage()));
            },
          ),
          ListTile(
            title: Text('Messages'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => MessagesPage()));
            },
          ),
          ListTile(
            title: Text('Chat'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => ChatPage()));
            },
          ),
          ListTile(
            title: Text('About Us'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => AboutPage()));
            },
          ),
        ],
      ),
    );
  }
}
