import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  final String name;
  final String city;

  Record.fromMap(Map<String, dynamic> map)
      : assert(map['name'] != null),
        assert(map['city'] != null),
        city = map['city'],
        name = map['name'];


  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data);

  @override
  String toString() => "Record<$name>";
}