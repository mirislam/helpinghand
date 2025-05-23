import 'package:flutter/material.dart';
import 'reusable_widgets.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();

  final regText = Padding(
      padding: EdgeInsets.only(bottom: 30.0),
      child: Text('Register With Us',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.purple[800],
              fontWeight: FontWeight.bold,
              fontSize: 40)));

  @override
  Widget build(BuildContext context) {
    final email = Padding(
        padding: EdgeInsets.only(bottom: 20.0),
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

    final phone = Padding(
        padding: EdgeInsets.only(bottom: 10.0),
        child: TextFormField(
          controller: emailController,
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
        padding: EdgeInsets.only(bottom: 10.0),
        child: TextFormField(
          controller: emailController,
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

    final phoneRegCard = Padding(
        padding: EdgeInsets.only(bottom: 50.0),
        child: Center(
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.perm_phone_msg,
                      color: Colors.purple[900], size: 48.0),
                  //Image.asset('assets/mobile_pass.jpg'),
                  title: Text('Register Using Your Phone Number'),
                  subtitle: Text(
                      'No password to remember. Each time you will get a code in SMS when you login'),
                ),
                name,
                phone,
                email
              ],
            ),
          ),
        ));

    final googleRegCard = Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: GestureDetector(
                  onTap: () {
                    print("Google log tapped/pressed");
                  },
                  child: Image.asset('assets/google_logo.png')),
              title: Text('Register Using Google Account'),
              subtitle: Text('You can use your Google account to join us'),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: ReusableWidgets.getAppBar("Registration"),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[regText, phoneRegCard, googleRegCard],
        ),
      ),
    );
  }
}
