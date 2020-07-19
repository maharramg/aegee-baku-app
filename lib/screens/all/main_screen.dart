import 'package:aegeeapp/screens/all/home.dart';
import 'package:aegeeapp/screens/all/profile.dart';
import 'package:aegeeapp/screens/all/settings.dart';
import 'package:aegeeapp/services/auth.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 0;
  List<Widget> list = [Home(), Profile(), Settings()];
  List<String> titles = ["AEGEE Baku", "Profile", "Settings"];
  String appBarTitle = "AEGEE Baku";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("$appBarTitle"),
          centerTitle: true,
        ),
        body: list[index],
        drawer: MyDrawer(
          onTap: (context, i) {
            setState(() {
              index = i;
              appBarTitle = titles[index];
              Navigator.pop(context, i);
            });
          },
        ),
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  final AuthService _auth = AuthService();

  final Function onTap;

  MyDrawer({this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
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
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () => onTap(context, 0),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Profile"),
              onTap: () => onTap(context, 1),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () => onTap(context, 2),
            ),
            Divider(height: 10),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Log out"),
              onTap: () async {
                await _auth.signOut();
              },
            )
          ],
        ),
      ),
    );
  }
}
