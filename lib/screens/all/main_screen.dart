import 'package:aegeeapp/screens/all/drawer.dart';
import 'package:aegeeapp/screens/all/home.dart';
import 'package:aegeeapp/screens/all/profile.dart';
import 'package:aegeeapp/screens/all/settings.dart';
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
          title: Text(appBarTitle),
          elevation: 0,
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
