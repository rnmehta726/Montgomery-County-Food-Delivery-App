import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

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

  static const String URL = "https://script.google.com/macros/s/AKfycbzPnJ651JSmR4bJxVxgSjSbcomx1cwI712-v-mAhr0PXO9sWq0r0qE/exec";
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Position _currentPosition;

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
        }
    );
  }

  Widget _body(Map v) {
    var button;
    var anotherButton;
    var thirdButton;
    var navButton;

    Map<String, dynamic> clientInfoMap = v.values.toList()[0];
    if (clientInfoMap['frequency'] == 2) {
      button = _removeClientButton(context, v.values.toList()[0], v.keys.toList()[0], "I cannot deliver to this client anymore");
      anotherButton = _finishClient(context, v.values.toList()[0], v.keys.toList()[0], "Client no longer needs assistance");
      thirdButton = _biWeeklyComplete(context, v.values.toList()[0], v.keys.toList()[0], "Biweekly Delivery Completed");
      navButton = _navClient(context, v.values.toList()[0], v.keys.toList()[0], "Directions to Client");
    } else {
      button = _removeClientButton(context, v.values.toList()[0], v.keys.toList()[0], "I cannot deliver to this client anymore");
      anotherButton = _finishClient(context, v.values.toList()[0], v.keys.toList()[0], "Client Delivery Completed");
      navButton = _navClient(context, v.values.toList()[0], v.keys.toList()[0], "Directions to Client");
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(vName + "'s Information"),
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
              children: clientInfoMap['frequency'] == 2 ? [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Text(
                    'Client Name: $vName\n\nBags of food: '+clientInfoMap['# of bags of food'].toString()+
                        '\n\nAddress: '+clientInfoMap['address']+"\n\nCity: "+clientInfoMap['city']+", Texas\n\nZip Code: "+
                        clientInfoMap['zipCode'].toString(),
                    style: TextStyle(color: Colors.white, fontSize: 17.5),
                  ),]
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      navButton,
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      thirdButton,
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [button],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:[anotherButton],
                  ),
                ),
              ] : [
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [Text(
                      'Client Name: $vName\n\nBags of food: '+clientInfoMap['# of bags of food'].toString()+
                          '\n\nAddress: '+clientInfoMap['address']+"\n\nCity: "+clientInfoMap['city']+", Texas\n\nZip Code: "+
                          clientInfoMap['zipCode'].toString(),
                      style: TextStyle(color: Colors.white, fontSize: 17.5),
                    ),]
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      navButton,
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [button],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:[anotherButton],
                  ),
                ),
              ] ,
            ),
          ),
        ],
      ),
    );
  }


  Widget _removeClientButton(context, Map saved, String keys, String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed))
                return Colors.white70;
              return Colors.white; // Use the component's default.
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
          text,
          style: TextStyle(color: Color(0xFF689F38), fontSize: 15),
        ),
      ),
    );
  }

  Widget _finishClient(context, Map saved, String keys, String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed))
                return Colors.white70;
              return Colors.white; // Use the component's default.
            },
          ),
        ),
        onPressed: () async{
          var savedDate = saved;
          savedDate['date'] = DateTime.now();
          savedDate = toJson(savedDate);
          submitCompletedDate(savedDate, (String response) {
            print("Response: $response");
          });
          setState(() {
            saved['volunteer_id'] = 0;
            Firestore.instance.collection('orders').document(
                'SQujodVWeKgohCENPueX').updateData(
                {keys: FieldValue.delete()});
          });
          Navigator.pop(context);
        },
        child: Text(
          text,
          style: TextStyle(color: Color(0xFF689F38), fontSize: 15),
        ),
      ),
    );
  }

  Widget _biWeeklyComplete(context, Map saved, String keys, String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed))
                return Colors.white70;
              return Colors.white; // Use the component's default.
            },
          ),
        ),
        onPressed: () async{
          var savedDate = saved;
          savedDate['date'] = DateTime.now();
          savedDate = toJson(savedDate);
          submitCompletedDate(savedDate, (String response) {
            print("Response: $response");
          });
        },
        child: Text(
          text,
          style: TextStyle(color: Color(0xFF689F38), fontSize: 15),
        ),
      ),
    );
  }

  Widget _navClient(context, Map saved, String keys, String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed))
                return Colors.white70;
              return Colors.white; // Use the component's default.
            },
          ),
        ),
        onPressed: () {
          var address = saved['address'];
          var city = saved['city'];

          var perms = _checkLocationPermission(address, city);
          perms.then((value) async {
            if (value) {
              await _getCurrentLocation();
              _navigateTo('119 Deerchase Drive, Conroe, Texas');
            } else {
              _ackAlert(context);
            }
          });
        },
        child: Text(
          text,
          style: TextStyle(color: Color(0xFF689F38), fontSize: 15),
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
            'address': ds.data[k]['address'],
            'zipCode': ds.data[k]['zipCode'],
            "date" : ds.data[k]['date'],
            'frequency' : ds.data[k]['frequency'],
          };
        }
      }
    });
    return info;
  }

  void submitCompletedDate(Map saved, void Function(String) callback) async {
    try {
      await http.post(URL, body: saved).then((response) async {
        if (response.statusCode == 302) {
          var url = response.headers['location'];
          await http.get(url).then((response) {
            callback(convert.jsonDecode(response.body)['status']);
          });
        } else {
          callback(convert.jsonDecode(response.body)['status']);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Map toJson(saved) => {
    'name': saved['name'],
    'date': saved['date'].toString()
  };

  void _navigateTo(String address) async {
    String lat = _currentPosition.latitude.toString();
    String lon = _currentPosition.longitude.toString();
    String query = Uri.encodeComponent(address);
    String navUrl = 'https://www.google.com/maps/dir/?api=1&origin=$lat,$lon&destination=$query&travelmode=driving';

    if (await canLaunch(navUrl)) {
      await launch(navUrl);
    }
  }

  void _getCurrentLocation() async {
    final Geolocator geolocator = Geolocator();

    await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      _currentPosition = position;
      print(position);
    }).catchError((e) {
      print(e);
    });
  }

  Future<bool> _checkLocationPermission(String address, String city) async {
    var status = await Permission.locationWhenInUse.status;
    if (!status.isGranted){
      PermissionStatus permissionStatus = await Permission.locationWhenInUse.request();
      if (permissionStatus.isGranted) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  Future _ackAlert(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No location granted'),
          content: const Text('Without location permission, we are unable to navigate you to your client.'),
          actions: [
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
