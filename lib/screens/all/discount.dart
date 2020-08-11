import 'package:aegeeapp/shared/constants.dart';
import 'package:flutter/material.dart';

class Discount extends StatefulWidget {
  @override
  _DiscountState createState() => _DiscountState();
}

class _DiscountState extends State<Discount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ColorsGlobal.discount,
        child: Center(child: Text("COMING SOON")),
      ),
    );
  }
}
