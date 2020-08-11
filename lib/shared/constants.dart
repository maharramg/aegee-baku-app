import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
    contentPadding: EdgeInsets.all(15.0),
    border: OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        const Radius.circular(30.0),
      ),
    ),
    filled: true,
    hintStyle: TextStyle(color: Colors.grey),
    fillColor: Colors.white);

class Variable {
  static bool isAdmin;
  static bool isHome = true;
  static String noProfilePicture =
      "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png";
  static Color homeIconColor = Colors.black;
}

class ColorsGlobal {
  static Color home = Colors.grey[200];
  static Color profile = Colors.grey[200];
  static Color settings = Colors.grey[200];
  static Color discount = Colors.grey[200];
  static Color search = Colors.grey[200];
}