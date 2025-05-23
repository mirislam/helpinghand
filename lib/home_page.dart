import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 98.0,
        child: Image.asset('assets/helping_hand_logo.png'),
      ),
    );

    final dashButton = RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text('DASHBOARD'),
      onPressed: () {
        Navigator.of(context).pushNamed('/dashboard');
      },
      color: Colors.purple[100],
      textColor: Colors.white,
      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      splashColor: Colors.grey,
    );
    final infoCard = Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.help),
              title: Text('Angel in the Neighborhood'),
              subtitle: Text(
                  'Help your elderly neighbors and friends at the time of their needs. During Covid-19 crisis they can not visit grocery or other public spaces without exposing themselves to risk of getting infected.' +
                      ' Connect locally and close to you. Sign up as volunteer or as someone ' +
                      'who could use some help from friends.'),
            ),
            OverflowBar(
              children: <Widget>[
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('REGISTER'),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/register');
                  },
                  color: Colors.purple[900],
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  splashColor: Colors.grey,
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('SIGN IN'),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/signin');
                  },
                  color: Colors.purple[500],
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  splashColor: Colors.grey,
                ),
                dashButton,
              ],
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[logo, SizedBox(height: 48.0), infoCard],
        ),
      ),
    );
  }
}
