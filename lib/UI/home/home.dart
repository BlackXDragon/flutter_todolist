import 'package:flutter/material.dart';
import 'package:mytodolist/UI/home/calendar.dart';
import 'package:mytodolist/UI/home/list.dart';
import 'package:mytodolist/services/auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _currentPage = 'list';
  var _auth = AuthService();

  Widget _body() {
    switch(_currentPage) {
      case 'list':
        return TaskList();
      case 'calendar':
        return TaskCalendar();
    }
  }

   Widget _drawer() {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: ListTile(
              title: Text('Drawer Header'),
              leading: Icon(
                Icons.account_circle,
                color: Colors.white,
                size: 100.0,
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('List'),
            leading: Icon(
              Icons.list,
              color: Colors.black,
              size: 30.0,
            ),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              setState(() {
                _currentPage = 'list';
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Calendar'),
            leading: Icon(
              Icons.calendar_today,
              color: Colors.black,
              size: 30.0,
            ),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              setState(() {
                _currentPage = 'calendar';
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My To Do List'),
        actions: [
          MaterialButton(
            child: Text("Logout"),
            onPressed: () => _auth.signOut(),
          )
        ],
      ),
      drawer: _drawer(),
      body: _body(),
    );
  }
}