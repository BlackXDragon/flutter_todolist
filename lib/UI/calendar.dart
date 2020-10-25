import 'package:flutter/material.dart';
import 'package:mytodolist/UI/list.dart';
import 'package:mytodolist/classes/task.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mytodolist/localstorage.dart';

class TaskCalendar extends StatefulWidget {
  @override
  _TaskCalendarState createState() => _TaskCalendarState();
}

class _TaskCalendarState extends State<TaskCalendar>
    with TickerProviderStateMixin {
  CalendarController _calendarController;
  List<Task> _tasks = <Task>[];
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    readTasks().then((tasks) {
      setState(() {
        _tasks = tasks;
      });
    });
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  get _events {
    Map<DateTime, List> events = {};
    for (var task in _tasks) {
      if (task.deadline != null) {
        var _taskday = new DateTime(
            task.deadline.year, task.deadline.month, task.deadline.day);
        if (events.containsKey(_taskday)) {
          events[_taskday].add(task.title);
        } else {
          events.addAll({
            _taskday: [task.title]
          });
        }
      }
    }
    return events;
  }

  get _selectedDayTasks {
    return _tasks.where((task) {
      var _taskday = new DateTime(
          task.deadline.year, task.deadline.month, task.deadline.day);
      return (_taskday == _selectedDay);
    }).toList();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    setState(() {
      _selectedDay = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TableCalendar(
            locale: 'en_IN',
            calendarController: _calendarController,
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
              CalendarFormat.week: 'Week',
            },
            events: _events,
            onDaySelected: _onDaySelected,
          ),
          const SizedBox(
            height: 8.0,
          ),
          Expanded(
            child: TaskList(_selectedDayTasks, true),
          ),
        ],
      ),
    );
  }
}
