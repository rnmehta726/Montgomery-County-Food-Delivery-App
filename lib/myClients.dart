import 'package:flutter/material.dart';

class MyClients extends StatefulWidget {
  final List<String> clients;
  MyClients({Key key, this.clients}) : super(key: key);
  @override
  _MyClientsState createState() => _MyClientsState(saved: clients);
}

class _MyClientsState extends State<MyClients> {
  final saved;
  _MyClientsState({this.saved});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Clients'),
        centerTitle: true,
      ),
      body: _list(),
    );
  }

  Widget _list() {
    return ListView.builder(
        itemCount: saved.length == null ? 0 : saved.length,
        padding: EdgeInsets.only(top: 7),
        itemBuilder: (BuildContext context, int index) {
          return row(context, index);
        }
    );
  }

  Widget row(context, index) {
    return Padding(
        key: Key(saved[index]),
        padding: EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
        child: Dismissible(
          key: Key(saved[index]),
          onDismissed: (direction) {
            final String name = saved[index];
            setState(() {
              saved.remove(name);
            });
            if (direction == DismissDirection.endToStart) {
              Navigator.pop(context, name);
            }
          },
          secondaryBackground: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.red,
              ),
              child: const Icon(Icons.delete_sharp, color: Colors.white)),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: ListTile(title: Text(saved[index], style: TextStyle(fontSize: 18))),
          ),
          background: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                color: Colors.green,
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding: EdgeInsets.only(left: 10.0),
              alignment: Alignment.centerLeft,
              child: Icon(Icons.check, color: Colors.white)),
        )
    );
  }
}