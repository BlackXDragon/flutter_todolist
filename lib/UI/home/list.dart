import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mytodolist/UI/home/taskview.dart';
import 'package:mytodolist/classes/task.dart';
// import 'package:mytodolist/classes/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mytodolist/localstorage.dart';
import 'package:mytodolist/services/firestore.dart';
import 'package:provider/provider.dart';

class TaskList extends StatefulWidget {
  List<Task> _tasks = <Task>[];
  bool asChild = false;
  DateTime defaultDeadline;
  var onChange;

  TaskList(
      [this._tasks,
      this.asChild = false,
      this.defaultDeadline,
      this.onChange,
      Key key])
      : super(key: key);

  @override
  _TaskListState createState() => _TaskListState(
      this._tasks, this.asChild, this.defaultDeadline, this.onChange);
}

class _TaskListState extends State<TaskList> {
  var _tasks = <Task>[];
  User user;
  String _currText = '';
  bool asChild = false;
  DateTime defaultDeadline;
  var onChange;

  _TaskListState(
      [List<Task> tasks, this.asChild, this.defaultDeadline, this.onChange])
      : this._tasks = (tasks != null) ? tasks : [];

  @override
  void initState() {
    super.initState();
    // if (!this.asChild) {
    //   _tasks = Provider.of<List<Task>>(context);
    // }
    // print(this.asChild);
    // print(this._tasks);
    // print(this.defaultDeadline);
  }

  List<Widget> _showTaskList() {
    List<Widget> taskList = [];
    var toShow = (asChild)
        ? _tasks.where((task) {
            if (task.deadline == null) {
              return false;
            }
            var _taskday = new DateTime.utc(
                task.deadline.year, task.deadline.month, task.deadline.day, 12);
            return (_taskday == defaultDeadline);
          }).toList()
        : _tasks;
    // print("Tasks: $_tasks");
    // print("toShow: $toShow");
    for (int i = 0; i < toShow.length; i++) {
      taskList.add(
        Container(
          child: ListTile(
            title: Text(
              toShow[i].title,
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
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        ),
      );
    }
    return taskList;
  }

  dynamic _showTask(int index) {
    return () async {
      var toShow = (asChild)
          ? _tasks.where((task) {
              var _taskday = new DateTime.utc(task.deadline.year,
                  task.deadline.month, task.deadline.day, 12);
              bool test = _taskday == defaultDeadline;
              return (_taskday == defaultDeadline);
            }).toList()
          : _tasks;
      var idx = _tasks.indexOf(toShow[index]);
      await Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(toShow[index].title),
            ),
            body: TaskView(tasks: _tasks, index: idx),
          );
        }),
      );
      if (asChild) {
        this.onChange();
      } else {
        _tasks = Provider.of<List<Task>>(context);
      }
    };
  }

  void _addTask() {
    if (_currText != '') {
      setState(() => _tasks.add(Task(_currText, deadline: defaultDeadline)));
      _currText = '';
      DatabaseService(uid: user.uid).updateTasks(_tasks);
      if (asChild) {
        this.onChange();
      }
    }
  }

  void _removeTask(int index) {
    setState(() => _tasks.removeAt(index));
    DatabaseService(uid: user.uid).updateTasks(_tasks);
    if (asChild) {
      this.onChange();
    }
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    _tasks = Provider.of<List<Task>>(context) ?? [];
    List<Widget> taskList = _showTaskList();
    taskList.add(
      Container(
        child: ListTile(
          title: TextFormField(
            decoration: InputDecoration(filled: true, hintText: 'Add a task!'),
            onChanged: (value) {
              _currText = value;
            },
            textInputAction: TextInputAction.done,
            onEditingComplete: _addTask,
          ),
          trailing: InkWell(
            child: Container(
              child: Icon(Icons.add),
            ),
            onTap: _addTask,
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      ),
    );
    return Container(
        child: ListView(
      children: taskList,
    ));
  }
}
