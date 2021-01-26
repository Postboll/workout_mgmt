import 'package:cloud_firestore/cloud_firestore.dart';

class Workout {

  Workout(DocumentSnapshot doc) {

    this.documentReference = doc.reference;

    this.title = doc.data()['title'];
    this.count = doc.data()['count'].toString();
    this.item = doc.data()['category'].toString();
    final Timestamp timestamp = doc.data()['createdAt'];
    this.createdAt = timestamp.toDate();
  }

  String title;
  String count;
  String item;
  DateTime createdAt;
  bool isDone = false;
  DocumentReference documentReference;

}
