import 'package:mytodolist/classes/task.dart';
import 'package:mytodolist/classes/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference taskCollection = Firestore.instance.collection('tasks');

  Future<void> updateTasks(List<Task> tasks) async {
    return await taskCollection.document(uid).setData({
      'tasks': tasks.map((task) => task.toJSON()).toList()
    });
  }

  // task list from snapshot
  List<Task> _taskListFromSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.data == null) {
      return [];
    }
    var _tasks = snapshot.data['tasks'].map<Task>((task) {
      // print("Task: $task");
      return Task.fromJSON(task);
    }).toList();
    // print("_tasks: $_tasks");
    return _tasks;
  }

  // get tasks stream
  Stream<List<Task>> get tasks {
    return taskCollection.document(uid).snapshots()
      .map(_taskListFromSnapshot);
  }

}