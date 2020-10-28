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
  DateTime _selectedDay = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day, 12);
  // TaskList _taskList;

  CalendarBuilders calBuild = CalendarBuilders();

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.cyan[500]
            : _calendarController.isToday(date)
                ? Colors.cyan[300]
                : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    readTasks().then((tasks) {
      setState(() {
        _tasks = tasks;
        // _taskList = TaskList(_selectedDayTasks, true);

        calBuild = CalendarBuilders(
          selectedDayBuilder: (context, date, _) {
            return Container(
              margin: const EdgeInsets.all(4.0),
              // padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blueAccent,
                  width: 2.0,
                ),
              ),
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            );
          },
          todayDayBuilder: (context, date, _) {
            return Container(
              margin: const EdgeInsets.all(4.0),
              // padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: Colors.lightBlue[400],
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            );
          },
          markersBuilder: (context, date, events, holidays) {
            final children = <Widget>[];

            if (events.isNotEmpty) {
              children.add(
                Positioned(
                  right: 1,
                  bottom: 1,
                  child: _buildEventsMarker(date, events),
                ),
              );
            }

            if (holidays.isNotEmpty) {
              children.add(
                Positioned(
                  right: -2,
                  top: -2,
                  child: _buildHolidaysMarker(),
                ),
              );
            }

            return children;
          },
        );
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
      var _taskday = new DateTime.utc(
          task.deadline.year, task.deadline.month, task.deadline.day, 12);
      bool test = _taskday == _selectedDay;
      print("Date comparison: $_taskday, $_selectedDay, $test");
      return (_taskday == _selectedDay);
    }).toList();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    setState(() {
      this._selectedDay = day;
      // _taskList = TaskList(_selectedDayTasks, true);
    });
  }

  void _onTaskChange() {
    readTasks().then((tasks) {
      setState(() {
        _tasks = tasks;
      });
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
            holidays: {
              DateTime(2020, 10, 30): ["Test Holiday"],
            },
            onDaySelected: _onDaySelected,
            builders: calBuild,
          ),
          const SizedBox(
            height: 8.0,
          ),
          Expanded(
            child: TaskList(_tasks, true, _selectedDay, _onTaskChange, UniqueKey()),
          ),
        ],
      ),
    );
  }
}
