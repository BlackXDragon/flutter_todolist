import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mytodolist/UI/wrapper.dart';
// import 'package:mytodolist/classes/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mytodolist/services/auth.dart';
import 'package:mytodolist/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

void main() async {
  // FlutterError.onError = (FlutterErrorDetails details) {
  //   FlutterError.dumpErrorToConsole(details);
  //   if (kReleaseMode) exit(1);
  // };
  initializeDateFormatting().then((_) => runApp(App()));
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      print("Firebase INIT");
      await Firebase.initializeApp();
      print("Firebase INIT over");
      setState(() {
        _initialized = true;
        print("Initializing");
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        print("Error");
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("In Build");
    if (_error) {
      print("_ERROR");
      return MaterialApp(
        title: 'My To Do List',
        home: Loading(),
        theme: ThemeData(
          primaryColor: Colors.lightBlueAccent[400],
        ),
      );
    }
    if (_initialized) {
      print("_INIT");
      return StreamProvider<User>.value(
        value: AuthService().user,
        child: MaterialApp(
          title: 'My To Do List',
          home: Wrapper(),
          theme: ThemeData(
            primaryColor: Colors.lightBlueAccent[400],
          ),
        ),
      );
    }
    print("Loading");
    return MaterialApp(
      title: 'My To Do List',
      home: Loading(),
      theme: ThemeData(
        primaryColor: Colors.lightBlueAccent[400],
      ),
    );
  }
}
