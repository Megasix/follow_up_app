import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey, width: 2.0)),
);

final lightThemeConstant = ThemeData(
  scaffoldBackgroundColor: Color(0xFFF5F5F5),
  buttonColor: Color(0xFFFBAF00),
  primaryColor: Color(0xFFFBAF00),
  secondaryHeaderColor: Color(0xFFFBAF00),
  brightness: Brightness.light,
  accentColor: Colors.black,
);

final darkThemeConstant = ThemeData(
  scaffoldBackgroundColor: Color(0xFF1A1F23),
  buttonColor: Color(0xFFFFAA33),
  primaryColor: Color(0xFFFFAA33),
  secondaryHeaderColor: Colors.grey[700],
  brightness: Brightness.dark,
  accentColor: Colors.white,
);