import 'package:aegeeapp/screens/all/all.dart';
import 'package:aegeeapp/screens/all/seminar.dart';
import 'package:aegeeapp/screens/all/universities.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            flexibleSpace: TabBar(
              tabs: [
                Tab(
                  text: 'All',
                ),
                Tab(
                  text: 'Seminar',
                ),
                Tab(
                  text: 'Universities',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              All(),
              Seminar(),
              Universities(),
            ],
          )),
    );
  }
}

