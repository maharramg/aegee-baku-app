import 'package:aegeeapp/shared/constants.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsGlobal.settings,
      body: Container(
        child: Row(
          children: [
            Text("Language")
          ],
        ),
      ),
    );
  }
}
