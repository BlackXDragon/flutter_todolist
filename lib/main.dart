import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mytodolist/UI/wrapper.dart';
import 'package:mytodolist/classes/user.dart';
import 'package:mytodolist/services/auth.dart';
import 'package:provider/provider.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}
