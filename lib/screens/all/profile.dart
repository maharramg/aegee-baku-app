import 'package:aegeeapp/models/user.dart';
import 'package:aegeeapp/services/database.dart';
import 'package:aegeeapp/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  bool _isAdmin;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return StreamBuilder(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Loading();
        }
        UserData userData = snapshot.data;
        _isAdmin = userData.admin;
        return Container(
          child: Column(
            children: <Widget>[
              Text(
                "Full Name: ${userData.firstName} ${userData.lastName}",
                style: TextStyle(fontSize: 20),
              ),
              adminFeature(),
            ],
          ),
        );
      },
    );
  }

  Widget adminFeature() {
    if (_isAdmin == true) {
      return Text("You are an admin");
    } else {
      return Container();
    }
  }
}
