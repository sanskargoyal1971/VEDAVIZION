import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vedavision/homepage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    Timer(Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    Timer(Duration(seconds: 3), () {
      setState(() {
        _opacity = 0.0;
      });

      Timer(Duration(milliseconds: 800), () {
        Navigator.of(context).pushReplacement(_createFadeRoute());
      });
    });
  }

  Route _createFadeRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          PlantIdentificationPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration:
          Duration(milliseconds: 800), // Duration of the fade-in
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3e6606), // Background color
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: Duration(milliseconds: 800),
          child: Image.asset(
            'assets/logo.png', // Make sure this asset exists
            width: 250,
            height: 250,
          ),
        ),
      ),
    );
  }
}
