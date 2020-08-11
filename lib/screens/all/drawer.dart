import 'package:aegeeapp/models/user.dart';
import 'package:aegeeapp/services/auth.dart';
import 'package:aegeeapp/services/database.dart';
import 'package:aegeeapp/shared/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  final AuthService _auth = AuthService();

  final Function onTap;

  MyDrawer({this.onTap});

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return Container(
      child: SafeArea(
        child: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      StreamBuilder(
                        stream: DatabaseService(uid: user.uid).userData,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: Text("Loading..."),
                            );
                          }
                          UserData userData = snapshot.data;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: avatarUser(userData.avatar),
                              ),
                              Text(
                                "${userData.firstName} ${userData.lastName}",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text("Home"),
                onTap: () {
                  Variable.isHome = true;
                  Variable.homeIconColor = Colors.black;
                  onTap(context, 2);
                },
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Profile"),
                onTap: () {
                  Variable.isHome = false;
                  Variable.homeIconColor = Colors.white;
                  onTap(context, 0);
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text("Settings"),
                onTap: () {
                  Variable.isHome = false;
                  Variable.homeIconColor = Colors.white;
                  onTap(context, 1);
                },
              ),
              Divider(height: 10),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text("Log out"),
                onTap: () async {
                  await _auth.signOut();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget avatarUser(String avatar) {
    if (avatar != null) {
      return CircleAvatar(
        backgroundImage: NetworkImage(avatar),
        radius: 30,
      );
    } else {
      return CircleAvatar(
        backgroundImage: NetworkImage(Variable.noProfilePicture),
        radius: 30,
      );
    }
  }
}