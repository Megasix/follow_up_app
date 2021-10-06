import 'package:flutter/material.dart';

final textInputDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.yellow[200]!.withOpacity(0.3),
  floatingLabelBehavior: FloatingLabelBehavior.always,
  contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
  enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: Colors.yellow[700]!), borderRadius: BorderRadius.circular(25)),
  focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 4, color: Colors.yellow[700]!), borderRadius: BorderRadius.circular(25)),
  errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 4, color: Colors.red[700]!), borderRadius: BorderRadius.circular(25)),
  focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(width: 4, color: Colors.red[700]!), borderRadius: BorderRadius.circular(25)),
);

//////////////////
/// Light theme ///
//////////////////

final lightThemeConstant = ThemeData(
  backgroundColor: Color(0xFFF5F5F5),
  scaffoldBackgroundColor: Colors.white,
  buttonColor: Color(0xFFFBAF00),
  secondaryHeaderColor: Color(0xFFFBAF00),
  textSelectionColor: Colors.white,
  brightness: Brightness.light,
  accentColor: Colors.grey[400],
  splashColor: Colors.grey,
);

ButtonStyle lightLoginButtonStyle = ButtonStyle(
  foregroundColor: MaterialStateProperty.all(Colors.yellow[700]),
  overlayColor: MaterialStateProperty.all(Colors.yellow[700]!.withOpacity(0.5)),
  backgroundColor: MaterialStateProperty.all(Colors.transparent),
  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(width: 3, color: Colors.yellow[700]!))),
);

//////////////////
/// Dark theme ///
//////////////////

final darkThemeConstant = ThemeData(
  backgroundColor: Color(0xFF1A1F23),
  scaffoldBackgroundColor: Colors.grey[800],
  snackBarTheme: darkSnackBarTheme,
  buttonColor: Color(0xFFFFAA33),
  secondaryHeaderColor: Colors.grey[700],
  textSelectionColor: Colors.grey[800],
  brightness: Brightness.dark,
  accentColor: Colors.grey[600],
  splashColor: Colors.grey,
);

SnackBarThemeData darkSnackBarTheme = SnackBarThemeData(
  behavior: SnackBarBehavior.floating,
  contentTextStyle: TextStyle(color: Colors.grey[800]),
  actionTextColor: Colors.grey[700],
  backgroundColor: Color(0xFFFFAA33),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
);

ButtonStyle darkLoginButtonStyle = ButtonStyle(
  foregroundColor: MaterialStateProperty.all(Colors.yellow[700]),
  overlayColor: MaterialStateProperty.all(Colors.yellow[700]!.withOpacity(0.5)),
  backgroundColor: MaterialStateProperty.all(Colors.transparent),
  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(width: 3, color: Colors.yellow[700]!))),
);
