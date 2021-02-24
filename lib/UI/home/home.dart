import 'package:flutter/material.dart';
import 'package:mytodolist/UI/home/calendar.dart';
import 'package:mytodolist/UI/home/list.dart';
import 'package:mytodolist/classes/task.dart';
// import 'package:mytodolist/classes/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mytodolist/services/auth.dart';
import 'package:mytodolist/services/firestore.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _currentPage = 'list';
  var _auth = AuthService();
  User user;

  Widget _body() {
    switch (_currentPage) {
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
    user = Provider.of<User>(context);
    return StreamProvider<List<Task>>.value(
      value: DatabaseService(uid: user.uid).tasks,
      child: Scaffold(
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
      ),
    );
  }
}
