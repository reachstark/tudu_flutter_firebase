import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Task {
  String id;
  String name;
  bool isComplete;

  Task({required this.id, required this.name, this.isComplete = false});

  void toggleComplete() {
    isComplete = !isComplete;
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'isComplete': isComplete,
      };

  factory Task.fromJson(String id, Map<String, dynamic> json) => Task(
        id: id,
        name: json['name'],
        isComplete: json['isComplete'],
      );
}

class TaskStateManager extends ChangeNotifier {
  List<Task> tasks = [];
  bool switchToggle = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void addTask(Task task) {
    try {
      if (tasks.any((t) => t.name == task.name)) {
        throw Exception('Task already exists!');
      }
      // Easiest way to solve the randomly ordered tasks
      final timestamp = Timestamp.now();
      task.id = timestamp.toString();
      _firestore.collection('tasks').doc(task.id).set(task.toJson());
      tasks.add(task);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void removeTask(int index) async {
    await _firestore.collection('tasks').doc(tasks[index].id).delete();
    tasks.removeAt(index);
    notifyListeners();
  }

  void updateTask(Task task, String newName) async {
    await _firestore.collection('tasks').doc(task.id).update(task.toJson());
    task.name = newName;
    notifyListeners();
  }

  void toggleTaskCompletion(Task task) {
    task.toggleComplete();
    _firestore.collection('tasks').doc(task.id).update(task.toJson());
    notifyListeners();
  }

  void setShowCompletedTasks(bool switchTask) {
    switchToggle = switchTask;
    notifyListeners();
  }
}
