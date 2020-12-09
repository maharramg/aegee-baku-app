import 'package:aegeeapp/screens/all/tabs/all.dart';
import 'package:aegeeapp/screens/all/tabs/international_events.dart';
import 'package:aegeeapp/screens/all/tabs/seminar.dart';
import 'package:aegeeapp/screens/all/tabs/universities.dart';
import 'package:aegeeapp/screens/all/tabs/webinar.dart';
import 'package:aegeeapp/shared/constants.dart';
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
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: TabBar(
              isScrollable: true,
              unselectedLabelColor: Colors.white.withOpacity(0.3),
              tabs: [Tab(text: 'All'), Tab(text: 'Seminar'), Tab(text: 'Webinar'), Tab(text: 'Universities'), Tab(text: 'International Events')],
              indicator: MaterialIndicator(
                color: Colors.white,
                height: Window.height(context, 3),
                topLeftRadius: 8,
                topRightRadius: 8,
                horizontalPadding: Window.height(context, 20),
                tabPosition: TabPosition.bottom,
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [All(), Seminar(), Webinar(), Universities(), InternationalEvents()],
        ),
      ),
    );
  }
}
