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
  fillColor: Colors.white
);