import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map_live/onboarding.dart';
import 'package:google_map_live/signin4.dart';
import 'package:google_map_live/wrapper.dart';
import 'dart:math' as Math;

class Spash extends StatefulWidget {
  const Spash({Key key}) : super(key: key);

  @override
  _SpashState createState() => _SpashState();
}

class _SpashState extends State<Spash> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  int _current = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    animation = Tween<double>(begin: 0, end: 2).animate(controller)
      ..addListener(() {
        setState(() {
          controller.forward();
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          print("Ok");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Wrapperr()));
        } else {
          controller?.forward();
        }
      });

    controller?.forward();
      SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
       DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,

  ]);
  }



  @override
  void dispose() {
     SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
    super.dispose();
  }


  bool showFront = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Transform.rotate(
          alignment: FractionalOffset.center,
          angle: 360 * pi / 180,
          child: Image(
              height: double.infinity,
              width: double.infinity,
              image: AssetImage(
                'assets/splash.png',
              )),
        )

        /*
        Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.blue,
      child: Transform.rotate(
        alignment: FractionalOffset.center,
        angle: 270 * pi / 180,
        child: Image.asset(
          'assets/atak_splash_new.png',
          // fit: BoxFit.cover,
        ),
      ),
    )

      body: Container(
        child: Transform(
          alignment: FractionalOffset.centerLeft,
          transform: Matrix4.rotationZ(
            3.1415926535897932 / 2,
          ),
          child: Container(
            color: Colors.blue,
            height: MediaQuery.of(context).size.height * 1,
            width: MediaQuery.of(context).size.width * 1,
            child: Image.asset(
              'assets/atak_splash_new.png',
            ),
          ),
        ),
      ),
      */
        );
  }
}
