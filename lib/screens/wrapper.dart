import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aegeeapp/models/user.dart';
import 'package:aegeeapp/screens/authenticate/authenticate.dart';
import 'package:aegeeapp/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(user);

    // return either the Home or Authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
