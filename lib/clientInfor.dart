import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClientInfo extends StatefulWidget {
  final int id;
  final String name;
  ClientInfo({Key key, this.id, this.name}) : super(key: key);
  @override
  _ClientInfoState createState() => _ClientInfoState(vId: id, vName: name);
}

class _ClientInfoState extends State<ClientInfo> {
  final String vName;
  final int vId;
  _ClientInfoState({this.vName, this.vId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _body(snapshot.data);
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Widget _body(Map v) {
    var button = _removeClientButton(context, v.values.toList()[0], v.keys.toList()[0]);
    var anotherButton = _finishClient(context, v.values.toList()[0], v.keys.toList()[0]);

    Map<String, dynamic> clientInfoMap = v.values.toList()[0];

    return Scaffold(
      appBar: AppBar(
        title: Text(vName + "'s" + " Information"),
        backgroundColor: Color(0xFF33691E),
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF9CCC65),
                  Color(0xFF8BC34A),
                  Color(0xFF689F38),
                  Color(0xFF33691E),
                ],
                stops: [0.1, 0.4, 0.7, 0.9],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(25.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Client Name: ' + vName +
                        '\n' +
                        '\nNumber of Bags of Food: ' +
                        clientInfoMap['# of bags of food'].toString() + '',
                    style: TextStyle(color: Colors.white, fontSize: 17.5),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      button,
                      anotherButton
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _removeClientButton(context, Map saved, String keys) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed))
                return Color(0xFF8BC34A);
              return Color(0xFF33691E); // Use the component's default.
            },
          ),
        ),
        onPressed: () {
          setState(() {
            saved['volunteer_id'] = 0;
            Firestore.instance
                .collection('orders')
                .document('SQujodVWeKgohCENPueX')
                .updateData({keys: saved});
            Navigator.pop(context);
          });
        },
        child: Text(
          'Remove Client',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _finishClient(context, Map saved, String keys) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed))
                return Color(0xFF8BC34A);
              return Color(0xFF33691E); // Use the component's default.
            },
          ),
        ),
        onPressed: () {
          setState(() {
            saved['volunteer_id'] = 0;
            Firestore.instance.collection('orders').document(
                'SQujodVWeKgohCENPueX').updateData(
                {keys: FieldValue.delete()});
          });
          Navigator.pop(context);
        },
        child: Text(
          'Finish Client',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<Map> getData() async {
    var info = {};
    await Firestore.instance
        .collection('orders')
        .document('SQujodVWeKgohCENPueX')
        .get()
        .then((DocumentSnapshot ds) {
      for (var k in ds.data.keys.toList()) {
        if (ds.data[k]['name'] == vName) {
          info[k] = {
            'volunteer_id': ds.data[k]['volunteer_id'],
            'name': ds.data[k]['name'],
            '# of bags of food': ds.data[k]['# of bags of food'],
            'city': ds.data[k]['city'],
            'phoneNumber': ds.data[k]['phoneNumber'],
            'street': ds.data[k]['street'],
            'zipCode': ds.data[k]['zipCode']
          };
        }
      }
    });
    return info;
  }
}

