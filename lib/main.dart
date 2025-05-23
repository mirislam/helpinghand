import 'package:flutter/material.dart';
import 'package:helping_hands/near_me_page.dart';
import 'home_page.dart';
import 'dash_board_page.dart';
import 'register_page.dart';
import 'signin_page.dart';
import 'profile_page.dart';
import 'about_page.dart';
import 'messages_page.dart';
import 'validate_phone_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData.light(),
      //home: LoginPage(),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/register': (context) => RegisterPage(),
        '/signin': (context) => SignInPage(),
        '/dashboard': (context) => DashBoardPage(),
        '/profile': (context) => ProfilePage(),
        '/about': (context) => AboutPage(),
        '/nearme': (context) => NearMePage(),
        '/signout': (context) => DashBoardPage(),
        '/messages': (context) => MessagesPage(),
        '/validatephone': (context) => ValidatePhonePage(),
        
      },
      
    );

  }
  
}

