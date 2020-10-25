// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:mytodolist/UI/calendar.dart';
import 'package:mytodolist/UI/list.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My To Do List',
      home: HomePage(),
      theme: ThemeData(
        primaryColor: Colors.lightBlueAccent[400],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _currentPage = 'list';

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
      ),
      drawer: _drawer(),
      body: _body(),
    );
  }
}