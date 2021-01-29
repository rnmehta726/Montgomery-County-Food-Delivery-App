import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClientList extends StatefulWidget {
  final String volName;
  final int volId;
  ClientList({Key key, this.volName, this.volId}) : super(key: key);

  @override
  _ClientListState createState() => _ClientListState(vName: volName, vId: volId);

}

class _ClientListState extends State<ClientList> {
  final String vName;
  final int vId;
  _ClientListState({this.vName, this.vId});

  @override
  Widget build(BuildContext context) {
    return _stream(context);
  }

  Widget _stream(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('orders')
            .document('SQujodVWeKgohCENPueX')
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          var firestoreData = snapshot.data.data;
          return _foodRecipients(context, firestoreData);
        });
  }

  Widget _foodRecipients(BuildContext context, Map<String, dynamic> snapshot) {
    List<String> keys = snapshot.keys.toList();
    List<Map<String, dynamic>> values = [];

    for (var key in keys) {
      var val = new Map<String, dynamic>.from(snapshot[key]);
      if (val['volunteer_id'] == 0) {
        values.add(new Map<String, dynamic>.from(snapshot[key]));
      }
    }

    return ListView(
        padding: EdgeInsets.only(top: 0.0),
        children:
            values.map((data) => _buildRow(context, data, snapshot)).toList());
  }

  Widget _buildRow(BuildContext context, Map<String, dynamic> document,
      Map<String, dynamic> snapshot) {
    final record = Record.fromMap(document);
    var key = '';
    final alreadyTaken = document['volunteer_id'] != 0;
    final name = record.name;
    final food = record.bags;

    for (var k in snapshot.keys.toList()) {
      if (snapshot[k].toString() == document.toString()) {
        key = k;
        break;
      }
    }

    return Padding(
      key: ValueKey(record.name),
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0.5),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: ListTile(
            title: Text(name, style: TextStyle(fontSize: 18)),
            subtitle: Text(food.toString(), style: TextStyle(fontSize: 12)),
            trailing: Icon(
              alreadyTaken ? Icons.add_box_sharp : Icons.add_box_outlined,
              color: alreadyTaken ? Colors.green : null,
            ),
            onTap: () async {
              final newDoc = document;
              newDoc['volunteer_id'] = vId;
              await Firestore.instance
                  .collection("orders")
                  .document('SQujodVWeKgohCENPueX')
                  .updateData({key: newDoc});
              setState(() {});
              Timer(Duration(milliseconds: 150), () {
                showSnackBar(context, document, key);
                setState(() {});
              });
            }),
      ),
    );
  }
  undoDelete(doc, key) async {
    doc['volunteer_id'] = 0;
    await Firestore.instance
        .collection("orders")
        .document('SQujodVWeKgohCENPueX')
        .updateData({key: doc});
    setState(() {});
  }

  //Change to Flashbar when doing asthetics
  showSnackBar(BuildContext context, doc, key) {
    var nam = doc['name'];
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('$nam added to your deliveries'),
      duration: Duration(milliseconds: 3000),
      action: SnackBarAction(
        label: "UNDO",
        onPressed: () {
          undoDelete(doc, key);
        },
      ),
    ));
  }
}

