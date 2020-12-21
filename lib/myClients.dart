import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
          if (snapshot.hasData){
            return _list(snapshot.data);
          }
          return CircularProgressIndicator();
        }
    );
  }
  // fix list builder
  Widget _list(Map v) {
    return ListView(
        padding: EdgeInsets.only(top: 15.0),
        children: v.entries.map((data) => _row(context, data.value, data.key)).toList()
    );
  }

  Widget _row(context, Map saved, String keys) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Dismissible(
        key: UniqueKey(),
        onDismissed: (direction){
          if (direction == DismissDirection.endToStart) {
            setState(() {
              saved['volunteer_id'] = 0;
              Firestore.instance.collection('baby').document(
                  'ABp6KzqnBppv2Qvkp6IW').updateData({keys: saved});
            });
          }
          else if (direction == DismissDirection.startToEnd) {
            setState(() {
              Firestore.instance.collection('baby').document(
                  'ABp6KzqnBppv2Qvkp6IW').updateData({keys: FieldValue.delete()});
            });
          }
        },
        background: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              color: Colors.green,
              borderRadius: BorderRadius.circular(5.0),
            ),
            padding: EdgeInsets.only(left: 10.0),
            alignment: Alignment.centerLeft,
            child: Icon(Icons.check, color: Colors.white)
        ),
        secondaryBackground: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 10.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.red,
            ),
            child: const Icon(Icons.delete_sharp, color: Colors.white)
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child:ListTile(title: Text(saved['name'], style: TextStyle(fontSize: 18)), subtitle: Text(saved['# of bags of food'].toString()))
        ),
      )
    );
  }

  Future<Map> getData() async{
    var info = {};
    await Firestore.instance.collection('baby').document('ABp6KzqnBppv2Qvkp6IW').get().then((DocumentSnapshot ds) {
        for (var k in ds.data.keys.toList()){
          if (ds.data[k]['volunteer_id'] == vId) {
            info[k] = {'volunteer_id': ds.data[k]['volunteer_id'], 'name': ds.data[k]['name'], '# of bags of food': ds.data[k]['# of bags of food']};
          }
        }
      }
    );
    return info;
  }
}