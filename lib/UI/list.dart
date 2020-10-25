import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mytodolist/UI/taskview.dart';
import 'package:mytodolist/classes/task.dart';
import 'package:mytodolist/localstorage.dart';

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  var _tasks = <Task>[];
  String _currText = '';
  bool init = true;

  List<Widget> _showTaskList() {
    List<Widget> taskList = [];
    for (int i = 0; i < _tasks.length; i++) {
      taskList.add(
        Container(
          child: ListTile(
            title: Text(
              _tasks[i].title,
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            leading: Text(
              (i + 1).toString() + '.',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            trailing: InkWell(
              child: Container(
                child: Icon(Icons.delete),
              ),
              onTap: () {
                _removeTask(i);
              },
            ),
            onTap: _showTask(i),
          ),
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        ),
      );
    }
    return taskList;
  }

  dynamic _showTask(int index) {
    return () {
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(_tasks[index].title),
            ),
            body: TaskView(tasks: _tasks, index: index),
          );
        }),
      );
      setState(() {
        init = true;
      });
    };
  }

  void _addTask() {
    if (_currText != '') {
      setState(() => _tasks.add(Task(_currText)));
      _currText = '';
      saveTasks(_tasks);
    }
  }

  void _removeTask(int index) {
    setState(() => _tasks.removeAt(index));
    saveTasks(_tasks);
  }

  @override
  Widget build(BuildContext context) {
    if (init) {
      readTasks().then((tasks) {
        setState(() {
          _tasks = tasks;
        });
      });
      init = false;
    }
    List<Widget> taskList = _showTaskList();
    taskList.add(
      Container(
        child: ListTile(
          title: TextFormField(
            decoration:
                InputDecoration(filled: true, hintText: 'What you need to do?'),
            onChanged: (value) {
              _currText = value;
            },
          ),
          trailing: InkWell(
            child: Container(
              child: Icon(Icons.add),
            ),
            onTap: _addTask,
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      ),
    );
    return Container(
        child: ListView(
      children: taskList,
    ));
  }
}
