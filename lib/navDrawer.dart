import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget {
  List<Widget> tiles;
  NavDrawer(this.tiles);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Side Bar', style: TextStyle(color: Colors.black, fontSize: 25)),
            decoration: BoxDecoration(color: Colors.green)
          ),
          Column(children: tiles,)
        ],
      ),
    );
  }
}