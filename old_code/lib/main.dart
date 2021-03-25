import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main_page.dart';
import 'niceLogin.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var username = prefs.getString('username');
  var id  = prefs.getInt('id');
  var name = prefs.getString('name');

  runApp(MaterialApp(
    title: "Montgomery Country Food Bank Meal Delivery",
    theme: ThemeData(
        primarySwatch: Colors.blue
    ),
    home: username == null ? LoginScreen() : J(vid: id, vName: name),
    )
  );
}