import 'package:flutter/material.dart';
import "navDrawer.dart";
import 'clientList.dart';
import 'myClients.dart';
import 'niceLogin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class J extends StatefulWidget {
  final String vName;
  final int vid;
  J({Key key, this.vName, this.vid}) : super(key: key);

  final drawerFragments = [
    //new DrawerItem("Home Page", Icons.house),
    new DrawerItem("Client List", Icons.shopping_bag),
    new DrawerItem("My Clients", Icons.people_alt_rounded),
    new DrawerItem("Logout", Icons.logout),
  ];

  @override
  _JState createState() => _JState(vName, vid);
}

class _JState extends State<J>{
  final String name;
  final int id;
  _JState(this.name, this.id);

  int _selectedDrawerFragmentIndex = 0;

  _getDrawerFragmentWidgetIndex(int pos) {
    if (widget.drawerFragments[pos] != null) {
      if (widget.drawerFragments[pos].title == "Client List") {
        return ClientList(
          volName: name,
          volId: id,
        );
      } else if (widget.drawerFragments[pos].title == "My Clients") {
        return MyClients(
          id: id,
        );
      } else {
        return LoginScreen();
      }
    } else {
      return Text("Error");
    }
  }

  _onSelectFragment(int index) {
    setState(() => _selectedDrawerFragmentIndex = index);
    Navigator.of(context).pop();
  }

  Future<SharedPreferences> _getSharedPrefs() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];

    for (var i = 0; i < widget.drawerFragments.length; i++) {
      var d = widget.drawerFragments[i];
      drawerOptions.add(
          new ListTile(
            leading: new Icon(d.icon),
            title: new Text(d.title),
            selected: i == _selectedDrawerFragmentIndex,
            onTap: () => _onSelectFragment(i),
          )
      );
    }

    if (_selectedDrawerFragmentIndex != 2) {
      return Scaffold(
          drawer: NavDrawer(drawerOptions),
          appBar: AppBar(
            backgroundColor: Color(0xFF33691E),
            centerTitle: true,
            title: Text(
                widget.drawerFragments[_selectedDrawerFragmentIndex].title),
          ),
          body: _getDrawerFragmentWidgetIndex(_selectedDrawerFragmentIndex)
      );
    } else {
      Future<SharedPreferences> prefs = _getSharedPrefs();
      prefs.then((value) {
        if (value.getString('username') != null){
          value.remove('username');
          value.remove('password');
          value.remove('name');
          value.remove('id');
        }
      });
      return LoginScreen();
    }
  }
}