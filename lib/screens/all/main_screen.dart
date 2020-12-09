import 'package:aegeeapp/screens/all/discount.dart';
import 'package:aegeeapp/screens/all/home.dart';
import 'package:aegeeapp/screens/all/profile.dart';
import 'package:aegeeapp/screens/all/settings.dart';
import 'package:aegeeapp/shared/constants.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 2;
  List<Widget> list = [Profile(), Settings(), Home(), Discount()];
  List<String> titles = ["Profile", "Settings", "AEGEE Baku", "Discount"];
  List<Color> colors = [ColorsGlobal.profile, ColorsGlobal.settings, ColorsGlobal.home, ColorsGlobal.discount];
  String appBarTitle = "AEGEE Baku";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.black,
        ),
        body: list[_index],
        bottomNavigationBar: CurvedNavigationBar(
          color: Colors.black,
          index: _index,
          height: Window.height(context, 60),
          buttonBackgroundColor: _index == 2 ? Colors.white : null,
          backgroundColor: _index == 2 ? Colors.black : colors[_index],
          animationCurve: Curves.decelerate,
          animationDuration: Duration(milliseconds: 500),
          items: [
            Icon(Icons.person, size: Window.height(context, 20), color: Colors.white),
            Icon(Icons.settings, size: Window.height(context, 20), color: Colors.white),
            Icon(Icons.home, size: Window.height(context, 40), color: Variable.homeIconColor),
            Icon(Icons.whatshot, size: Window.height(context, 20), color: Colors.white),
            Icon(Icons.search, size: Window.height(context, 20), color: Colors.white),
          ],
          onTap: (index) {
            setState(() {
              if (index == 2) {
                Variable.homeIconColor = Colors.black;
              } else {
                Variable.homeIconColor = Colors.white;
              }
              _index = index;
              appBarTitle = titles[_index];
            });
          },
        ),
      ),
    );
  }
}
