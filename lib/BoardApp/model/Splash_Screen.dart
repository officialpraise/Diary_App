import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../ui/login_screen.dart';

class SplashScreenAnimated extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(backgroundColor: Colors.pinkAccent,
        splash: SplashScreen(),
        nextScreen: LoginScreen (),
        splashTransition: SplashTransition.slideTransition,
        duration: 7000,
        splashIconSize: MediaQuery
            .of(context)
            .size
            .height);
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.pinkAccent,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              color: Colors.pinkAccent),
          height: 300,
          width: 300,
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("MY DIARY",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold)),
              SpinKitThreeBounce(color: Colors.white, size: 30)
            ],
          ),
        ),
      ),
    );
  }
}
