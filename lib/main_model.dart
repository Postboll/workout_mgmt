import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/workout.dart';


class MainModel extends ChangeNotifier {

  List<Workout> workoutlist = [];
  String newWorkoutText = '';
  String newWorkoutDigit = '';
  String newWorkoutCategory = '';

  Future getWorkoutList() async {
    final snapshot =
    await FirebaseFirestore.instance.collection('workoutlist').get();
    final docs = snapshot.docs;
    final workoutlist = docs.map((doc) => Workout(doc)).toList();
    this.workoutlist = workoutlist;
    notifyListeners();
  }

  void getWorkoutListRealtime() {
    final snapshots =
    FirebaseFirestore.instance.collection('workoutlist').snapshots();
    snapshots.listen((snapshot) {
      final docs = snapshot.docs;
      final workoutlist = docs.map((doc) => Workout(doc)).toList();
      workoutlist.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      this.workoutlist = workoutlist;
      notifyListeners();
    });
  }

  Future add(model) async {
    final collection = FirebaseFirestore.instance.collection('workoutlist');
    await collection.add({
      'title': newWorkoutText,
      'count': int.parse(newWorkoutDigit),
      'category': newWorkoutCategory.toLowerCase(),
      'createdAt': Timestamp.now(),
    });
  }

  void reload() {
    notifyListeners();
  }

  Future deleteCheckedItems() async {
    final checkedItems = workoutlist.where((todo) => todo.isDone).toList();
    final references =
    checkedItems.map((todo) => todo.documentReference).toList();

    final batch = FirebaseFirestore.instance.batch();

    references.forEach((reference) {
      batch.delete(reference);
    });
    return batch.commit();
  }

  bool checkShouldActiveCompleteButton() {
    final checkedItems = workoutlist.where((todo) => todo.isDone).toList();
    return checkedItems.length > 0;
  }
}