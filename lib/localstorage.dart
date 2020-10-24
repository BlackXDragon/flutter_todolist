import 'package:path_provider/path_provider.dart';
import 'package:mytodolist/classes/task.dart';
import 'dart:io';
import 'dart:async';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> _localFile(String filename) async {
  final path = await _localPath;
  return File('$path/favourites.txt');
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
}

Future<File> saveTasks(List<Task> _tasks) async {
  final file = await _localFile('tasks.dat');

  print(_tasks);
  
  final data = _tasks.join('\n');

  print(data);

  // Write the file.
  return file.writeAsString(data);
}

Future<List<Task>> readTasks() async {
  try {
    final file = await _localFile('tasks.dat');

    // Read the file.
    String contents = await file.readAsString();

    if (contents == "") {
      return [];
    }

    List<String> list = contents.split('\n');

    list.removeWhere((element) => element == '');

    List<Task> _tasks = [];
    for (var line in list) {
      _tasks.add(Task.fromString(line));
    }

    return _tasks;
  } catch (e) {
    print(e);
    // If encountering an error, return 0.
    return [];
  }
}