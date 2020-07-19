import 'package:aegeeapp/models/user.dart';
import 'package:aegeeapp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  String firstName = "";
  String lastName = "";

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return StreamBuilder(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text("Loading..."),
          );
        }
        UserData userData = snapshot.data;
        firstName = userData.firstName;
        lastName = userData.lastName;
        return Text(
          "${userData.firstName} ${userData.lastName}",
          style: TextStyle(fontSize: 20),
        );
      },
    );
  }
}
