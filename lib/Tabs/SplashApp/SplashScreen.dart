import 'dart:async';
import 'package:flutter/material.dart';
import 'package:storesalephone/Tabs/Account/Login/login_page.dart';

class SplashScreenApp extends StatefulWidget {
  @override
  _SplashScreenAppState createState() => _SplashScreenAppState();
}

class _SplashScreenAppState extends State<SplashScreenApp> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 2),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => LoginPage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3739aF),
      body: Center(
        child: Image.asset('assets/SplashFullScreen.gif'),
      ),
    );
  }
}
