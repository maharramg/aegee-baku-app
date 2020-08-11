import 'package:aegeeapp/screens/all/tabs/all.dart';
import 'package:aegeeapp/screens/all/tabs/seminar.dart';
import 'package:aegeeapp/screens/all/tabs/universities.dart';
import 'package:aegeeapp/screens/all/tabs/webinar.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: TabBar(
              tabs: [
                Tab(text: 'All'),
                Tab(text: 'Seminar'),
                Tab(text: 'Webinar'),
                Tab(text: 'Universities'),
              ],
              indicator: MaterialIndicator(
                color: Colors.white,
                height: 5,
                topLeftRadius: 8,
                topRightRadius: 8,
                horizontalPadding: 30,
                tabPosition: TabPosition.bottom,
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            All(),
            Seminar(),
            Webinar(),
            Universities(),
          ],
        ),
      ),
    );
  }
}
