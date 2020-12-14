import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'clientList.dart';
import 'loginPage.dart';
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
    home: username == null ? LoginPage() : ClientList(volId: id, volName: name),
    )
  );
}