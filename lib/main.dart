import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'mainNav.dart';
import 'niceLogin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var username = prefs.getString('username');
  var id  = prefs.getInt('id');
  var name = prefs.getString('name');

  runApp(MaterialApp(
    title: "Montgomery Country Food Bank Meal Delivery",
    debugShowCheckedModeBanner: false,
    home: AnimatedSplashScreen(
        duration: 2500,
        splash: Image.asset('assets/mcfb_logo.png', height: 500, width: 500),
        nextScreen: username == null ? LoginScreen() : J(vid: id, vName: name),
        splashTransition: SplashTransition.fadeTransition,
      )
    )
  );
}