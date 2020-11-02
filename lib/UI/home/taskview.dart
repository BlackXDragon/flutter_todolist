import 'package:flutter/material.dart';
import 'package:mytodolist/classes/tag.dart';
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
  String _tempTagName = '';

  _TaskViewState(this._tasks, this.idx) {
    _tempDesc = _tasks[idx].description;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readTasks().then((tasks) {
      setState(() {
        _tasks = tasks;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: TextFormField(
            decoration: InputDecoration(filled: true),
            initialValue: _tasks[idx].description,
            onChanged: (value) {
              setState(() {
                _tempDesc = value;
                _descEditing = true;
              });
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
        ListTile(
          title: Text(
            'Tags:',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          subtitle: (_tasks[idx].tags.length == 0)
              ? Text("No tags")
              : Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _tasks[idx].tags.map<Widget>((tag) {
                    return InputChip(
                      label: Text(
                        tag.name,
                        style: TextStyle(
                          fontSize: 10.0,
                        ),
                      ),
                      backgroundColor:
                          (tag.color != null) ? tag.color : Colors.grey,
                      onPressed: () {
                        print("$tag pressed");
                      },
                      onDeleted: () {
                        setState(() {
                          _tasks[idx].tags.remove(tag);
                          saveTasks(_tasks);
                        });
                      },
                    );
                  }).toList(),
                ),
          trailing: InkWell(
            child: Container(
              child: Icon(Icons.add),
            ),
            onTap: _newTag,
          ),
        ),
      ],
    );
  }

  Future<void> _showDialog<T>({BuildContext context, Widget child}) async {
    final value = await showDialog<T>(
      context: context,
      builder: (context) => child,
    );
  }

  void _newTag() {
    final theme = Theme.of(context);
    final dialogTextStyle = theme.textTheme.subtitle1
        .copyWith(color: theme.textTheme.caption.color);
    _showDialog<String>(
      context: context,
      child: AlertDialog(
        title: Text(
          "Set your tag:",
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        content: TextFormField(
          decoration: InputDecoration(filled: true),
          onChanged: (value) {
            this._tempTagName = value;
          },
          textInputAction: TextInputAction.done,
          onEditingComplete: () {
            setState(() {
              if (this._tempTagName != '') {
                _tasks[idx].tags.add(Tag(this._tempTagName));
                this._tempTagName = '';
                saveTasks(_tasks);
                Navigator.of(context, rootNavigator: true).pop();
              }
            });
          },
        ),
        actions: [
          _DialogButton(
              text: 'Done',
              action: () {
                setState(() {
                  if (this._tempTagName != '') {
                    _tasks[idx].tags.add(Tag(this._tempTagName));
                    this._tempTagName = '';
                    saveTasks(_tasks);
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                });
              }),
          _DialogButton(
              text: 'Cancel',
              action: () {
                Navigator.of(context, rootNavigator: true).pop();
              }),
        ],
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  const _DialogButton({Key key, this.text, this.action}) : super(key: key);

  final String text;
  final action;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(text),
      onPressed: action,
    );
  }
}
