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
            child: Align(alignment: Alignment.topCenter ,child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 25))),
            decoration: BoxDecoration(color: Color(0xFF33691E))
          ),
          Column(children: tiles,)
        ],
      ),
    );
  }
}