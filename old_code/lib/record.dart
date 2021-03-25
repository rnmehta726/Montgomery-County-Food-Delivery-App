import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  final String name;
  final int bags;

  Record.fromMap(Map<String, dynamic> map)
      : assert(map['name'] != null),
        assert(map['# of bags of food'] != null),
        bags = map['# of bags of food'],
        name = map['name'];


  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data);

  @override
  String toString() => "Record<$name>";
}