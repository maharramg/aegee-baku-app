import 'package:aegeeapp/screens/all//main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aegeeapp/models/user.dart';
import 'package:aegeeapp/screens/authenticate/authenticate.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    // return either the Home or Authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return MainScreen();
    }
  }
}
