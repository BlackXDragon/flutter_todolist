// import 'dart:convert';
import 'package:localstorage/localstorage.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:mytodolist/classes/task.dart';
// import 'dart:io';
import 'dart:async';

final LocalStorage storage = new LocalStorage('mytodolist');

/* Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> _localFile(String filename) async {
  final path = await _localPath;
  return File('$path/$filename');
}

Future<File> writeSListToFile(List<String> list, String filename) async {
  final file = await _localFile(filename);

  var data = '';

  for (var pair in list) {
    data += pair + '\n';
  }

  // Write the file.
  return file.writeAsString(data);
}

Future<List> readSListFromFile(String filename) async {
  try {
    final file = await _localFile(filename);

    // Read the file.
    String contents = await file.readAsString();

    if (contents == "") {
      return [];
    }

    List<String> list = contents.split('\n');

    list.removeWhere((element) => element == '');

    return list;
  } catch (e) {
    // If encountering an error, return 0.
    return [];
  }
} */

Future saveTasks(List<Task> _tasks) async {
  while (! await storage.ready);
  // print("Tasks: "+_tasks.toString());
  final json = (_tasks != null)? _tasks.map((task) => task.toJSON()).toList() : [];
  // print("JSON: "+json.toString());
  
  storage.setItem('tasks', json);
}

Future<List<Task>> readTasks() async {
  try {
    while (! await storage.ready);
    final raw = storage.getItem('tasks');
    return (raw != null)? raw.map<Task>((item) => Task.fromJSON(item)).toList() : <Task>[];
  } catch (e) {
    print(e);
    // If encountering an error, return 0.
    return [];
  }
}