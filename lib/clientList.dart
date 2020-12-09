import 'package:flutter/material.dart';
import 'dart:async';
import 'record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'myClients.dart';

class ClientList extends StatefulWidget {
  final String volName;
  final int volId;
  ClientList({Key key, this.volName, this.volId}) : super(key: key);

  @override
  _ClientListState createState() => _ClientListState();
}

class _ClientListState extends State<ClientList> {
  final _saved = Set<String>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            centerTitle:true,
            title: Text("List of Clients"),
            actions: [
              IconButton(icon: Icon(Icons.list), onPressed:() {
                _scaffoldKey.currentState.hideCurrentSnackBar();
                _pushClients(context);
              }),
            ]
        ),
        body: _stream(context)
    );
  }

  Widget _stream(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.collection('baby').document('ABp6KzqnBppv2Qvkp6IW').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if(!snapshot.hasData) return LinearProgressIndicator();
          var firestoreData = snapshot.data.data;
          return _foodRecipients(context, firestoreData);
        }
    );
  }

  Widget _foodRecipients(BuildContext context, Map<String, dynamic> snapshot) {
    List<String> keys = snapshot.keys.toList();
    List<Map<String, dynamic>> values = [];

    for (var key in keys){
      values.add(new Map<String, dynamic>.from(snapshot[key]));
    }
    return ListView(
        padding: EdgeInsets.only(top: 15.0),
        children: values.map((data) => _buildRow(context, data, snapshot)).toList()
    );
  }

  Widget _buildRow(BuildContext context, Map<String, dynamic> document,  Map<String, dynamic> snapshot) {
    final record = Record.fromMap(document);
    var key = '';
    final alreadyTaken = _saved.contains(record.name);
    final name = record.name;
    final food = record.bags;

    for (var k in snapshot.keys.toList()){
      if (snapshot[k].toString() == document.toString()){
        key = k;
        break;
      }
    }

    return Padding(
      key: ValueKey(record.name),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
            title: Text(
                name, style: TextStyle(fontSize: 18)
            ),
            subtitle: Text(
                food.toString(), style:TextStyle(fontSize: 12)
            ),
            trailing: Icon(
              alreadyTaken ? Icons.add_box_sharp : Icons.add_box_outlined,
              color: alreadyTaken ? Colors.green : null,
            ),
            onTap: () {
              setState(() {
                _saved.add(name);
              });
              Timer(Duration(milliseconds: 150), (){
                showSnackBar(context, document, key);
                setState(() async{
                  await Firestore.instance.collection("baby").document('ABp6KzqnBppv2Qvkp6IW').updateData({key: FieldValue.delete()});
                });
              });
            }
        ),
      ),
    );
  }

  undoDelete(name, key) {
    setState(() async{
      _saved.remove(name['name']);
      await Firestore.instance.collection("baby").document('ABp6KzqnBppv2Qvkp6IW').updateData({key: name});
    });
  }

  //Change to Flashbar when doing asthetics
  showSnackBar(BuildContext context, name, key) {
    var nam = name['name'];
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('$nam added to your deliveries'),
      duration: Duration(milliseconds: 1500),
      action: SnackBarAction(
        label: "UNDO",
        onPressed: () {
          undoDelete(name, key);
        },
      ),
    ));
  }

  void _pushClients(BuildContext context) async {
    final String results = await Navigator.push(context,
      MaterialPageRoute(
          builder: (BuildContext context) {
            return MyClients(clients: _saved.toList());
          }
      ),
    );
    if (results != null) {
      setState(() async{
        _saved.remove(results);
        await Firestore.instance.collection("baby").add({'name': '$results'});
      });
    }
  }
}