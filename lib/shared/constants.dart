import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey, width: 2.0)),
);

final lightThemeConstant = ThemeData(
  backgroundColor: Color(0xFFF5F5F5),
  scaffoldBackgroundColor: Colors.white,
  buttonColor: Color(0xFFFBAF00),
  secondaryHeaderColor: Color(0xFFFBAF00),
  brightness: Brightness.light,
  accentColor: Colors.black,
);

final darkThemeConstant = ThemeData(
  backgroundColor: Color(0xFF1A1F23),
  scaffoldBackgroundColor: Colors.grey[800],
  buttonColor: Color(0xFFFFAA33),
  secondaryHeaderColor: Colors.grey[700],
  brightness: Brightness.dark,
  accentColor: Colors.white,
);