import 'package:flutter/material.dart';
import 'reusable_widgets.dart';
import 'firebase_auth.dart';
import 'loading_dialog.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

final GlobalKey<State> _keyLoader = new GlobalKey<State>();

class _SignInPageState extends State<SignInPage> {
  final child = FlatButton(
    child: const Text('Signin Page'),
    onPressed: () {/* ... */},
    textColor: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableWidgets.getAppBar('Sign In'),
      //drawer: ReusableWidgets.getDrawer(context),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/helping_hand_logo.png'),
              SizedBox(height: 50),
              GestureDetector(
                  onTap: () {
                    _handleSubmit(context);
                  },
                  child: _signInButton()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit(BuildContext context) async {
    try {
      Dialogs.showLoadingDialog(
          context, _keyLoader, 'Signing you in...'); //invoking login
      await signInWithGoogle();
      Navigator.of(_keyLoader.currentContext, rootNavigator: true)
          .pop(); //close the dialoge
      Navigator.pushReplacementNamed(context, "/nearme");
    } catch (error) {
      print(error);
    }
  }
}
