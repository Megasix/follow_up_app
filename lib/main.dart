import 'package:flutter/material.dart';
import 'package:follow_up_app/models/user.dart';
import 'package:follow_up_app/screens/wrapper.dart';
import 'package:follow_up_app/services/auth.dart';
import 'package:follow_up_app/shared/constants.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

bool _lightThemeEnabled = false;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        theme: _lightThemeEnabled ? lightThemeConstant : darkThemeConstant,
        darkTheme: darkThemeConstant,
        home: Wrapper(),
      ),
    );
  }
}

bool getTheme() {
  return _lightThemeEnabled;
}

void setTheme(bool lightThemeEnabled) {
  _lightThemeEnabled = lightThemeEnabled;
}
