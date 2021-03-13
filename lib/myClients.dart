import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'clientInfor.dart';

class MyClients extends StatefulWidget {
  final int id;
  MyClients({Key key, this.id}) : super(key: key);
  @override
  _MyClientsState createState() => _MyClientsState(vId: id);

}

class _MyClientsState extends State<MyClients> {
  final int vId;
  _MyClientsState({this.vId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != {}){
            return _list(snapshot.data);
          }
          return Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Align(
                  child: Text('No clients under your name', style: TextStyle(fontSize: 18),),
                  alignment: Alignment.topCenter)
          );
        }
    );
  }
  // fix list builder
  Widget _list(Map v) {
    return ListView(
        padding: EdgeInsets.only(top: 0.0),
        children: v.entries.map((data) => _row(context, data.value, data.key)).toList()
    );
  }

  Widget _row(context, Map saved, String keys) {
    var name2 = saved['name'];
    var address = saved['address'];
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0)
          ),
          child: ListTile(
            title: Text(name2),
            subtitle: Text(address),
            onTap: () async {
              await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ClientInfo(id: vId, name: name2))
              );
              setState(() {});
            },
          ),
        ),
      );
  }

  Future<Map> getData() async{
    Map info = {};
    await Firestore.instance.collection('orders').document('SQujodVWeKgohCENPueX').get().then((DocumentSnapshot ds) {
        for (var k in ds.data.keys.toList()){
          if (ds.data[k]['volunteer_id'] == vId) {
            info[k] = {'volunteer_id': ds.data[k]['volunteer_id'], 'name': ds.data[k]['name'], 'address': ds.data[k]['address'] +", "+ ds.data[k]['city']+", TX"};
          }
        }
      }
    );
    return info;
  }
}