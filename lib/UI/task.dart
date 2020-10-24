import 'package:flutter/material.dart';
import 'package:mytodolist/classes/task.dart';
import 'package:intl/intl.dart';
import 'package:mytodolist/localstorage.dart';

class TaskView extends StatefulWidget {
  List<Task> tasks;
  int index;
  TaskView({@required this.tasks, @required this.index}) : super();
  @override
  _TaskViewState createState() => _TaskViewState(tasks, index);
}

class _TaskViewState extends State<TaskView> {
  List<Task> _tasks;
  int idx;
  String _tempDesc = '';
  bool _descEditing = false;

  _TaskViewState(this._tasks, this.idx) : _tempDesc = _tasks[idx].description;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: TextFormField(
            decoration: InputDecoration(filled: true),
            initialValue: _tasks[idx].description,
            onChanged: (value) {
              _tempDesc = value;
              _descEditing = true;
            },
            keyboardType: TextInputType.multiline,
            maxLines: 4,
          ),
          leading: Text(
            "Description:",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          trailing: IconButton(
              icon: Icon(Icons.check,
                  color:
                      (this._descEditing) ? Colors.blueAccent : Colors.black),
              onPressed: () {
                setState(() {
                  this._tasks[this.idx].description = _tempDesc;
                  this._descEditing = false;
                  saveTasks(_tasks);
                });
              }),
        ),
        ListTile(
          title: Text(
            (_tasks[idx].deadline != null)
                ? DateFormat("dd-MM-yy HH:mm").format(_tasks[idx].deadline)
                : 'None',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          leading: Text(
            "Deadline:",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          trailing: IconButton(
              icon: Icon(Icons.calendar_today, color: Colors.black),
              onPressed: () async {
                DateTime _fromDate = (_tasks[idx].deadline != null)
                    ? _tasks[idx].deadline
                    : DateTime.now();
                TimeOfDay _fromTime = TimeOfDay.fromDateTime(_fromDate);
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _fromDate,
                  firstDate: DateTime(2015, 1),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null && pickedDate != _fromDate) {
                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: _fromTime,
                  );
                  if (pickedTime != null && pickedTime != _fromTime) {
                    setState(() {
                      _tasks[idx].deadline = new DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute);
                      saveTasks(_tasks);
                    });
                  }
                }
              }),
        ),
      ],
    );
  }
}
