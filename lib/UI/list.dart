import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mytodolist/UI/taskview.dart';
import 'package:mytodolist/classes/task.dart';
import 'package:mytodolist/localstorage.dart';

class TaskList extends StatefulWidget {
  List<Task> _tasks = <Task>[];
  bool asChild = false;

  TaskList([this._tasks, this.asChild = false]);

  @override
  _TaskListState createState() => _TaskListState(this._tasks, this.asChild);
}

class _TaskListState extends State<TaskList> {
  var _tasks = <Task>[];
  String _currText = '';
  bool init = true;
  bool asChild = false;

  _TaskListState([List<Task> tasks, this.asChild]) : this._tasks = (tasks != null)? tasks : [];

  @override
  void initState() {
    super.initState();
    if (!this.asChild) {
      readTasks().then((tasks) {
        setState(() {
          _tasks = tasks;
        });
      });
    } else {
      _tasks = [];
    }
  }

  List<Widget> _showTaskList(List<Task> _tasks) {
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
    List<Widget> taskList = _showTaskList(_tasks);
    taskList.add(
      Container(
        child: ListTile(
          title: TextFormField(
            decoration: InputDecoration(filled: true, hintText: 'Add a task!'),
            onChanged: (value) {
              _currText = value;
            },
            textInputAction: TextInputAction.done,
            onEditingComplete: () {
              setState(() {
                if (this._currText != '') {
                  _tasks.add(Task(this._currText));
                  this._currText = '';
                  saveTasks(_tasks);
                  Navigator.of(context, rootNavigator: true).pop();
                }
              });
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
