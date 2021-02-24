// import 'package:mytodolist/classes/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mytodolist/UI/authenticate/authenticate.dart';
import 'package:mytodolist/UI/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    // return either the Home or Authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return HomePage();
    }
  }
}
